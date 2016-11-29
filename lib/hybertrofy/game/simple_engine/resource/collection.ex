defmodule Hybertrofy.Game.SimpleEngine.Resource.Collection do

  alias Hybertrofy.Game.SimpleEngine.Resource

  def new, do: %{}

  def new(data) when is_list(data) do
    if Keyword.keyword?(data) do
      Enum.reduce(data, %{resources: new}, fn {name, opts}, collection ->
        add_resource(collection, Resource.new(name, opts))
      end)
      |> Map.get(:resources)
    else
      for name <- data, do: {name, Resource.new(name)}, into: %{}
    end
  end

  def get_resource(%{resources: data}, name),
    do: Map.get(data, name, Resource.new(name))

  def add_resource(%{resources: _}=collection, %Resource{name: name}=resource) do
    existing = get_resource(collection, name)
    put_in(collection.resources[name], Resource.add(existing, resource))
  end

  def combine_resources(%{resources: _}=collection, %{resources: resources}) do
    Map.values(resources)
    |> Enum.reduce(collection, &add_resource(&2, &1))
  end

  def increment_resource(collection, name, amount, context \\ nil) do
    resource = get_resource(collection, name) |> Resource.increment(amount, context)
    put_in(collection.resources[name], resource)
  end
end
