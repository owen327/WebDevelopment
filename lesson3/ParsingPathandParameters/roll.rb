require "socket"

def parse_request(request_line)
  http_method, path, params, http = request_line.split(/\s|[?]/)

  params = params.split("&").map { |pair| pair.split("=") }.to_h

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  puts request_line

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/plain\r\n\r\n"

  http_method, path, params = parse_request(request_line)

  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i
  rolls.times { client.puts rand(sides) + 1 }

  client.close
end
