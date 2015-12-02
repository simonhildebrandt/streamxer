class User
  include Mongoid::Document

  field :oauth_token, type: String
  field :oauth_token_secret, type: String
  field :uid, type: String

  has_and_belongs_to_many :blogs
  has_many :collections


  def client
    Tumblr::Client.new(oauth_credentials)
  end

  def update_following!
    self.update_attributes!(blogs: following_blogs)
  end

  private

  def following_blogs
    blogs = []
    offset = 0
    loop do
      puts "collecting blogs #{offset}"
      result = client.following(offset: offset)
      blogs += result['blogs'].map{|r| Blog.upsert!(r)}
      offset += 20
      break if offset > result['total_blogs']
    end
    blogs
  end

  def oauth_credentials
    { oauth_token: oauth_token, oauth_token_secret: oauth_token_secret }
  end
end
