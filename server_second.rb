require 'socket'

class Server

  def initialize
    @server          = TCPServer.new 9292
    @client          = @server.accept
    @count           = 0  
    @shutdown_server = false
  end

  def incoming_request_loop
    request_lines = []

    until @shutdown_server
      while line = @client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      accept
    end
    @client.close

  end

  def accept
        puts "Ready for a request"
    # loop do
    #   Thread.start(@client.accept) do |client|
        @count += 1
        puts "Got this request:"
        puts @request_lines.inspect
        sends_res]ponse(@request_lines)
      #   end
      # end
  end
  
  def sends_response(request_lines)
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>Hello World! (#{@count})</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
    puts ["Wrote this response:", headers, output].join("\n")
    puts "\nResponse complete, exiting."
    puts "\n"
  end

  def root_headers
    <<-END 
      <pre>
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protcol}
      Host: #{host}
      Port: #{post}
      Origin: #{host}
      Accept: #{accept}
      </pre>
    END
  end
  
end

server = Server.new
server.start
