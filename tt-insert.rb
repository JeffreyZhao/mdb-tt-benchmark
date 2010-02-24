require 'tokyotyrant'
include TokyoTyrant

# create the object
db = RDBTBL::new

# connect to the server
if !db.open("127.0.0.1", 1978)
    ecode = db.ecode
    STDERR.printf("open error: %s\n", db.errmsg(ecode))
end

puts db.vanish()

# puts db.setindex("ID", RDBTBL::ITDECIMAL | RDBTBL::ITKEEP)
puts db.setindex("UserID", RDBTBL::ITDECIMAL | RDBTBL::ITKEEP)
puts db.setindex("CategoryID", RDBTBL::ITDECIMAL | RDBTBL::ITKEEP)
puts db.setindex("CreateTime", RDBTBL::ITDECIMAL | RDBTBL::ITKEEP)
puts db.setindex("Tags", RDBTBL::ITTOKEN | RDBTBL::ITKEEP)

all_tags = [];
chars = ('a' .. 'z')
chars.each { |x|
    chars.each { |y|
        chars.each { |z|
            all_tags << x + y + z
        }
    }
}

tag_index = 0;
id = 1
user_count = 10000
begin_seconds = Time.mktime(2010, 1, 1).to_i # (1 Jan 2001)

start_time = Time.now.to_i

(1 .. 200 * 100).each do |cat_id| # 20000 × 55 = 1,100,000
    count = (cat_id % 10 + 1) * 10
    count.times do 
        title = "This is title of news #{id}"
        create_time = Time.at(begin_seconds + id)
        user_id = cat_id % user_count
        source = "source of news #{id}"
        source_url = "http://www.cnblogs.com/JeffreyZhao/"
        status = 1
        
        tags = ["Tag_#{cat_id % 3}_#{id % 5}"];
        tag_count = id % 5 + 1
        tag_count.times do
            tags << all_tags[tag_index % all_tags.size]
            tag_index = tag_index + 1
        end
        
        db.put("news_#{id}", {
            "ID" => id.to_s,
            "Title" => title,
            "CategoryID" => cat_id.to_s,
            "CreateTime" => create_time.to_i.to_s,
            "UserID" => user_id.to_s,
            "Tags" => tags.join(" "),
            "Source" => source,
            "SourceUrl" => source_url,
            "Status" => status
      	});
        
=begin
        puts "=== #{id} ==="
        puts "Title: #{title}"
        puts "CategoryID: #{cat_id}"
        puts "UserID: #{user_id}"
        puts "CreateTime #{create_time}"
        puts "Tags: #{tags.join(',')}"
        puts "Source: #{source}"
        puts "SourceUrl: #{source_url}"
=end
        id = id + 1
        
        if (id % (100 * 1000) == 0)
            end_time = Time.now.to_i
            puts "#{id} records: #{end_time - start_time} seconds";
        end
    end
end