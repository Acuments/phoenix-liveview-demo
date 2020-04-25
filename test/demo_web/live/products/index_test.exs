defmodule DemoWeb.ProductsLive.IndexTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DemoWeb.Store

  describe "DemoWeb.ProductsLive.Index" do
    setup do
      Store.clearCache
      :ok
    end

    test "connected mount", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html
    end

    test "add item to cart", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :inc, %{id: Integer.to_string(1)})
      conn = get(conn, "/")
      [item | _] = conn.assigns.items
      expectingItem = %{ Store.get_item_by_id(Integer.to_string(1)) | count: 1 }
      assert item == expectingItem
    end

    test "removing item from cart", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :inc, %{id: Integer.to_string(1)})
      render_click(view, :dec, %{id: Integer.to_string(1)})
      conn = get(conn, "/")
      item = conn.assigns.items
      assert item == []
    end

    test "deleting item from cart", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      render_click(view, :inc, %{id: Integer.to_string(1)})
      render_click(view, "delete-item", %{id: Integer.to_string(1)})
      conn = get(conn, "/")
      item = conn.assigns.items
      assert item == []
    end
  end
end