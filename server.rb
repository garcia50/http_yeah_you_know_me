require 'socket'
require 'date'
require_relative 'word_search'
require_relative 'game'

class Server
  attr_reader :server, :supporting_paths 
  attr_accessor :shutdown_server

  def initialize
    @server              = TCPServer.new 9292
    @server_on           = true   
    @total_request_count = 0
    @hello_count         = 0
    @game_count          = 0
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

      if verb == "GET"
        get_path
      elsif verb == "POST"
        post_path
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

  def start_game
    if @game_count >= 1 
      response("There is already a game in progress.", {status: "http/1.1 403 Forbidden"})
    else
      @game = Game.new
      @game_count += 1
      response("Good Luck!", {status: "http/1.1 301 Moved Permanently"})
    end
  end

  def game
    response(@game.game_information)
  end

  def force_error
    response("SystemError", {status: "http/1.1 500 Internal Server Error"})
  end

  def not_found
    response("Not Found", {status: "http/1.1 404 Not Found"})
  end

  def post_game(content_body)
    guess = content_body.split("\r\n")[3] if !content_body.nil?
    @game.number(guess)
    headers = ["HTTP/1.1 302 redirect", "location: /game",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby\r\n\r\n"].join("\r\n")
    @client.puts headers 
  end

  private
    
  def verb
    @request_lines[0].split(" ")[0]
  end

  def get_path
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
      when "/game"
        game
      when "/force_error"
        force_error
      else
        not_found  
    end
  end

  def post_path
    content_length = @request_lines[3].split(" ")[1].to_i
    @content_body = @client.read(content_length)
    case path
      when "/start_game"
        start_game
      when "/game"
        post_game(@content_body)
      else
        not_found
    end
  end

  def response(body, headers = {})
    output = "<html><head></head><body> #{body} </body></html>"
    status = headers[:status] || "http/1.1 200 ok"
    headers = [status,
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
      @sample_word = req_path.split("=")[1]
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














