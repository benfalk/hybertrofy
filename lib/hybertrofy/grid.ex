defmodule Hybertrofy.Grid do
  @moduledoc """
  Calculate and Interact with a Grid Game Board

  This is a basic "hex" grid with xyz coordinates for each axis that you can
  travel along in a such a grid.  Further more this models a "flat" hexagon;
  meaning that the top and bottom are flat.  Each location is also a hexagon
  but can be thought of as having a "pointed" top and bottom.  This leads to
  each axis transversing along the grid as such:

  * x axis goes diagonal from top left to bottom right
  * y axis goes diagonal from bottom left to top right
  * z axis goes flat left to right

  With a given grid of a size for three for instance, the top left most
  coordinate should be %{x: 0, y: 3, z: -3} with the center having coordinates
  of %{x: 0, y: 0, z: 0}
  """

  alias Hybertrofy.Grid.Location
  import Location, only: [coords_to_hash: 1]

  @default_size 5

  defstruct size: @default_size, locations: %{}

  @doc """
  Builds a grid based on given criteria

  Accepts a size, which determines the distance from any edge that it would
  take to get to the center of the grid.
  """
  def create(opts \\ []) do
    size = Keyword.get(opts, :size, @default_size)

    %__MODULE__{size: size, locations: init_locations(size)}
  end

  @doc """
  Given a grid and proper xyz coordinates returns the location
  """
  def fetch_location(%{locations: locations}, coords) do
    Map.get(locations, coords_to_hash(coords), nil)
  end

  @doc """
  Adds or overwrites location for the given lodging coordinates in a grid
  """
  def put_location(%{locations: locations}=grid, coords, location=%Location{}) do
    %{ grid | locations: Map.put(locations, coords_to_hash(coords), location) }
  end

  @doc """
  Adds or overwrites location in a grid, uses the coordinates of the
  location to determine where it belongs.
  """
  def put_location(grid, location=%Location{}) do
    put_location(grid, location, location)
  end

  @doc """
  Given a grid, proper xyz coordinates, and a radius returns all locations
  from that coordinate and all that fan out with the given radius distance
  """
  def fetch_locations_by_radius(grid, coords, radius) do
    case fetch_location(grid, coords) do
      nil -> []

      location ->
        Location.surrounding_coordinates(location, radius)
        |> Enum.map(&fetch_location(grid, &1))
        |> Enum.reject(&is_nil/1)
    end
  end

  @doc """
  Given a grid, xyz coordinates, and data updates location in grid.  This is
  a quick way to pull a location and update it as you would similarly with
  `Hybertrofy.Grid.Location.update/2`
  """
  def update_location(grid, coords, data) when is_map(data) do
    location = fetch_location(grid, coords) |> Location.update(data)
    grid |> put_location(coords, location)
  end

  defp init_locations(size) do
    Location.new
    |> Location.surrounding_coordinates(size)
    |> Enum.map(&{coords_to_hash(&1), Location.new(&1)})
    |> Enum.into(%{})
  end
end
