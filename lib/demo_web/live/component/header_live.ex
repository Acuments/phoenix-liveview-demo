defmodule DemoWeb.LiveComponent.HeaderLive do

  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="header">
      <p class="cart" phx-click="open-cart"><%= @itemCount %> | Cart</p>
      <h1>Phoenix Demo Cart</h1>
      <div class="cart-modal-container">
        <%= if @isCartOpen do %>
          <div class="cart-modal">
            <%= if @enumCount === 0 do %>
              <p class="empty-cart">There are no items in your cart...</p>
            <% else %>
              <div>
                <p>Total cart value: <%= @calcTotalPrice %></p>
              </div>
              <%= for item <- @items do %>
              <div class="item-card">
                <p class="remove"><%= item.name %></p>
                <div class="item-button">
                  <button phx-click="dec" phx-value-name="<%= item.name %>" class="button-style">-</button>
                  <%= item.count %>
                  <button phx-click="inc" phx-value-name="<%= item.name %>" phx-value-price="<%= item.price %>" class="button-style">+</button>
                </div>
                </div>
              <% end %>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end

