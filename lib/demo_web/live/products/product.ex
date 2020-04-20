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

  def handle_event("delete-item", %{"id" => id}, socket) do
    {:noreply, update(socket, :items, &(&1 = Store.deleteItemFromCart(id)))}
  end

  def getCurrentItem(i_d) do
    Enum.filter(Store.getAllPhones, fn(phone) ->
      phone.id == i_d
    end)
  end

  def handle_event("open-cart", _, socket) do
    {:noreply, update(socket, :isCartOpen, &(!&1))}
  end

  def handle_event("inc", %{"id" => id}, socket) do
    searchItem = Store.getItemById(id)
    items = socket.assigns.items
    test = true
    mod_items = Enum.map(items, fn(item) ->
      if (item.id == String.to_integer(id)) do
        %{item | count: item.count + 1}
      else
        item
      end
    end)
    socket = assign(socket, :items, mod_items)
    {_, cache} = Cachex.get(:my_cache, "global")
    if (socket.changed === %{} or !socket.changed.items) do
      items = mod_items ++ [ %{ searchItem | count: 1 } ]
      cache = Map.put(cache, :items, items)
      Cachex.set(:my_cache, "global", cache)
      socket = assign(socket, message: "Product Added To Cart Successfully")
      {:noreply, update(socket, :items, &(&1 = items))}
    else
      cache = Map.put(cache, :items, mod_items)
      Cachex.set(:my_cache, "global", cache)
      socket = assign(socket, message: "Product Added To Cart Successfully")
      {:noreply, update(socket, :items, &(&1 = mod_items))}
    end
  end

  def handle_event("dec", %{"id" => id}, socket) do
    after_remove = Store.decrementItemInCart(id)
    socket = update(socket, :items, &(&1 = after_remove))
    socket = assign(socket, message: "Product Deleted From Cart Successfully!")
    {:noreply, socket}
  end

  def handle_event("close-alert", _, socket) do
    {:noreply, assign(socket, message: "")}
  end
end