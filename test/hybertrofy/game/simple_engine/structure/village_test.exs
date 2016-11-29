defmodule Hybertrofy.Game.SimpleEngine.Structure.VillageTest do
  use ExUnit.Case, async: true
  use Hybertrofy.Game.SimpleEngine.Structure
  alias Hybertrofy.Game.SimpleEngine.{Location, Resource}

  setup _, do: {:ok, location: Location.new}

  describe "#build_on with location" do
    setup %{location: loc} do
      {:ok, location} = Village.build_on(loc)
      {:ok, location: location}
    end

    test "limit one per location", %{location: loc} do
      assert {:error, "limit one per location"} == Village.build_on(loc)
    end

    test "there should be 10 villagers", %{location: loc} do
      assert Location.resource(loc, :villager).current == 10
    end

    test "there should be 50 max resource limit for food", %{location: loc} do
      assert Location.resource(loc, :food).max == 50
    end

    test "there should be 50 max resource limit for stone", %{location: loc} do
      assert Location.resource(loc, :stone).max == 50
    end

    test "there should be 50 max resource limit for ore", %{location: loc} do
      assert Location.resource(loc, :ore).max == 50
    end

    test "there should be 50 max resource limit for lumber", %{location: loc} do
      assert Location.resource(loc, :lumber).max == 50
    end

    test "there should be a rate of 10 food", %{location: loc} do
      assert Location.resource(loc, :food).rate == 10
    end

    test "as the villagers increase the food rate changes", %{location: loc} do
      more_villagers = %{id: :x, resources: Resource.Collection.new(villager: [current: 2])}
      more_villagers = Location.add_structure(loc, more_villagers)
      assert Location.resource(more_villagers, :food).rate == 8
    end
  end

  describe "#available_actions/2" do
    setup %{location: loc} do
      {:ok, location} = Village.build_on(loc)
      {:ok, location: location}
    end

    test "should include `create_villager`" do
      # TODO
    end
  end
end
