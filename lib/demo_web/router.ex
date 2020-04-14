defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {DemoWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/view", PageController, :show

    live "/live", CounterLive.Index, :index
    live "/live/check", CounterLive.Index, :check
    live "/live/product/:id", CounterLive.Product

    live "/1", PageOneLive, :index
    live "/2", PageTwoLive, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoWeb do
  #   pipe_through :api
  # end
end
