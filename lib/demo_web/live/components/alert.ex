defmodule DemoWeb.Components.Alert do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <%= if String.length(@message) !== 0 do %>
        <div class="alert-info">
          <a phx-click="close-alert" class="alert-close" href="#"> X </a>
          <p> <%= @message %> </p>
        </div>
      <% end %>
    """
  end
end
