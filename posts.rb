require 'sequel'
DB = "sqlite://application.db"
def added_message(name, msg)
    Sequel.connect(DB) do |db|
	posts = db[:posts]
	posts.insert(:time => Time.now.to_s, :name => name, :msg => msg)
    end
end

def get_posts(range)
    Sequel.connect(DB) do |db|
	posts = db[:posts]
	array = posts.where(:id => range)
	array.all
    end
end

def last_post_id
    Sequel.connect(DB) do |db|
	db[:posts].order(:id).last[:id]
    end
end