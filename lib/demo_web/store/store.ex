defmodule DemoWeb.Store do

  @phones [
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
  ]

  @initial_state %{
    items: [],
  }

  def init(session) do
    {_, cache} = Cachex.get(:my_cache, session["_csrf_token"])
    if(!cache) do
      Cachex.set(:my_cache, session["_csrf_token"], @initial_state)
    end
  end

  def clearCache do
    Cachex.clear(:my_cache)
  end

  def get_phones_per_page(per_page, page) do
    slice_amount = per_page * page - 1
    Enum.slice(@phones, 0..slice_amount)
  end

  def phone_count do
    Enum.count(@phones)
  end

  def get_phones do
    Enum.slice(@phones, 0..3)
  end

  def get_all_phones do
    @phones
  end

  def get_item_by_id(id) do
    item = Enum.find(@phones, fn phone ->  phone.id == String.to_integer(id) end)
  end

  def get_items(session) do
    {_, cache} = Cachex.get(:my_cache, session["_csrf_token"])
    cache.items
  end

  def decrement_item_in_cart(id, token) do
    {_, cache} = Cachex.get(:my_cache, token)
    mod_items = Enum.map(
      cache.items,
      fn (item) ->
        if (item.id === String.to_integer(id)) do
          %{item | count: item.count - 1}
        else
          item
        end
      end
    )
    after_remove = Enum.filter(
      mod_items,
      fn (item) ->
        item.count !== 0
      end
    )
    cache = Map.put(cache, :items, after_remove)
    Cachex.put(:my_cache, token, cache)
    after_remove
  end

  def increment_item_in_cart(id, token) do
    {_, cache} = Cachex.get(:my_cache, token)
    items = cache.items
    search_item = get_item_by_id(id)

    filtered_item = Enum.filter(
      items,
      fn (item) ->
        item.id === String.to_integer(id)
      end
    )

    concat_items = if (Enum.count(filtered_item) === 0) do
      [search_item]
    else []
    end

    items = items ++ concat_items

    items = Enum.map(items, fn(item) ->
      if (item.id == String.to_integer(id)) do
        %{item | count: item.count + 1}
      else
        item
      end
    end)

    cache = Map.put(cache, :items, items)
    Cachex.set(:my_cache, token, cache)
    items
  end

  def delete_item_from_cart(id, token) do
    {_, cache} = Cachex.get(:my_cache, token)
    mod_items = Enum.filter(cache.items, fn(item) ->
      item.id != String.to_integer(id)
    end)
    cache = Map.put(cache, :items, mod_items)
    Cachex.put(:my_cache, token, cache)
    mod_items
  end
end