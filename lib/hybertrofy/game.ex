defmodule Hybertrofy.Game do
  @moduledoc """
  Compose and Run a Game
  """

  use GenServer

  alias Hybertrofy.Game

  import Hybertrofy.Game.Message
  import Logger, only: [error: 1]

  @default_engine Game.SimpleEngine

  defstruct players: nil, grid: nil, state: nil,
            engine: nil, ready?: false, opts: [],
            game: nil

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def add_player(game, player) do
    GenServer.call(game, {:add_player, player})
  end

  def occupied_locations(game, player) do
    GenServer.call(game, {:occupied_locations, player})
  end

  def start(game), do: GenServer.call(game, :start)

  ## GenServer Callbacks

  def init(opts) do
    state = fresh_state(opts)

    case state.engine.init(state) do
      {:ok, state} ->
        {:ok, state}

      {:error, reason} ->
        error """
              [#{state.engine}] GameEngine Failed to Start
              Reason: #{inspect reason}
              """
        {:stop, reason}
    end
  end

  def handle_call(:start, pid, state) do
    new(state, from: pid) |> call_engine(:start)
  end

  def handle_call({:add_player, player}, pid, state) do
    new(state, from: pid) |> call_engine(:add_player, [player])
  end

  def handle_call({:occupied_locations, player}, pid, state) do
    new(state, from: pid) |> player_request(:occupied_locations, [player])
  end

  defp fresh_state(opts) do
    %__MODULE__{
      game: self,
      opts: opts,
      engine: Keyword.get(opts, :engine, @default_engine)
    }
  end

  defp player_request(message, action, args) do
    if is_player?(message, hd(args)) do
      message |> call_engine(action, args)
    else
      message
      |> reply({:error, :not_a_player})
      |> as_genserver_message
    end
  end
end
