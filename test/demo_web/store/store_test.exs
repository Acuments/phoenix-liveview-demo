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

    test "#getItemById" do
      Store.init
      item = Store.getItemById(Integer.to_string(1))
      allPhones = Store.getAllPhones
      assert item == Enum.at(allPhones, 0)
      item = Store.getItemById(Integer.to_string(0))
      assert item == @empty
    end

    test "#decrementItemInCart" do
      Store.init
      {_, cache} = Cachex.get(:my_cache, "global")
      items = [%{Store.getItemById(Integer.to_string(1)) | count: 1}]
      initialState = %{ @initialState | items:  items}
      Cachex.set(:my_cache, "global", initialState)
      items = Store.decrementItemInCart(Integer.to_string(1))
      assert items = cache.items
    end

    test "#deleteItemFromCart" do
      Store.init
      {_, cache} = Cachex.get(:my_cache, "global")
      items = [%{Store.getItemById(Integer.to_string(1)) | count: 1}]
      initialState = %{ @initialState | items:  items}
      Cachex.set(:my_cache, "global", initialState)
      items = Store.deleteItemFromCart(Integer.to_string(1))
      assert items = cache.items
    end
  end
end