require 'socket'
require 'date'
require_relative 'supporting_paths'
require_relative 'word_search'

class Server
  attr_reader :server, :supporting_paths

  attr_accessor :shutdown_server

  def initialize
    @server              = TCPServer.new 9292
    @supporting_paths    = SupportingPaths.new
    @server_on           = true   
    @total_request_count = 0
    @hello_count         = 0 
  end

  def http_request_loop
    while @server_on
      @request_lines = []
      @client = @server.accept 
      while line = @client.gets and !line.chomp.empty?
            @request_lines << line.chomp
      end
      puts "recieved request"

      @total_request_count += 1

      case path 
        when "/"
          home
        when "/hello"
          hello
        when "/datetime"
          datetime
        when "/shutdown"
          shutdown
        when "/word_search"
          word_search
      end
      puts "sent response"
    end
    @client.close
  end

  def home
    response(debug_information)
  end

  def hello
    response("Hello World!(#{@hello_count})\n")
    @hello_count += 1
  end

  def datetime
    d = DateTime.now
    response("#{d.strftime('%H:%M%p on %A, %B %d, %Y')}")
  end

  def shutdown
    response("Total Requests: #{@total_request_count}")
    @server_on = false
  end

  def word_search
    word_search = WordSearch.new
    response(word_search.locate_word(@sample_word))
  end

  private
    
  def verb
    @request_lines[0].split(" ")[0]
  end

  def response(body)
    output = "<html><head></head><body> #{body} </body></html>"
    headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
  end

  def path
    req_path = @request_lines[0].split(" ")[1]
    if req_path.include?("word_search")
      @sample_word =  req_path.split("=")[1]
      req_path = "/word_search"
    end
    req_path
  end

  def debug_information
    verb     = @request_lines[0].split(" ")[0]
    path     = @request_lines[0].split(" ")[1]
    protocol = @request_lines[0].split(" ")[2]
    host     = @request_lines[1].split(" ")[1]
    port     = @request_lines[1].split(":")[2]
    origin   = @request_lines[1].split(" ")[1]
    accept   = @request_lines[6].split(":")[1].strip

    <<-END 
      <pre>
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      Host: #{host}
      Port: #{port}
      Origin: #{origin}
      Accept: #{accept}
      </pre>
    END
  end
end

server = Server.new
server.http_request_loop



  # def http_request_loop
  #   # @shutdown_server = true #last minute change(already exist in initialize)
  #   while @server_on
  #     @request_lines = []
  #     @client = @server.accept 
  #     while line = @client.gets and !line.chomp.empty?
  #           @request_lines << line.chomp
  #     end
  #     puts "recieved request"
  #     output = "<html><head></head><body> #{@supporting_paths.paths(@request_lines, 
  #               @hello_count, @total_request_count, @client)} </body></html>"
  #     headers = ["http/1.1 200 ok",
  #               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
  #               "server: ruby",
  #               "content-type: text/html; charset=iso-8859-1",
  #               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  #     @client.puts headers
  #     @client.puts output
  #     puts "sent response"
    
  #     path = @request_lines[0].split(" ")[1]
  #     if path == "/hello"
  #       @hello_count += 1
  #     end
      
  #     @total_request_count += 1
  #   end
  #   @client.close
  # end













