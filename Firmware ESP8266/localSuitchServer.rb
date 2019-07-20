require 'rubygems'
require 'eventmachine'
require 'date'
class Job
  def initialize(param = "")
    @param = param
  end
 
  def run(defer)
    throw "This method needs to be implemented in subclasses"
  end
 
private
  def process(defer, time, message)
    EM.defer do
      sleep(time)
      defer.succeed(message)
    end
  end
end
 
class SmallJob < Job
  def run(defer)
    process(defer, 1, "Completed in 1 second with param = #{@param}")
  end
end
 
class LargeJob < Job
  def run(defer)
    process(defer, 5, "Completed in 5 second with param = #{@param}")
  end
end
 
class InvalidJob < Job
  def run(defer)
    process(defer, 0, "Invalid command is specified")
  end
end
 
class RequestHandler
  JOBS = {
    "SMALL" => SmallJob,
    "LARGE" => LargeJob
  }
  JOBS.default = InvalidJob
 
  def self.parse(command)
    type, param = command.split
    JOBS[type].new(param)
  end
end
 
class UDPHandler < EM::Connection
  def receive_data(command)
    command.chomp!
    log("Received #{command}")
    RequestHandler.parse(command).run(callback)
  end
 
private
  def callback
    EM::DefaultDeferrable.new.callback do |response|
      send_data(response + "\n")
      log(response)
    end
  end
 
  def log(message)
    puts "#{DateTime.now.to_s} : #{message}"
  end
end
 module EchoServer
   def post_init (*args)
      @isclosed=0
      @techname = "anet_#{rand(99999)}"
      @name = "anet_#{rand(99999)}"
      puts "entrando:"+@techname.to_s
      #EchoServer.list.each{ |c| c.send_data "#{@name} has joined.\n" }
      EchoServer.list << self
      EchoServer.devicesLogged[@techname]="."
      send_data "TOKEN?\n"
    end

    

   def receive_data data
     send_data ">>>you sent: #{data}"
     close_connection if data =~ /quit/i
   end

   def unbind
     puts "-- someone disconnected from the echo server!"
   end
end

EventMachine::run {
  EM.open_datagram_socket('0.0.0.0', 8081, UDPHandler)
  
}
