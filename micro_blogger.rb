require 'jumpstart_auth'
require 'bitly'
require 'klout'

class MicroBlogger
    attr_reader :client

    def initialize
        Bitly.use_api_version_3
        @bitly = Bitly.new("hungryacademy", "R_430e9f62250186d2612cca76eee2dbc6")
        Klout.api_key = "xu9ztgnacmjx3bu82warbr3h"
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

    def followers_list
        screen_names = []
        @client.followers.users.each do |user|
            screen_names << user["screen_name"]
        end
        return screen_names
    end

    def spam_my_followers(message)
        followers = self.followers_list
        followers.each do |f|
            self.dm(f, message)
        end
    end

    def everyones_last_tweet
        friends = @client.friends
        friends = friends.sort_by{|friend| friend.screen_name.downcase}
        friends.each do |friend|
            ts = friend.status.created_at
            puts "#{friend.screen_name} said this on #{ts.strftime("%A, %b %d")}..."
            puts "#{friend.status.text}"            
            puts ""
        end
    end

    def shorten(original_url)
        puts "Shortening this URL: #{original_url}"
        return @bitly.shorten(original_url)
    end

    def klout_score
        puts "Klout Scores"
        friends = @client.friends.collect{|f| f.screen_name}
        friends.each do |friend|
            printf "#{friend}: "
            i = Klout::Identity.find_by_screen_name(friend)
            user = Klout::User.new(i.id)
            puts "#{user.score.score}"
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
                when "dm" then self.dm(parts[1], parts[2..-1].join(" "))
                when "spam" then self.spam(parts[1..-1].join(" "))
                when "elt" then self.everyones_last_tweet
                when "s" then self.shorten(parts[1..-1].join(" "))
                when "turl" then self.tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
                when "k" then self.klout_score
                else
                    puts "Sorry, I don't know how to #{command}"
            end
        end
    end
end

b = MicroBlogger.new
b.run
