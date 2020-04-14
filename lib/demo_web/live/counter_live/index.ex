defmodule DemoWeb.CounterLive.Index do
    use Phoenix.LiveView
    import Redis
    alias DemoWeb.Router.Helpers, as: Routes
    alias DemoWeb.Store, as: Store

    @phones([
        %{ id: 1, name: "iPhone", count: 0, price: 120, image: "https://images-na.ssl-images-amazon.com/images/I/71XeQzRDyML._AC_SX425_.jpg"},
        %{ id: 2, name: "One Plus", count: 0, price: 110, image: "https://gloimg.gbtcdn.com/soa/gb/pdm-product-pic/Electronic/2019/10/16/goods_img_big-v6/20191016172701_78162.jpg"},
        %{ id: 3, name: "Huawei", count: 0, price: 90, image: "https://images-na.ssl-images-amazon.com/images/I/71vm1uK9XBL._AC_SX569_.jpg"},
        %{ id: 4, name: "Oppo Reno", count: 0, price: 80, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTSeFUB1UOcHY8PycVIB86sMTnRgfx9ZxMABLDlvnYsjc4UazqG&usqp=CAU"},
        %{ id: 5, name: "RedMi+", count: 0, price: 80, image: "https://imgaz2.staticbg.com/thumb/large/oaupload/banggood/images/81/18/bb2836b7-4504-4f93-adf5-f06d6116371c.jpg"},
        %{ id: 6, name: "Pixel 5", count: 0, price: 100, image: "https://www.mytrendyphone.eu/images/Google-Pixel-4-XL-64GB-Just-Black-0842776114709-24102019-01-p.jpg"},
        %{ id: 7, name: "Samsung galaxy", count: 0, price: 110, image: "https://thumbor.forbes.com/thumbor/711x890/https://blogs-images.forbes.com/amitchowdhry/files/2017/04/Galaxy-S8-Plus.jpg?width=960"},
        %{ id: 8, name: "Motorolla", count: 0, price: 100, image: "https://www.gizmochina.com/wp-content/uploads/2019/05/Motorola-Moto-E6-600x600.jpg"},
        %{ id: 9, name: "HTC", count: 0, price: 120, image: "https://drop.ndtv.com/TECH/product_database/images/529201391433PM_635_HTC_One.png"},
        %{ id: 10, name: "Sony", count: 0, price: 90, image: "https://fdn2.gsmarena.com/vv/pics/sony/sony-xperia-1-II-002.jpg"},
        %{ id: 11, name: "Honor", count: 0, price: 80, image: "https://imgaz2.staticbg.com/thumb/large/oaupload/ser1/banggood/images/64/8A/e35d0c36-d2b2-4515-bd87-8b7d871d6b0e.jpg"},
        %{ id: 12, name: "Xiaomi", count: 0, price: 80, image: "https://imgaz1.staticbg.com/thumb/view/oaupload/banggood/images/9E/FE/d12a6f03-c827-4651-8c8b-93a3f324add3.jpg"},
        ])
    
    @items([])

    def render(assigns) do
    ~L"""
        <div class="close-cart" phx-click="close-cart">
        <div class="header">
        <%= Store.getItems %>
        <h1 phx-click="get-state">Click Me to set</h1>
        <h1 phx-click="set-state">Click me to get</h1>
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
      <div class="product-container">
        <h1 class="product-header">Products</h1>
      <div class="card-box">
      <div class="cardcontainer">
        <%= for phone <- @phones do %>
          <div class="card">
          <a  href="/live/products/#{phone.id}" phx-click="goto" phx-value-id="<%= phone.id %>"><p class="card-heading"><%= phone.name %></p>
          <img src=<%= phone.image%> class="image"/>
          <p>Price: $<%= phone.price %></p></a>
          <div class="button-group">
            <button phx-click="dec" phx-value-name="<%= phone.name %>" class="button-style">-</button>
            <button phx-click="inc" phx-value-name="<%= phone.name %>" phx-value-price="<%= phone.price %>" class="button-style" >+</button>
          </div>
          </div>
        <% end %>
      </div>
      </div>
      </div>
      </div>
    """
    #   DemoWeb.CounterView.render("index.html", assigns)
    end

    def mount(_params, _session, socket) do
     tab = :ets.new(:my_table, [:set])
      {:ok, assign(
          socket,
          phones: @phones,
          isCartOpen: false,
          items: @items,
          tab: tab,
        )}
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

    def handle_event("get_state", _, socket) do
      
    end

    def handle_event("goto", %{"id" => id}, socket) do
      {:noreply, push_redirect(socket, to: Routes.live_path(socket, DemoWeb.CounterLive.Product, id))}
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
        {:noreply, update(socket, :items, &(&1 = items))}
      else
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
      {:noreply, update(socket, :items, &(&1 = after_remove))}
    end
end