defmodule DemoWeb.HeaderComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    DemoWeb.ProductsView.render("header.html", assigns)
  end

  def get_cart_items_count(items) do
    items_array = Enum.map(items, fn(item) ->
      1 * item.count
    end)
    Enum.sum(items_array)
  end

  def calc_total_price(items) do
    prices = Enum.map(items, fn(item) ->
      price = Decimal.new(item.price) |> Decimal.to_integer
      price * item.count
    end)
    Enum.sum(prices)
  end
end
