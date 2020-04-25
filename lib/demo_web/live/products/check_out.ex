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
      phones: Store.get_phones,
      is_cart_open: false,
      items: cache.items,
      phone_count: Store.phone_count,
      per_page: 4,
      page: 1,
      message: ""
    )}
  end

  def handle_event("inc", %{"id" => id}, socket) do
    items = Store.increment_item_in_cart(id)
    {:noreply, assign(socket, message: "Product Added To Cart Successfully", items: items)}
  end

  def handle_event("dec", %{"id" => id}, socket) do
    items = Store.decrement_item_in_cart(id)
    {:noreply, assign(socket, message: "Product Deleted From Cart Successfully!", items: items)}
  end

  def handle_event("delete-item", %{"id" => id}, socket) do
    {:noreply, update(socket, :items, &(&1 = Store.delete_item_from_cart(id)))}
  end
end