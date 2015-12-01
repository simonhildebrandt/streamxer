class Post
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :tumblr_id, type: String
  field :published_at, type: Time

  embeds_many :photos

  belongs_to :blog, counter_cache: :post_count

  scope :newest, -> { order(:published_at.desc) }
  scope :photos, -> { where(type: 'photo') }


  def id=(t_id)
    self.tumblr_id = t_id
  end

  def timestamp=(ts)
    self.published_at = Time.at(ts)
  end

  class << self
    def client
      Tumblr::Client.new
    end

    def collect_posts!(blog)
      puts "collecting posts from #{blog.name}"
      posts = []
      offset = 0
      loop do
        puts "collecting posts: #{offset}"
        result = client.posts(blog.name, offset: offset)
        break unless result['posts'].is_a? Array
        result['posts'].map{ |p| Post.upsert!(blog, p) }
        offset += 20
        break if offset > result['total_posts'] || offset >= 100
      end
    end

    def upsert!(blog, post)
      blog.posts.find_or_initialize_by(tumblr_id: post['id']).tap do |pst|
        pst.update_attributes!(post)
      end
    end
  end
end
