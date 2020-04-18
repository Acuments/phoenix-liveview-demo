defmodule DemoWeb.IntegrationTest do
  # Import helpers
  use ExUnit.Case
  use Hound.Helpers
  alias DemoWeb.Store

  # Start hound session and destroy when tests are run
  hound_session()
  Store.init

  @homepage("http://localhost:4002/")
  @detailspage("http://localhost:4002/product/1")

  Hound.start_session

  describe "DemoWeb.ProductsLive.Index" do
    test "clicking on banner redirects to / path" do
      navigate_to(@homepage)
      element = find_element :name, "homepage"
      click element
      assert current_url() == @homepage
    end

    test "Navigating to home page from details page" do
      navigate_to(@detailspage)
      element = find_element :name, "homepage"
      click element
      assert current_url() == @homepage
    end

    test "Navigating to details page from home page" do
      navigate_to(@homepage)
      element = find_element :id, "product-1"
      click element
      assert current_url() == @detailspage
    end

    test "Adding items to cart" do
      navigate_to(@homepage)
      badge_element = find_element :id, "badge"
      element = find_element :id, "add-button-1"
      click element
      assert visible_text(badge_element) == "0"
    end
  end
end