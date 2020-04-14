defmodule DemoWeb.CounterLive.Product do
    use Phoenix.LiveView
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

    def render(assigns) do
    ~L"""
     <div>
        <%= live_component(@socket, DemoWeb.HeaderComponent, id: "Test Component", items: @items, isCartOpen: @isCartOpen) %>
        <div class="product-card-container">
          <div class="product-card">
            <h1 style="margin-bottom: 20px"><%= @currentItem.name %></h1>
            <img src="<%= @currentItem.image%>" style="margin-bottom: 20px; height: 250px;">
            <h4 style="margin-bottom: 50px"> Price: $<%= @currentItem.price%></h4>
            <div class="button-group">
            <button phx-click="dec" phx-value-name="<%= @currentItem.name %>" class="button-style">-</button>
            <button phx-click="inc" phx-value-name="<%= @currentItem.name %>" phx-value-price="<%= @currentItem.price %>" class="button-style" >+</button>
          </div>
          </div>
        </div>
     </div>
     """
    #   DemoWeb.CounterView.render("index.html", assigns)
    #   DemoWeb.NewView.render("index.html", assigns)
    end
    def mount(%{"id" => id}, _session, socket) do
      {i_d, _} = Integer.parse(id)
      Store.init
      {_, cache} = Cachex.get(:my_cache, "global")
      phone = getCurrentItem(i_d)
      [currentItem | _] = phone
      {:ok, assign(
          socket,
          isCartOpen: false,
          items: cache.items,
          currentItem: currentItem
        )}
    end

    def getCurrentItem(i_d) do
        Enum.filter(@phones, fn(phone) ->
            phone.id == i_d
        end)
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
            price: item.price,
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
      IO.inspect(cache)
      Cachex.put(:my_cache, "global", cache)
      {:noreply, update(socket, :items, &(&1 = after_remove))}
    end

end