require 'sinatra/activerecord'

class Userpost < ActiveRecord::Base
   belongs_to :user
end

class User < ActiveRecord::Base
   has_many :userposts, :dependent => :delete_all
   has_many :posts, :dependent => :delete_all
end

class Post < ActiveRecord::Base
    belongs_to :user
end
