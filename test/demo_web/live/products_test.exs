defmodule DemoWeb.ProductsLiveTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DemoWeb.Store

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html
  end

  test "add item to cart", %{conn: conn} do
    Store.clearCache
    {:ok, view, _html} = live(conn, "/")
    render_click(view, :inc, %{name: "One Plus", price: 110})
    conn = get(conn, "/")
    [item | _] = conn.assigns.items
    test_item = %{count: 1, name: "One Plus", price: 110}
    assert item = test_item
  end

  test "removing item from cart", %{conn: conn} do
    Store.clearCache
    {:ok, view, _html} = live(conn, "/")
    render_click(view, :inc, %{name: "One Plus", price: 110})
    render_click(view, :dec, %{name: "One Plus"})
    conn = get(conn, "/")
    item = conn.assigns.items
    test_item = []
    assert item = test_item
  end

  test "add item to cart: Details page", %{conn: conn} do
    Store.clearCache
    {:ok, view, _html} = live(conn, "/product/1")
    render_click(view, :inc, %{name: "One Plus", price: 110})
    conn = get(conn, "/")
    [item | _] = conn.assigns.items
    test_item = %{count: 1, name: "One Plus", price: 110}
    assert item = test_item
  end

  test "removing item from cart: Details", %{conn: conn} do
    Store.clearCache
    {:ok, view, _html} = live(conn, "/product/1")
    render_click(view, :inc, %{name: "One Plus", price: 110})
    render_click(view, :dec, %{name: "One Plus"})
    conn = get(conn, "/")
    item = conn.assigns.items
    test_item = []
    assert item = test_item
  end

end