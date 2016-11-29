defmodule Hybertrofy.Game.SimpleEngine.Action do
  defstruct name: "", description: "", parameters: %{}

  def new(name, opts) do
    %__MODULE__{name: name} |> opts_to_parameters(opts)
  end

  def new(name, desc, opts)  do
    %__MODULE__{name: name, description: desc} |> opts_to_parameters(opts)
  end

  defp opts_to_parameters(action, opts) do
    Enum.reduce opts, action, fn {key, val}, action ->
      put_in(action.parameters[key], val)
    end
  end
end
