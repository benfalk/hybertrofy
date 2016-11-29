defmodule Hybertrofy.GameTest do
  use ExUnit.Case, async: true

  alias Hybertrofy.Game

  test "game with no options can start" do
    assert {:ok, game} = Game.start_link
    assert is_pid(game)
  end

  describe "default game of SimpleEngine" do
    setup :create_game

    test "should be able to add a player", %{game: game} do
      assert :ok = Game.add_player(game, "ben")
    end

    @tag players: ~w(ben)
    test "should not allow duplicate players", %{game: game} do
      assert {:error, :already_registered} = Game.add_player(game, "ben")
    end

    test "has a limit on players", %{game: game} do
      players = Enum.map(1..6, &("player-#{&1}"))
      assert Enum.map(players, &Game.add_player(game, &1)) |> Enum.all?(&(&1==:ok))
      assert {:error, :player_limit_reached} = Game.add_player(game, "ben")
    end

    test "starting a game with under two players doesn't work", %{game: game} do
      assert {:error, :not_enough_players} = Game.start(game)
    end

    @tag players: ~w(player1 player2)
    test "can start with two players", %{game: game} do
      assert :ok = Game.start(game)
    end
  end

  describe "SimpleEngine gameplay" do
    setup [:create_game, :add_players, :start_game]

    test "cannot join a game already started", %{game: game} do
      assert {:error, :already_started} == Game.add_player(game, "rodger")
    end

    test "players can retreive occupied locations", %{game: game} do
      assert [player1_loc] = Game.occupied_locations(game, "player1")
      assert [player2_loc] = Game.occupied_locations(game, "player2")
      refute player1_loc == player2_loc
    end

    test "non-player occupied locations call fails", %{game: game} do
      assert {:error, :not_a_player} = Game.occupied_locations(game, "ben")
    end
  end

  defp create_game(_) do
    {:ok, game} = Game.start_link
    {:ok, game: game}
  end

  defp add_players(%{game: game}) do
    players = ~w(player1 player2)
    players |> Enum.each(&Game.add_player(game, &1))
    {:ok, player: players}
  end

  defp start_game(%{game: game}) do
    :ok = Game.start(game)
  end

  setup context do
    case {context[:players], context[:game]} do
      {nil, _} -> :ok
      {_, nil} -> :ok
      {players, game} when is_list(players) ->
        Enum.map(players, &Game.add_player(game, &1))
        {:ok, players: players}
    end
  end
end
