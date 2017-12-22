require 'minitest/autorun'
require 'minitest/pride'
require './lib/controller'
require './lib/server'
require 'faraday'

class ControllerTest < Minitest::Test
  attr_reader :controller

  def setup
    server = Server.new 
    @controller = Controller.new(server)
  end

  def test_controller_class_exist
    assert_instance_of Controller, controller
  end
end