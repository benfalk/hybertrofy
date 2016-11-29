defmodule Hybertrofy.Game.SimpleEngine.LocationTest do
  use ExUnit.Case, async: true
  use Hybertrofy.Game.SimpleEngine.Structure

  alias Hybertrofy.Game.SimpleEngine.{Location, Resource}

  setup _ do
    {:ok, location: Location.new}
  end

  @five_of_200 [current: 5, max: 200]

  describe "#resource/2" do
    setup %{location: loc} do
      resources = Resource.Collection.new(foo: @five_of_200)
      {:ok, location: %{ loc | resources: resources }}
    end

    test "found resources are returned", %{location: loc} do
      assert Location.resource(loc, :foo).current == 5
    end

    test "missing resources are returned empty", %{location: loc} do
      assert Location.resource(loc, :bar).current == 0
      assert Location.resource(loc, :bar).name == :bar
    end
  end

  describe "#add_structure/2" do
    setup _ do
      foo = %{id: :foo, resources: Resource.Collection.new(foo: @five_of_200)}
      bar = %{id: :bar, resources: Resource.Collection.new(bar: @five_of_200)}
      foo_bar = %{
        id: :foo_bar,
        resources: Resource.Collection.new(bar: @five_of_200, foo: @five_of_200)
      }
      {:ok, foo: foo, bar: bar, foo_bar: foo_bar}
    end

    test "the resources are reported on adding", %{location: loc, foo: foo} do
      location = Location.add_structure(loc, foo)
      assert Location.resource(location, :foo).current == 5
    end

    test "mulitple places", %{location: loc, foo: foo, foo_bar: foo_bar} do
      location = loc
        |> Location.add_structure(foo)
        |> Location.add_structure(foo_bar)

      assert Location.resource(location, :foo).current == 10
      assert Location.resource(location, :bar).current == 5
    end

    test "adding same structure twice", %{location: loc, foo: foo, bar: bar} do
      location = loc
        |> Location.add_structure(foo)
        |> Location.add_structure(bar)
        |> Location.add_structure(foo)

      assert Location.resource(location, :foo).current == 5
      assert Location.resource(location, :bar).current == 5
    end

    test "adding updated structure", %{location: loc, foo: foo} do
      new_foo = Resource.Collection.increment_resource(foo, :foo, 12)

      location = loc
        |> Location.add_structure(foo)
        |> Location.add_structure(new_foo)

      assert Location.resource(location, :foo).current == 17
    end
  end

  describe "applying a `tick`" do
  end

  test "location is there", %{location: loc} do
    assert loc
  end
end
