defmodule DemoWeb.Components.ItemCard do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <div class="card">
        <a  href="/product/<%= @phone.id%>" class="link-style" id="product-<%= @phone.id%>"><p class="card-heading"><%= @phone.name %></p>
        <img src=<%= @phone.image%> class="image"/>
        <p>Price: $<%= @phone.price %></p></a>
        <div class="button-group">
          <button phx-click=<%= @onClick %> phx-value-id="<%= @phone.id %>"  class="button-style" id="add-button-<%= @phone.id %>"><%= @btnText %></button>
        </div>
      </div>
    """
  end
end
