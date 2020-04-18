defmodule DemoWeb.StoreTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DemoWeb.Store

  @initialState(%{count: 0, isOpen: false, items: [], test_state_var: "test"})
  @empty(nil)

  describe "DemoWeb.Store" do
    test "#init" do
      Store.clearCache
      Store.init
      {:ok, initialState} = Cachex.get(:my_cache, "global")
      assert initialState == @initialState
    end

    test "#getPhones" do
      Store.clearCache
      phones = Store.getPhones
      assert Enum.count(phones) == 4
    end

    test "#phoneCount" do
      Store.clearCache
      assert Store.phoneCount == 12
    end

    test "#clearCache" do
      Store.init
      {:ok, initialState} = Cachex.get(:my_cache, "global")
      assert initialState == @initialState
      Store.clearCache
      {:ok, initialState} = Cachex.get(:my_cache, "global")
      assert initialState == @empty
    end

    test "#getAllPhones" do
      assert Enum.count(Store.getAllPhones) == 12
    end
  end
end