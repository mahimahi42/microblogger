require 'jumpstart_auth'

class MicroBlogger
    attr_reader :client

    def initialize
        puts "Initializing..."
        @client = JumpstartAuth.twitter
    end

    def tweet(message)
        if message.length <= 140
            @client.update(message)
        else
            puts "Tweet is too long!"
        end
    end

    def run
        puts "Welcome to the JSL Twitter Client!"
        command = ""
        while command != "q"
            printf "enter command: "
            command = gets.chomp
        end
    end
end

b = MicroBlogger.new
b.run
