defmodule DemoWeb.ProductsLive.Index do
  use Phoenix.LiveView
  import Redis
  alias DemoWeb.Router.Helpers, as: Routes
  alias DemoWeb.Store, as: Store

  @items []

  def render(assigns) do
    DemoWeb.ProductsView.render("index.html", assigns)
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

  def handle_event("select-page", %{"per_page" => per_page}, socket) do
    {per_page, _} = Integer.parse(per_page)
    {:noreply, assign(socket, phones: Store.get_phones_per_page(per_page, 1), per_page: per_page, page: 1)}
  end

  def handle_event("load-more", _, socket) do
    phones = Store.get_phones_per_page(socket.assigns.per_page, socket.assigns.page + 1)
    {:noreply, assign(socket, page: socket.assigns.page + 1, phones: phones)}
  end

  def handle_event("delete-item", %{"id" => id}, socket) do
    {:noreply, update(socket, :items, &(&1 = Store.delete_item_from_cart(id)))}
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