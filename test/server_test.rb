require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'

class ServerTest < Minitest::Test
  attr_reader :server

  def setup
    @server = Server.new
  end

  # def test_server_class_exist
  #   assert_instance_of Server, server
  # end
end