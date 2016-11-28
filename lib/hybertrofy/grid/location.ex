defmodule Hybertrofy.Grid.Location do
  @moduledoc """
  Store and Interact with Data at a Coordinate

  This is the basic unit of data for a `Hybertrofy.Grid`.  It holds the specific
  xyz coordinates of it's location and houses data about the location in a
  key-value format.  The data itself can be anything - this is simply the access
  and storage of that data

  The internal structure of the data should be considered opaque and the helper
  methods should be used instead
  """
  defstruct x: 0, y: 0, z: 0, data: %{}

  @doc """
  Returns a location read to store data and associated with supplied xzy
  coordinates.  If no coordinates are supplied it defaults to center, which is
  `%{x: 0, y: 0, z: 0}`
  """
  def new(%{x: x, y: y, z: z} \\ %{x: 0, y: 0, z: 0}) do
    %__MODULE__{x: x, y: y, z: z}
  end

  @doc """
  Given a location and a map, these values are mass applied to the data and the
  updated location is returned
  """
  def update(location=%{data: data}, updates) when is_map(updates) do
    %{ location | data: Map.merge(data, updates) }
  end

  @doc """
  Returns the value of data for given key or default if not found.  If not
  supplied the default is `nil`
  """
  def get(%{data: data}, key, default \\ nil) do
    Map.get(data, key, default)
  end

  @doc """
  Updates data with a supplied key and value.  If you're looking to make
  multiple actions of this at a time you may want to use `update/3` instead
  """
  def put(location=%{data: data}, key, value) do
    %{ location | data: Map.put(data, key, value) }
  end

  @doc """
  Remove data for a location under the given key
  """
  def delete(location=%{data: data}, key) do
    %{ location | data: Map.delete(data, key) }
  end

  @doc """
  Supplied location and radius returns a list of xyz coordinates of the given
  location as well as all locations surrounding within the given radius
  """
  def surrounding_coordinates(%{x: cx, y: cy, z: cz}, radius \\ 1) do
    for x <- -radius..radius,
        y <- max(-radius, -x-radius)..min(radius, -x+radius),
        do: %{x: x+cx, y: y+cy, z: -x-y+cz}
  end

  @doc """
  With given coords or location a "hash" is returned.  While the actual return
  is considered opaque, it can be used to uniquely store and retrive a location
  from storage.  It should be noted that this is is only true as long as there
  are not multiple locations found with the same coordinates.
  """
  def coords_to_hash(coords) when is_list(coords) do
    x = Keyword.fetch!(coords, :x)
    y = Keyword.fetch!(coords, :y)
    z = Keyword.fetch!(coords, :z)
    {x, y, z}
  end
  def coords_to_hash(%{x: x, y: y, z: z}) do
    {x, y, z}
  end
end
