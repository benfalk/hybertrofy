defmodule Hybertrofy.GridTest do
  use ExUnit.Case, async: true
  alias Hybertrofy.Grid
  alias Hybertrofy.Grid.Location

  test "you can create a grid of a certain size" do
    grid = Grid.create(size: 1)

    assert grid.size == 1
    assert grid.locations |> Enum.count == 7
    assert grid.locations[{0, 1, -1}] == %Location{x: 0, y: 1, z: -1}
    assert grid.locations[{1, 0, -1}] == %Location{x: 1, y: 0, z: -1}
    assert grid.locations[{-1, 1, 0}] == %Location{x: -1, y: 1, z: 0}
    assert grid.locations[{0, 0, 0}] == %Location{x: 0, y: 0, z: 0}
    assert grid.locations[{1, -1, 0}] == %Location{x: 1, y: -1, z: 0}
    assert grid.locations[{-1, 0, 1}] == %Location{x: -1, y: 0, z: 1}
    assert grid.locations[{0, -1, 1}] == %Location{x: 0, y: -1, z: 1}
  end

  test "you can pluck a grid by coordinates" do
    grid = Grid.create(size: 5)

    assert Grid.fetch_location(grid, x: 0, y: 0, z: 0) == %Location{x: 0, y: 0, z: 0}
    assert Grid.fetch_location(grid, z: 1, y: -1, x: 0) == %Location{x: 0, y: -1, z: 1}
    refute Grid.fetch_location(grid, x: 99, y: 12, z: 9)

    assert Grid.fetch_location(grid, %{x: 0, y: 0, z: 0}) == %Location{x: 0, y: 0, z: 0}
    assert Grid.fetch_location(grid, %{z: 1, y: -1, x: 0}) == %Location{x: 0, y: -1, z: 1}
    refute Grid.fetch_location(grid, %{x: 99, y: 12, z: 9})
  end

  test "you can update a location" do
    grid = Grid.create(size: 5)

    first = Grid.update_location(grid, [x: 0, y: 0, z: 0], %{tile: "green"})
    assert %Location{data: %{tile: "green"}} = first.locations[{0, 0, 0}]

    second = Grid.update_location(first, %{x: 0, y: 0, z: 0}, %{tile: "blue", dark: true})
    assert %Location{data: %{tile: "blue", dark: true}} = second.locations[{0, 0, 0}]

    location = %Location{data: %{foo: "bar"}, x: 1, y: 1, z: -2}
    third = Grid.put_location(grid, location)
    assert location == third.locations[{1, 1, -2}]
  end

  test "you can get a sub-section of loctions by radius" do
    grid = Grid.create(size: 20)

    invalid_coords = %{x: -1, y: -1, z: -1}
    center_coords = %{x: 0, y: 0, z: 0}
    corner_coords = %{x: 0, y: 20, z: -20}

    assert Grid.fetch_locations_by_radius(grid, invalid_coords, 5) == []

    valid_loctions = Grid.fetch_locations_by_radius(grid, center_coords, 1)

    assert valid_loctions |> Enum.count == 7
    assert %Location{x: 0, y: 1, z: -1} in valid_loctions
    assert %Location{x: 1, y: 0, z: -1} in valid_loctions
    assert %Location{x: -1, y: 1, z: 0} in valid_loctions
    assert %Location{x: 0, y: 0, z: 0} in valid_loctions
    assert %Location{x: 1, y: -1, z: 0} in valid_loctions
    assert %Location{x: -1, y: 0, z: 1} in valid_loctions
    assert %Location{x: 0, y: -1, z: 1} in valid_loctions

    corner_locs = Grid.fetch_locations_by_radius(grid, corner_coords, 2)

    assert corner_locs |> Enum.count == 9
  end
end
