defmodule DemoWeb.ProductsLive.ProductTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DemoWeb.Store

  describe "DemoWeb.ProductsLive.Product" do

    setup do
      Store.clearCache
      :ok
    end

    test "add item to cart: Details page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :inc, %{id: Integer.to_string(1)})
      conn = get(conn, "/")
      [item | _] = conn.assigns.items
      expectingItem = %{ Store.getItemById(Integer.to_string(1)) | count: 1 }
      assert item == expectingItem
    end

    test "removing item from cart: Details", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :inc, %{id: Integer.to_string(1)})
      render_click(view, :dec, %{id: Integer.to_string(1)})
      conn = get(conn, "/")
      item = conn.assigns.items
      assert item == []
    end
  end
end