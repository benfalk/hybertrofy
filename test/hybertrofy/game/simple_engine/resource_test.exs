defmodule Hybertrofy.Game.SimpleEngine.ResourceTest do
  use ExUnit.Case, async: true
  alias Hybertrofy.Game.SimpleEngine.Resource

  describe "normal resource values" do
    setup _ do
      {:ok, resource: Resource.new(:foo, rate: 4, current: 5, max: 7)}
    end

    test "#rate/1", %{resource: res} do
      assert Resource.rate(res) == 4
    end

    test "#rate/2", %{resource: res} do
      assert Resource.rate(res, 7) == 4
    end

    test "#max/1", %{resource: res} do
      assert Resource.max(res) == 7
    end

    test "#max/2", %{resource: res} do
      assert Resource.max(res, "??") == 7
    end

    test "#current/1", %{resource: res} do
      assert Resource.current(res) == 5
    end

    test "#increment/2", %{resource: res} do
      assert Resource.increment(res, 1).current == 6
    end

    test "#increment/2 won't exceed max", %{resource: res} do
      assert Resource.increment(res, 5).current == 7
    end
  end

  describe "dynamic resource values" do
    setup _ do
      double =
        fn
          val when is_number(val) -> val * 2
          _any -> 0
        end

      {:ok, resource: Resource.new(:foo, rate: double, max: double)}
    end

    test "#rate/1", %{resource: res} do
      assert Resource.rate(res) == 0
    end

    test "#rate/2", %{resource: res} do
      assert Resource.rate(res, 5) == 10
    end

    test "#max/1", %{resource: res} do
      assert Resource.max(res) == 0
    end

    test "#max/2", %{resource: res} do
      assert Resource.max(res, 5) == 10
    end
  end

  describe "compound resource values" do
    test "#rate/2 adds seperate values together" do
      res = Resource.new(:foo, rate: &(&1 * 2), rate: &(-(div(&1, 2))))
      assert Resource.rate(res, 4) == 6
    end

    test "#new/2 can accept a list for rate" do
      res = Resource.new(:foo, rate: [&(&1 * 2), &(-(div(&1, 2)))])
      assert Resource.rate(res, 4) == 6
    end

    test "#new/2 can accept a list for max" do
      res = Resource.new(:foo, max: [&(&1 * 2), &(-(div(&1, 2)))])
      assert Resource.max(res, 4) == 6
    end

    test "#rate/2 works with flat values and funs" do
      res = Resource.new(:foo, rate: &(&1 * 2), rate: -4)
      assert Resource.rate(res, 3) == 2
    end
  end
end
