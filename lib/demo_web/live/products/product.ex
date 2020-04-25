defmodule DemoWeb.ProductsLive.Product do
  use Phoenix.LiveView
  alias DemoWeb.Store, as: Store

  def render(assigns) do
    DemoWeb.ProductsView.render("product.html", assigns)
  end

  def mount(%{"id" => id}, session, socket) do
    Store.init(session)
    {:ok, assign(
      socket,
      is_cart_open: false,
      items: Store.get_items(session),
      current_item: Store.get_item_by_id(id),
      message: "",
      token: session["_csrf_token"],
    )}
  end

  def handle_event("delete-item", %{"id" => id}, socket) do
    {:noreply, assign(socket, items: Store.delete_item_from_cart(id, socket.assigns.token))}
  end

  def handle_event("toggle-cart", _, socket) do
    {:noreply, update(socket, :is_cart_open, &(&1 = !socket.assigns.is_cart_open))}
  end

  def handle_event("inc", %{"id" => id}, socket) do
    items = Store.increment_item_in_cart(id, socket.assigns.token)
    {:noreply, assign(socket, message: "Product Added To Cart Successfully", items: items)}
  end

  def handle_event("dec", %{"id" => id}, socket) do
    after_remove = Store.decrement_item_in_cart(id, socket.assigns.token)
    {:noreply, assign(socket, message: "Product Deleted From Cart Successfully!", items: after_remove)}
  end

  def handle_event("close-alert", _, socket) do
    {:noreply, assign(socket, message: "")}
  end
end