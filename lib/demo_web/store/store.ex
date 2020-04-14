defmodule DemoWeb.Store do
    @initialState(%{
      items: [],
      isOpen: false,
      test_state_var: "test",
      count: 0,
    })
    def init do
      #Setting initial state
      {_, cache} = Cachex.get(:my_cache, "global")
      if(!cache) do
        IO.puts("Setting the initial state for when the cache does not exist")  
        Cachex.set(:my_cache, "global", @initialState)
      end
      # Cachex.put(:my_cache, "global", @initialState)
    end

end