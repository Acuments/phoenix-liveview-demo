defmodule DemoWeb.Components.ItemCard do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <div class="card">
        <a  href="/product/<%= @phone.id%>" class="link-style"><p class="card-heading"><%= @phone.name %></p>
        <img src=<%= @phone.image%> class="image"/>
        <p>Price: $<%= @phone.price %></p></a>
        <div class="button-group">
          <button phx-click=<%= @onClick %> phx-value-name="<%= @phone.name %>" phx-value-price="<%= @phone.price %>" class="button-style" ><%= @btnText %></button>
        </div>
      </div>
    """
  end
end
