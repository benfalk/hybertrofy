defmodule Hybertrofy.Game.SimpleEngine.Location do

  alias Hybertrofy.Game.SimpleEngine.Resource
  import Resource.Collection, only: [get_resource: 2, combine_resources: 2]

  defstruct structures: %{}, resources: Resource.Collection.new

  def new() do
    %__MODULE__{}
  end

  def resource(data, which) do
    get_resource(data, which) |> Resource.calculate(data)
  end

  def add_structure(%{structures: structures}=data, %{id: id}=structure) do
    previous = structures |> Map.get(id)
    do_add_structure(data, previous, structure)
  end

  def remove_structure(%{structures: structures}=data, %{id: id}) do
    emptied_location = %{ data | resources: Resource.Collection.new, structures: %{} }

    structures
    |> Map.delete(id)
    |> Map.values
    |> Enum.reduce(emptied_location, &add_structure(&2, &1))
  end

  defp do_add_structure(%{structures: structures}=data, nil, %{id: id}=structure) do
    data
    |> combine_resources(structure)
    |> Map.put(:structures, Map.put(structures, id, structure))
  end
  defp do_add_structure(data, same, same), do: data
  defp do_add_structure(data, prev, next),
    do: data |> remove_structure(prev) |> add_structure(next)
end
