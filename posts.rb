require 'sequel'
class Posts
  def initialize
    @DB = Sequel.connect("sqlite://application.db")
  end
public
  def added_message(name, msg)
      # added a message in posts database
        posts = @DB[:posts]
        posts.insert(:time => Time.now.to_s, :name => name, :msg => msg)
  end
  
  def get_posts(range)
      # return array posts in range
        @DB[:posts].where(:id => range).all
  end
  
  def get_posts_by_user(name, page = 1)
      #return user posts
        @DB[:posts].select(:id, :time, :name, :msg).where(:name => name).order(:id).limit(10).offset((page.to_i-1)*10).all.reverse
  end
  
  def get_posts_by_tag(tag, page = 1)
      #return posts included #tag
  #   posts = @DB['select id, time, name, msg from posts where msg like ? limit 10 offset ?', '%#'+tag+'%',(page.to_i-1)*10]
        @DB[:posts].select(:id, :time, :name, :msg).where(Sequel.like(:msg, '%#'+tag+'%')).order(:id).limit(10).offset((page.to_i-1)*10).all.reverse
  end
  
  def last_tag_post_id(tag)
        @DB[:posts].where(Sequel.like(:msg, '%#'+tag+'%')).count.to_i
  end
  
  def last_user_post_id(name)
  #   posts = @DB['select count(msg) from posts where name = ?', name]
        @DB[:posts].where(:name => name).count.to_i
  end
  def last_post_id
      #return id last post in @DB
        @DB[:posts].max(:id)
  end
end

