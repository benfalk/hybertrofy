defmodule Hybertrofy.Grid do
  alias Hybertrofy.Grid.Location
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
    locations[coords_to_tuple!(coords)]
  end

  @doc """
  Given a grid, proper xyz coordinates, and a radius returns all locations
  from that coordinate and all that fan out with the given radius distance
  """
  def fetch_locations_by_radius(grid, coords, radius) do
    case fetch_location(grid, coords) do
      nil -> []

      %Location{x: x, y: y, z: z} -> 
        grid_coords({x,y,z}, radius)
        |> Enum.map(fn {x,y,z} -> fetch_location(grid, %{x: x, y: y, z: z}) end)
    end
  end

  @doc """
  Given a grid, xyz coordinates, and data updates location in grid
  """
  def update_location(grid, coords, data) when is_map(data) do
    location = fetch_location(grid, coords)
    updated = %{ location | data: location.data |> Map.merge(data) }
    locations = grid.locations |> Map.put(coords_to_tuple!(coords), updated)

    %{ grid | locations: locations }
  end

  defp grid_coords({cx, cy, cz} \\ {0,0,0}, radius) do
    for x <- -radius..radius, y <- max(-radius, -x-radius)..min(radius, -x+radius) do
      {x+cx, y+cy, -x-y+cz}
    end
  end

  defp init_locations(size) do
    grid_coords(size)
    |> Enum.map(fn {x,y,z}=coords -> {coords, %Location{x: x, y: y, z: z}} end)
    |> Enum.into(%{})
  end

  defp coords_to_tuple!(coords) when is_list(coords) do
    x = Keyword.fetch!(coords, :x)
    y = Keyword.fetch!(coords, :y)
    z = Keyword.fetch!(coords, :z)
    {x, y, z}
  end
  defp coords_to_tuple!(%{x: x, y: y, z: z}) do
    {x, y, z}
  end
end
