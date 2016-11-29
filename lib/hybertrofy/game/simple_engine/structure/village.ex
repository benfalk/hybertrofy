defmodule Hybertrofy.Game.SimpleEngine.Structure.Village do

  alias Hybertrofy.Game.SimpleEngine.{Location, Resource}

  @default_resources Resource.Collection.new(
    villager: [max: :infinity, current: 10],
        food: [max: 50, current: 20,
               rate: &__MODULE__.villager_consumption/1,
               rate: &__MODULE__.food_production/1],
       stone: [max: 50],
         ore: [max: 50],
      lumber: [max: 50]
  )

  defstruct id: :village, resources: @default_resources

  def build_on(%{structures: %{village: _}}) do
    {:error, "limit one per location"}
  end
  def build_on(location) do
    {:ok, Location.add_structure(location, %__MODULE__{})}
  end

  def available_actions(%__MODULE__{}=_village, _location) do
    # TODO need an action contract
    raise "not implemented"
  end

  def villager_consumption(location) do
    - Location.resource(location, :villager).current
  end

  def food_production(location) do
    case Location.resource(location, :villager).current do
      amount when amount > 10 -> 20
      amount -> amount * 2
    end
  end
end
