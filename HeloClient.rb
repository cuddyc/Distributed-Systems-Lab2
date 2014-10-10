require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2000

20.times do |i|
  s = TCPSocket.open(hostname, port)

  s.puts 'HELO there\n'
  message = s.gets
  puts message

  s.close               # Close the socket when done

end