defmodule Hybertrofy.Game.SimpleEngine do
  @moduledoc """
  Simple Proof of Concept Game Engine
  """
  alias Hybertrofy.{Game, Grid}

  import Game.Message

  def init(game) do
    {:ok, %{ game |
      players: %{},
      grid: Grid.create(game.opts),
      state: :paused,
      ready?: true
    }}
  end

  def add_player(message, player) do
    cond do
      state(message) != :paused ->
        message |> reply({:error, :already_started})

      players(message) |> Map.keys |> Enum.any?(&(&1==player)) ->
        message |> reply({:error, :already_registered})

      player_count(message) == 6 ->
        message |> reply({:error, :player_limit_reached})

      true ->
        taken_location =
          message
          |> random_available_corner_location
          |> Grid.Location.update(%{available?: false, player: player})

        message
        |> update_players(&Map.put(&1, player, %{locations: [taken_location]}))
        |> update_grid(&Grid.put_location(&1, taken_location))
        |> reply(:ok)
    end
  end

  def start(message) do
    cond do
      player_count(message) < 2 ->
        message |> reply({:error, :not_enough_players})

      state(message) == :over ->
        message |> reply({:error, :game_over})

      true ->
        message
        |> update_state(:running)
        |> reply(:ok)
    end
  end

  def occupied_locations(message, player) do
    message |> reply(fetch_player(message, player).locations)
  end

  def is_player?(message, player) do
    fetch_player(message, player) != nil
  end

  defp fetch_player(message, player),
    do: players(message) |> Map.get(player)

  defp player_count(message),
    do: players(message) |> Enum.count

  defp random_available_corner_location(message) do
    grid = grid(message)
    max_coords = [0, grid.size, -grid.size]

    for x <- max_coords, y <- max_coords do
      %{x: x, y: y, z: -x-y}
    end
    |> Enum.reject(fn %{x: x, y: y} -> x == y end)
    |> Enum.map(&Grid.fetch_location(grid, &1))
    |> Enum.filter(&Grid.Location.get(&1, :available?, true))
    |> Enum.take_random(1)
    |> List.first
  end
end
