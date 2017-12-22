require 'minitest/autorun'
require 'minitest/pride'
require './lib/routes'
require './lib/server'


class RoutesTest < Minitest::Test
  attr_reader :routes

  def setup
    server = Server.new 
    @routes = Routes.new(server)
  end

  # def test_routes_class_exist
  #   assert_instance_of Routes, routes
  # end
end