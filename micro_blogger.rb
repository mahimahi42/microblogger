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

    def dm(target, message)
        puts "Trying to send @#{target} this direct message:"
        puts message

        screen_names = @client.followers.collect{|follower| follower.screen_name}

        if screen_names.include? target 
            mess = "d #{target} #{message}"
            self.tweet(mess)
        else
            puts "You can only DM people following you!"
        end
    end

    def run
        puts "Welcome to the JSL Twitter Client!"
        command = ""
        while command != "q"
            printf "enter command: "
            input = gets.chomp
            parts = input.split(" ")
            command = parts[0]
            case command
                when "q" then puts "Goodbye!"
                when "t" then self.tweet(parts[1..-1].join(" "))
                when "dm" then dm(parts[1], parts[2..-1].join(" "))
                else
                    puts "Sorry, I don't know how to #{command}"
            end
        end
    end
end

b = MicroBlogger.new
b.run
