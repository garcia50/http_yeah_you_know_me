class Routes 
  attr_reader :controller, :server

  def initialize(server)
    @server = server
    @controller = server.controller 
  end

  def handle_request
    if verb == "GET"
      get_actions(path)
    elsif verb == "POST"
      content_length = server.request_lines[3].split(" ")[1].to_i
      content_body = server.client.read(content_length)
      post_actions(path, content_body)
    end
  end

  private

  def verb
    server.request_lines[0].split(" ")[0]
  end

  def path
    req_path = server.request_lines[0].split(" ")[1]
    if req_path.include?("word_search")
      @search_query = req_path.split("=")[1]
      req_path = "/word_search"
    end
    req_path 
  end

  def get_actions(path)
    case path 
      when "/"
        controller.home
      when "/hello"
        controller.hello
      when "/datetime"
        controller.datetime
      when "/shutdown"
        controller.shutdown
      when "/word_search"
        controller.word_search(@search_query)
      when "/game"
        controller.game
      when "/force_error"
        controller.force_error
      else
        controller.not_found  
    end
  end

  def post_actions(path, content_body)
    case path
      when "/start_game"
        controller.start_game
      when "/game"
        controller.post_game(content_body)
      else
        controller.not_found
    end
  end
end

