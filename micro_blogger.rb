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
    end
end

b = MicroBlogger.new
b.tweet("MicroBlogger initialized!")
b.tweet("".ljust(140, "abcd"))
b.tweet("".ljust(150, "abcd"))
