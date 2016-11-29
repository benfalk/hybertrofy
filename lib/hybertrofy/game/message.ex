defmodule Hybertrofy.Game.Message do
  @moduledoc """
  Helper that allows engines to work with a more verbose state that
  is a little bit higher then that of GenServer
  """
  defstruct from: nil, state: %{}, response: :ok, type: :reply

  def new(state), do: %__MODULE__{state: state}

  def new(state, [{:from, from}]) do
    %__MODULE__{state: state, from: from}
  end
  def new(state, opts) do
    %__MODULE__{
      state: state,
      from: Keyword.get(opts, :from, nil),
      response: Keyword.get(opts, :response, :ok),
      type: Keyword.get(opts, :type, :reply)
    }
  end

  def as_genserver_message(%{type: :reply}=message),
    do: {:reply, message.response, message.state}

  def players(%{state: %{players: players}}), do: players
  def state(%{state: %{state: state}}), do: state
  def grid(%{state: %{grid: grid}}), do: grid

  def update_players(%{state: %{players: players}}=msg, fun)
    when is_function(fun, 2),
    do: put_in(msg.state.players, fun.(players, msg))
  def update_players(%{state: %{players: players}}=msg, fun)
    when is_function(fun, 1),
    do: put_in(msg.state.players, fun.(players))
  def update_players(%{state: %{players: _}}=msg, fun)
    when is_function(fun, 0),
    do: put_in(msg.state.players, fun.())
  def update_players(%{state: %{players: _}}=msg, data),
    do: put_in(msg.state.players, data)

  def update_state(%{state: %{state: state}}=msg, fun)
    when is_function(fun, 2),
    do: put_in(msg.state.state, fun.(state, msg))
  def update_state(%{state: %{state: state}}=msg, fun)
    when is_function(fun, 1),
    do: put_in(msg.state.state, fun.(state))
  def update_state(%{state: %{state: _}}=msg, fun)
    when is_function(fun, 0),
    do: put_in(msg.state.state, fun.())
  def update_state(%{state: %{state: _}}=msg, data),
    do: put_in(msg.state.state, data)

  def update_grid(%{state: %{grid: grid}}=msg, fun)
    when is_function(fun, 2),
    do: put_in(msg.state.grid, fun.(grid, msg))
  def update_grid(%{state: %{grid: grid}}=msg, fun)
    when is_function(fun, 1),
    do: put_in(msg.state.grid, fun.(grid))
  def update_grid(%{state: %{grid: _}}=msg, fun)
    when is_function(fun, 0),
    do: put_in(msg.state.grid, fun.())
  def update_grid(%{state: %{grid: _}}=msg, data),
    do: put_in(msg.state.grid, data)


  def is_player?(%{state: %{engine: engine}}=msg, player),
    do: engine.is_player?(msg, player)

  def call_engine(%{state: %{engine: engine}}=msg, method, args \\ []) do
    engine
    |> apply(method, [msg|args])
    |> as_genserver_message
  end

  def reply(message, response) do
    %{ message | response: response, type: :reply }
  end
end
