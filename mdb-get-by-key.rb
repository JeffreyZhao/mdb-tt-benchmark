require 'rubygems'
require 'mongo'

db = Mongo::Connection.new.db("test")
things = db["news"]

time_to_get = 100 * 100 * 100
start_time = Time.now.to_i
gets_count = 0

time_to_get.times do

	id = rand(110 * 10000) + 1
	things.find_one({ "_id" => id })
	
	gets_count = gets_count + 1
	if (gets_count % 100000 == 0)
		end_time = Time.now.to_i
		puts "#{gets_count} gets: #{end_time - start_time} seconds"
	end	
end