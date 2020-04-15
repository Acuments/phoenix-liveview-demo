defmodule DemoWeb.CounterLive.Index do
    use Phoenix.LiveView
    import Redis
    alias DemoWeb.Router.Helpers, as: Routes
    alias DemoWeb.Store, as: Store
 
    @items([])

    def render(assigns) do
    ~L"""
    <div class="component-container">
        <%= live_component(@socket, DemoWeb.HeaderComponent, id: "Header Component", items: @items, isCartOpen: @isCartOpen ) %>
      <div class="product-container product-header">
      <div class="button-center select">
        <form for="per_page" phx-change="select-page" style="margin: 0px; padding: 0px;">
          <select id="per_page" phx-select="select-page" name="per_page">
            <option value="pp" selected>Per Page </option> 
            <option value="5">5</option>
            <option value="10">10</option>
          </select>
        </form>
      </div>
      <div class="card-box">
      <div class="cardcontainer">
        <%= for phone <- @phones do %>
          <div class="card">
          <a  href="/live/product/<%= phone.id%>" class="link-style"><p class="card-heading"><%= phone.name %></p>
          <img src=<%= phone.image%> class="image"/>
          <p>Price: $<%= phone.price %></p></a>
          <div class="button-group">
            <button phx-click="inc" phx-value-name="<%= phone.name %>" phx-value-price="<%= phone.price %>" class="button-style" >Add to cart</button>
          </div>
          </div>
        <% end %>
      </div>
      </div>
      <div class="center-align">
      <%= if @perPage * @page < 13 do %>
        <div class="button-center">
          <button phx-click="load-more" class="load-button">Load More</button>
        </div>
      <% end %>
      </div
      </div>
      </div>
    """
    #   DemoWeb.CounterView.render("index.html", assigns)
    end

    def mount(_params, _session, socket) do
      Store.init
      {_, cache} = Cachex.get(:my_cache, "global")
      {:ok, assign(
          socket,
          phones: Store.getPhones,
          isCartOpen: false,
          items: cache.items,
          phoneCount: Store.phoneCount,
          perPage: 5,
          page: 1,
        )}
    end

    def handle_event("select-page", %{"per_page" => per_page}, socket) do
      {perPage, _} = Integer.parse(per_page)
      phones = Store.getPhonesPerPage(perPage, 1)
      socket = assign(socket, phones: phones, perPage: perPage, page: 1)
      {:noreply, socket}
    end

    def handle_event("load-more", _, socket) do
      phones = Store.getPhonesPerPage(socket.assigns.perPage, socket.assigns.page+ 1)
      socket = assign(socket, page: socket.assigns.page + 1)
      {:noreply, update(socket, :phones, &(&1 = phones))}
    end

    def handle_event("delete-item", %{"name" => name}, socket) do
      items = socket.assigns.items
      mod_items = Enum.filter(items, fn(item) ->
        item.name != name
      end)
      {_, cache} = Cachex.get(:my_cache, "global")
      cache = Map.put(cache, :items, mod_items)
      Cachex.put(:my_cache, "global", cache)
      {:noreply, update(socket, :items, &(&1 = mod_items))}
    end

    def handle_event("close-cart", _, socket) do
      {:noreply, update(socket, :isCartOpen, &(&1 = false))}
    end

    def handle_event("open-cart", _, socket) do
      {:noreply, update(socket, :isCartOpen, &(!&1))}
    end

    def handle_event("inc", %{"name" => name, "price" => price}, socket) do
      items = socket.assigns.items
      test = true
      mod_items = Enum.map(items, fn(item) -> 
        if (item.name === name) do
          %{
            name: item.name,
            count: item.count + 1,
            price: item.price
          }
        else
          item
        end
      end)
      socket = assign(socket, :items, mod_items)
      if (socket.changed === %{} or !socket.changed.items) do
        items = mod_items ++ [%{ name: name, count: 1, price: price}]
        {_, cache} = Cachex.get(:my_cache, "global")
        cache = Map.put(cache, :items, items)
        Cachex.set(:my_cache, "global", cache)
        {:noreply, update(socket, :items, &(&1 = items))}
      else
        {_, cache} = Cachex.get(:my_cache, "global")
        cache = Map.put(cache, :items, mod_items)
        Cachex.set(:my_cache, "global", cache)
        {:noreply, update(socket, :items, &(&1 = mod_items))}
      end
    end

    def handle_event("dec", %{"name" => name}, socket) do
      items = socket.assigns.items
      mod_items = Enum.map(items, fn(item) ->
        if (item.name === name) do
          %{
            name: item.name,
            count: item.count - 1,
            price: item.price
          }
        else
         item
        end
      end)
      after_remove = Enum.filter(mod_items, fn(item) ->
        item.count !== 0
      end)
      {_, cache} = Cachex.get(:my_cache, "global")
      cache = Map.put(cache, :items, after_remove)
      Cachex.put(:my_cache, "global", cache)
      {:noreply, update(socket, :items, &(&1 = after_remove))}
    end
end