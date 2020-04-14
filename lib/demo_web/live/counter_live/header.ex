defmodule DemoWeb.HeaderComponent do
    use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
        <div class="close-cart" phx-click="close-cart">
        <div class="header">
        <p class="cart" phx-click="open-cart"><%= get_cart_items_count(@items) %> | Cart</p>
        <h1>Phoenix Demo Cart</h1>
        <div class="cart-modal-container">
      <%= if @isCartOpen do %>
          <div class="cart-modal">
            <%= if Enum.count(@items) === 0 do %>
              <p class="empty-cart">There are no items in your cart...</p> 
            <% else %>
                <div>
                <p>Total cart value: <%= calc_total_price(@items) %></p>
              </div>
              <%= for item <- @items do %>
              <div class="item-card-container">
              <div class="item-card">
                <p class="remove"><%= item.name %></p>
                <div class="item-button">
                  <button phx-click="dec" phx-value-name="<%= item.name %>" class="button-style">-</button>
                  <%= item.count %>
                  <button phx-click="inc" phx-value-name="<%= item.name %>" phx-value-price="<%= item.price %>" class="button-style">+</button>
                </div>
                </div>
                </div>
              <% end %>
            <% end %>
          </div>
        <% end %> 
    </div>
      </div>
      </div>
    """
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
      # sum_of_price
    end

end
