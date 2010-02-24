require 'tokyotyrant'
include TokyoTyrant

# create the object
db = RDBTBL::new

# connect to the server
if !db.open("127.0.0.1", 1978)
    ecode = db.ecode
    STDERR.printf("open error: %s\n", db.errmsg(ecode))
end

time_to_update = 100 * 100 * 100
start_time = Time.now.to_i
update_count = 0

time_to_update.times do

	id = rand(110 * 10000) + 1
    create_time = Time.now
	title = "This is title of news #{id} - updated at #{create_time}"
    source = "source of news #{id} - updated at #{create_time}"
    source_url = "http://www.cnblogs.com/JeffreyZhao/ - updated at #{create_time}"
    status = rand(5)
    
    note = db.get("news_#{id}")
    note["CreateTime"] = create_time.to_i.to_s
    note["Title"] = title
    note["Source"] = source
    note["SourceUrl"] = source_url
    note["Status"] = status.to_s
    db.put("news_#{id}", note)
	
	update_count = update_count + 1
	if (update_count % 10000 == 0)
		end_time = Time.now.to_i
		puts "#{update_count} updates: #{end_time - start_time} seconds"
	end	
end