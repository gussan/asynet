require 'optparse'
require 'em-synchrony'
require 'em-synchrony/fiber_iterator'
require 'fiber'

module Asynet
  module Commands
    class Cli
      DEFAULTS = {
        :concurrency => 4,
        :num => 0,
        :wait => 0
      }

      def initialize(host, port, command, options = {})
        @host = host
        @port = port
        @command = command
        @options = DEFAULTS.merge!(options)
        @num = (@options[:num] > 0) ? 0 : -1
      end

      def execute
        puts "connecting: #{@host}:#{@port}, command: #{@command}"
        EM.synchrony do
          EM::Synchrony::FiberIterator.new([self]*@options[:concurrency], @options[:concurrency]).map do |cli, iter|
            while @options[:num] > @num
              begin
                socket = EventMachine::Synchrony::TCPSocket.open(@host, @port)
                fibered_log @command
                socket.write(instance_eval("%@#{@command.gsub('@', '\@')}@") + "\r\n")
                fibered_log socket.read
              rescue => err
                fibered_log err.inspect
              ensure
                @num += 1 if @options[:num] > 0
                socket.close if socket
                EM::Synchrony.sleep(@options[:wait])
              end
            end
          end
          EM.stop
        end
      end

      def self.parse!(args)
        command = args.pop
        port = args.pop
        host = args.pop

        options = {}
        opt = OptionParser.new
        opt.on("-c CONCURRENCY") {|v| options[:concurrency] = v.to_i }
        opt.on("-n TIMES") {|v| options[:num] = v.to_i }
        opt.on("-w WAIT") {|v| options[:wait] = v.to_f }
        opt.parse!(args)

        self.new(host, port, command, options)
      end

      def fibered_log(*str)
        puts "[#{Fiber.current()}] #{str.join(' ')}"
      end
    end
  end
end
