require 'socket'
require 'thread'

class Pool
  @@clientNum = 0

  def initialize(size)

    # Size thread pool and Queue for storing clients
    @size = size
    @jobs = Queue.new

    # Creating our pool of threads
    @pool = Array.new(@size) do |i|
      Thread.new do
        Thread.current[:id] = i

        catch(:exit) do
          loop do
            client = @jobs.pop
            @@clientNum += 1
            sleep rand(i)                 # simulating different work loads
            @message = client.gets.chomp

            case
              when @message.split[0] == 'HELO'
                @ipAddr = client.peeraddr[3].to_s
                @reply = "#{@message}IP: "
                @reply += "#{@ipAddr}"
                @reply += '\nPort: '
                @reply += "#{@port}"
                @reply += '\nStudent Number: 98609335\n'
              when @message == 'KILL_SERVICE\n'
                abort('You just killed me!')
              else
                @reply = "You sent me #{@message}"
            end

            client.puts("#{@reply}")
          end
        end

      end
    end

  end

  # ### Work scheduling
  def schedule(waitingClient)
    @jobs << waitingClient
  end

  # ### Port number to send
  def serverDetails( port )
    @port = port
  end

end

class Server

  # Open connection and create Pool instance
  def initialize( port )
    @server = TCPServer.open( port )
    puts "Server started on port #{port}"
    @serverPool = Pool.new(10)
    @serverPool.serverDetails( port )
    run
  end

  # Accept clients and put on queue
  def run
    loop{
      @client = @server.accept
      @serverPool.schedule(@client)
    }
  end

end

s = Server.new(2000)
