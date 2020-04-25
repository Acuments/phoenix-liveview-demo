defmodule DemoWeb.StoreTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DemoWeb.Store

  @initialState %{items: []}
  @empty nil

  describe "DemoWeb.Store" do

    setup do
      Store.clearCache
      Store.init
      :ok
    end

    test "#init" do
      {:ok, initialState} = Cachex.get(:my_cache, "global")
      assert initialState == @initialState
    end

    test "#get_phones" do
      phones = Store.get_phones
      assert Enum.count(phones) == 4
    end

    test "#phone_count" do
      assert Store.phone_count == 12
    end

    test "#clearCache" do
      {:ok, initialState} = Cachex.get(:my_cache, "global")
      assert initialState == @initialState
      Store.clearCache
      {:ok, initialState} = Cachex.get(:my_cache, "global")
      assert initialState == @empty
    end

    test "#get_all_phones" do
      assert Enum.count(Store.get_all_phones) == 12
    end

    test "#get_item_by_id" do
      item = Store.get_item_by_id(Integer.to_string(1))
      allPhones = Store.get_all_phones
      assert item == Enum.at(allPhones, 0)
      item = Store.get_item_by_id(Integer.to_string(0))
      assert item == @empty
    end

    test "#decrement_item_in_cart" do
      {_, cache} = Cachex.get(:my_cache, "global")
      items = [%{Store.get_item_by_id(Integer.to_string(1)) | count: 1}]
      initialState = %{ @initialState | items:  items}
      Cachex.set(:my_cache, "global", initialState)
      items = Store.decrement_item_in_cart(Integer.to_string(1))
      assert items == cache.items
    end

    test "#delete_item_from_cart" do
      {_, cache} = Cachex.get(:my_cache, "global")
      items = [%{Store.get_item_by_id(Integer.to_string(1)) | count: 1}]
      initialState = %{ @initialState | items:  items}
      Cachex.set(:my_cache, "global", initialState)
      items = Store.delete_item_from_cart(Integer.to_string(1))
      assert items == cache.items
    end
  end
end