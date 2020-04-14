defmodule DemoWeb.PageTwoLive do
    use Phoenix.LiveView
    alias DemoWeb.Router.Helpers, as: Routes
    alias DemoWeb.Store, as: Store

    def render(assigns) do
    ~L"""
      <h1>Counter of page 1: <%= @count %> </h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc" >+</button>
      <p> <%= Stash.get(:test, "test")%> </p>
    """
    #   DemoWeb.CounterView.render("index.html", assigns)
    end

    def mount(_params, _session, socket) do
      Store.init
      {_, cache} = Cachex.get(:my_cache, "global")
      IO.inspect(cache)
      {:ok, assign(
          socket,
          count: cache.count
        )}
    end

    def handle_event("inc", _, socket) do
        {_, state} = Cachex.get(:my_cache, "global")
        count = state.count
        state = Map.put(state, :count, count + 1)
        Cachex.set(:my_cache, "global", state)
        {:noreply, update(socket, :count, &(&1 + 1))}

    end

    def handle_event("dec", _, socket) do
        {_, state} = Cachex.get(:my_cache, "global")
        count = state.count
        state = Map.put(state, :count, count - 1)
        Cachex.set(:my_cache, "global", state)
        {:noreply, update(socket, :count, &(&1 - 1))}
    end

end