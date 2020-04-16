defmodule DemoWeb.ProductsLive.Product do
  use Phoenix.LiveView
  alias DemoWeb.Store, as: Store

  def render(assigns) do
    DemoWeb.ProductsView.render("product.html", assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    {i_d, _} = Integer.parse(id)
    Store.init
    {_, cache} = Cachex.get(:my_cache, "global")
    phone = getCurrentItem(i_d)
    [currentItem | _] = phone
    {:ok, assign(
      socket,
      isCartOpen: false,
      items: cache.items,
      currentItem: currentItem,
      message: ""
    )}
  end

  def handle_event("delete-item", %{"name" => name}, socket) do
    items = socket.assigns.items
    mod_items = Enum.filter(items, fn(item) ->
      item.name != name
    end)
    {_, cache} = Cachex.get(:my_cache, "global")
    cache = Map.put(cache, :items, mod_items)
    Cachex.put(:my_cache, "global", cache)
    {:noreply, update(socket, :items, &(&1 = mod_items))}
  end

  def getCurrentItem(i_d) do
    Enum.filter(Store.getAllPhones, fn(phone) ->
      phone.id == i_d
    end)
  end

  def handle_event("open-cart", _, socket) do
    {:noreply, update(socket, :isCartOpen, &(!&1))}
  end

  def handle_event("inc", %{"name" => name, "price" => price}, socket) do

    items = socket.assigns.items
    test = true
    mod_items = Enum.map(items, fn(item) ->
      if (item.name === name) do
        %{
          name: item.name,
          count: item.count + 1,
          price: item.price,
        }
      else
        item
      end
    end)
    socket = assign(socket, :items, mod_items)
    if (socket.changed === %{} or !socket.changed.items) do
      items = mod_items ++ [%{ name: name, count: 1, price: price}]
      {_, cache} = Cachex.get(:my_cache, "global")
      cache = Map.put(cache, :items, items)
      Cachex.set(:my_cache, "global", cache)
      socket = assign(socket, message: "Product Added To Cart Successfully")
      {:noreply, update(socket, :items, &(&1 = items))}
    else
      {_, cache} = Cachex.get(:my_cache, "global")
      cache = Map.put(cache, :items, mod_items)
      Cachex.set(:my_cache, "global", cache)
      socket = assign(socket, message: "Product Added To Cart Successfully")
      {:noreply, update(socket, :items, &(&1 = mod_items))}
    end
  end

  def handle_event("dec", %{"name" => name}, socket) do
    items = socket.assigns.items
    mod_items = Enum.map(items, fn(item) ->
      if (item.name === name) do
        %{
          name: item.name,
          count: item.count - 1,
          price: item.price
        }
      else
        item
      end
    end)
    after_remove = Enum.filter(mod_items, fn(item) ->
      item.count !== 0
    end)
    {_, cache} = Cachex.get(:my_cache, "global")
    cache = Map.put(cache, :items, after_remove)
    Cachex.put(:my_cache, "global", cache)
    socket = assign(socket, message: "Product Deleted From Cart Successfully!")
    {:noreply, update(socket, :items, &(&1 = after_remove))}
  end

  def handle_event("close-alert", _, socket) do
    {:noreply, assign(socket, message: "")}
  end
end