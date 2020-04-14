defmodule DemoWeb.CounterLive.Product do
  use Phoenix.LiveView
  alias DemoWeb.LiveComponent.HeaderLive

  @phones([
    %{ name: "iPhone", count: 0},
    %{ name: "One Plus", count: 0},
    %{ name: "Huwawei", count: 0},
    %{ name: "Oppo Reno", count: 0},
    %{ name: "RedMi+", count: 0},
    %{ name: "Pixel 5", count: 0},
    %{ name: "Samsung galaxy", count: 0},
    %{ name: "Motorolla", count: 0},
    %{ name: "HTC", count: 0},
  ])

  @items([])

  def render(assigns) do
    ~L"""
      <div>
       <%= live_component(
          @socket,
          HeaderLive,
          itemCount: 10,
          isCartOpen: false,
          enumCount: 10,
          calcTotalPrice: 1000,
          items: [],
       )%>
       Product description page
      </div>
    """
    #   DemoWeb.CounterView.render("index.html", assigns)
    #   DemoWeb.NewView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns)
    {:ok, assign(
      socket,
      val: 0,
    )}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply, assign(socket, id: id)}
  end


end
