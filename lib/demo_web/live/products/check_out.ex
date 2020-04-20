defmodule DemoWeb.ProductsLive.CheckOut do
  use Phoenix.LiveView
  alias DemoWeb.Store, as: Store

  def render(assigns) do
    DemoWeb.ProductsView.render("check_out.html", assigns)
  end

  def mount(_params, _session, socket) do
    Store.init
    {_, cache} = Cachex.get(:my_cache, "global")
    {:ok, assign(
      socket,
      phones: Store.getPhones,
      isCartOpen: false,
      items: cache.items,
      phoneCount: Store.phoneCount,
      perPage: 4,
      page: 1,
      message: ""
    )}
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
    if (socket.changed === %{} or !socket.changed.items) do
      items = mod_items ++ [ %{ searchItem | count: 1 } ]
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

  def handle_event("dec", %{"id" => id}, socket) do
    after_remove = Store.decItemFromCard(id)
    socket = update(socket, :items, &(&1 = after_remove))
    socket = assign(socket, message: "Product Deleted From Cart Successfully!")
    {:noreply, socket}
  end

  def handle_event("delete-item", %{"id" => id}, socket) do
    {:noreply, update(socket, :items, &(&1 = Store.deleteItemFromCart(id)))}
  end

end