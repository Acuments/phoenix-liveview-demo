defmodule DemoWeb.ProductsLive.ProductTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DemoWeb.Store

  @test_add_item(%{count: 1, name: "One Plus", price: 110})
  @test_remove_item([])

  describe "DemoWeb.ProductsLive.Product" do
    test "add item to cart: Details page", %{conn: conn} do
      Store.clearCache
      {:ok, view, _html} = live(conn, "/product/1")
      render_click(view, :inc, %{name: "One Plus", price: 110})
      conn = get(conn, "/")
      [item | _] = conn.assigns.items
      assert item == @test_add_item
    end

    test "removing item from cart: Details", %{conn: conn} do
      Store.clearCache
      {:ok, view, _html} = live(conn, "/product/1")
      render_click(view, :inc, %{name: "One Plus", price: 110})
      render_click(view, :dec, %{name: "One Plus"})
      conn = get(conn, "/")
      item = conn.assigns.items
      assert item == @test_remove_item
    end
  end
end