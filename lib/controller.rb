require 'date'
require_relative 'word_search'
require_relative 'game'

class Controller
  attr_reader :server

  def initialize(server)
    @server      = server
    @hello_count = 0
    @game_count  = 0
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
    response("Total Requests: #{server.total_request_count}")
    server.server_on = false
  end

  def word_search(query)
    word_search = WordSearch.new
    response(word_search.locate_word(query))
  end

  def start_game
    if @game_count >= 1 
      response("There is already a game in progress.", { status: "http/1.1 403 Forbidden" })
    else
      @game = Game.new
      @game_count += 1
      response("Good Luck!", { status: "http/1.1 301 Moved Permanently" })
    end
  end

  def game
    if @game
      response(@game.game_information)
    else
      response(
        "You haven't started a game. To start game make a post request to /start_game",
        { status: "http/1.1 403 Forbidden" }
      )
    end
  end

  def force_error
    response("SystemError", { status: "http/1.1 500 Internal Server Error" })
  end

  def not_found
    response("Not Found", { status: "http/1.1 404 Not Found" })
  end

  def post_game(content_body)
    if @game
      guess = content_body.split("\r\n")[3] if !content_body.nil?
      @game.number(guess)
      headers = ["HTTP/1.1 302 redirect", "location: /game",
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby\r\n\r\n"].join("\r\n")
      server.client.puts headers 
    else
      response(
        "You haven't started a game. To start game make a post request to /start_game",
        { status: "http/1.1 403 Forbidden" }
      )
    end
  end

  private

  def debug_information
    verb     = server.request_lines[0].split(" ")[0]
    path     = server.request_lines[0].split(" ")[1]
    protocol = server.request_lines[0].split(" ")[2]
    host     = server.request_lines[1].split(" ")[1]
    port     = server.request_lines[1].split(":")[2]
    origin   = server.request_lines[1].split(" ")[1]
    accept   = server.request_lines[6].split(":")[1].strip

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

  def response(body, headers = {})
    output = "<html><head></head><body> #{body} </body></html>"
    status = headers[:status] || "http/1.1 200 ok"
    headers = [status,
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    server.client.puts headers
    server.client.puts output
  end
end








