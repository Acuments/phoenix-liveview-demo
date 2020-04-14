defmodule DemoWeb.HeaderComponent do
    use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
        <div class="close-cart" phx-click="close-cart">
        <div class="header">
        <p class="cart" phx-click="open-cart"><%= get_cart_items_count(@items) %> | Cart</p>
        <h1 class="header-name">Phoenix Demo Cart</h1>
        <div class="cart-modal-container">
      <%= if @isCartOpen do %>
      <button class="checkout-button">Checkout</button>
          <div class="cart-modal">
            <%= if Enum.count(@items) === 0 do %>
              <p class="empty-cart">There are no items in your cart...</p> 
              <img src="https://images.assetsdelivery.com/compings_v2/anthonycz/anthonycz1610/anthonycz161000019.jpg" class="cart-image" />
            <% else %>
                <div class="cart-modal-position">
                <p>Total cart value: $<%= calc_total_price(@items) %></p>
              </div>
              <div style="height: 400px; overflow: scroll;">
              <%= for item <- @items do %>
              <div class="item-card-container">
              <div class="item-card">
                <p class="remove"><%= item.name %></p>
                <img phx-click="delete-item" phx-value-name="<%= item.name %>" src="https://getdrawings.com/free-icon-bw/delete-icon-24.png" class="delete-button"/>
                <div class="item-button">
                  <button phx-click="dec" phx-value-name="<%= item.name %>" class="button-style-cart">-</button>
                  <%= item.count %>
                  <button phx-click="inc" phx-value-name="<%= item.name %>" phx-value-price="<%= item.price %>" class="button-style-cart">+</button>
                </div>
                </div>
                </div>
                <hr style="margin: 0px;">
              <% end %>
              </div>
              <button class="checkout-button">Checkout</button>
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
