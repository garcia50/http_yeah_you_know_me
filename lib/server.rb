require 'socket'
require_relative 'routes'
require_relative 'controller'

class Server
  attr_reader :routes,
              :controller,
              :client,
              :request_lines

  attr_accessor :server_on,
                :total_request_count

  def initialize
    @server              = TCPServer.new 9292
    @server_on           = true   
    @total_request_count = 0
    @request_lines       = []
    @controller          = Controller.new(self)
    @routes              = Routes.new(self)
  end

  def start
    while @server_on
      @request_lines = []
      @client = @server.accept 
      
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      
      puts "recieved request"
      
      @total_request_count += 1

      routes.handle_request
      
      puts "sent response"
    end
    client.close
  end
end
