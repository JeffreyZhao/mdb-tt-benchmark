require 'tokyotyrant'
include TokyoTyrant

# create the object
db = RDBTBL::new

# connect to the server
if !db.open("127.0.0.1", 1978)
    ecode = db.ecode
    STDERR.printf("open error: %s\n", db.errmsg(ecode))
end

time_to_get = 100 * 100 * 100
start_time = Time.now.to_i
gets_count = 0

time_to_get.times do

	id = rand(110 * 10000) + 1
	db.get("news_#{id}")
	
	gets_count = gets_count + 1
	if (gets_count % 100000 == 0)
		end_time = Time.now.to_i
		puts "#{gets_count} gets: #{end_time - start_time} seconds"
	end	
end