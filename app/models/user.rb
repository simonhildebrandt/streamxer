class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include TumblrClient

  field :oauth_token, type: String
  field :oauth_token_secret, type: String
  field :uid, type: String

  has_and_belongs_to_many :blogs
  has_many :collections

  after_create do |user|
    user.sync_blogs!
  end


  def client
    Tumblr::Client.new(oauth_credentials)
  end

  def update_following!
    self.update_attributes!(blogs: following_blogs)
  end

  private

  def sync_blogs!
    SyncBlogsForUserWorker.perform_async(id)
  end

  def following_blogs
    blogs = []
    offset = 0
    loop do
      puts "collecting blogs #{offset}"
      result = following_with_offset(offset)
      break unless result['blogs'].is_a? Array
      blogs += result['blogs'].map{|r| Blog.upsert!(r)}
      offset += 20
      break if offset > result['total_blogs']
    end
    blogs
  end

  def following_with_offset offset
    client.following(offset: offset).tap do |result|
      if result['status'] == 403
        fail TumblrClient::Error.new(result['msg'])
      end
    end
  end

  def oauth_credentials
    { oauth_token: oauth_token, oauth_token_secret: oauth_token_secret }
  end
end
