defmodule DemoWeb.ProductsLive.Product do
  use Phoenix.LiveView
  alias DemoWeb.Store, as: Store

  def render(assigns) do
    DemoWeb.ProductsView.render("product.html", assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    {id, _} = Integer.parse(id)
    Store.init
    {_, cache} = Cachex.get(:my_cache, "global")
    phone = getCurrentItem(id)
    [currentItem | _] = phone
    {:ok, assign(
      socket,
      is_cart_open: false,
      items: cache.items,
      currentItem: currentItem,
      message: ""
    )}
  end

  def handle_event("delete-item", %{"id" => id}, socket) do
    {:noreply, update(socket, :items, &(&1 = Store.delete_item_from_cart(id)))}
  end

  def getCurrentItem(id) do
    Enum.filter(Store.get_all_phones, fn(phone) ->
      phone.id == id
    end)
  end

  def handle_event("toggle-cart", _, socket) do
    {:noreply, update(socket, :is_cart_open, &(&1 = !socket.assigns.is_cart_open))}
  end

  def handle_event("inc", %{"id" => id}, socket) do
    items = Store.increment_item_in_cart(id)
    {:noreply, assign(socket, message: "Product Added To Cart Successfully", items: items)}
  end

  def handle_event("dec", %{"id" => id}, socket) do
    after_remove = Store.decrement_item_in_cart(id)
    {:noreply, assign(socket, message: "Product Deleted From Cart Successfully!", items: after_remove)}
  end

  def handle_event("close-alert", _, socket) do
    {:noreply, assign(socket, message: "")}
  end
end