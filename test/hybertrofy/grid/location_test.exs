defmodule Hybertrofy.Grid.LocationTest do
  use ExUnit.Case, async: true
  alias Hybertrofy.Grid.Location

  test "new with default coords" do
    assert Location.new == %Location{}
  end

  test "new with provided coords" do
    assert Location.new(%{x: 1, y: 0, z: -1}) == %Location{x: 1, y: 0, z: -1}
  end

  test "update fresh location" do
    location = Location.new |> Location.update(%{foo: "foo", bar: "bar"})
    assert location |> Location.get(:foo) == "foo"
    assert location |> Location.get(:bar) == "bar"
  end

  test "update existing data" do
    location =
      Location.new
      |> Location.update(%{foo: "foo", bar: "bar"})
      |> Location.update(%{foo: "baz", bar: "baz"})

    assert location |> Location.get(:foo) == "baz"
    assert location |> Location.get(:bar) == "baz"
  end

  test "get with default value" do
    assert Location.new |> Location.get(:nope, "nope") == "nope"
  end

  test "delete values of data" do
    location = Location.new |> Location.put(:foo, "foo")

    assert location |> Location.get(:foo) == "foo"
    refute location |> Location.delete(:foo) |> Location.get(:foo)
  end

  test "surrounding_coordinates" do
    coords =
      Location.new(%{x: 1, y: 0, z: -1})
      |> Location.surrounding_coordinates

    assert coords |> Enum.count == 7
    assert %{x: 0, y:  0, z:  0} in coords
    assert %{x: 0, y:  1, z: -1} in coords
    assert %{x: 1, y: -1, z:  0} in coords
    assert %{x: 1, y:  0, z: -1} in coords
    assert %{x: 1, y:  1, z: -2} in coords
    assert %{x: 2, y: -1, z: -1} in coords
    assert %{x: 2, y:  0, z: -2} in coords
  end

  test "coords_to_hash is consistent" do
    import Location, only: [coords_to_hash: 1]
    location1 = Location.new
    location2 = Location.new(%{x: 2, y:  0, z: -2})

    assert coords_to_hash(location1) == coords_to_hash(location1)
    refute coords_to_hash(location1) == coords_to_hash(location2)
  end
end
