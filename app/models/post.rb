class Post
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include TumblrClient

  field :tumblr_id, type: String
  field :published_at, type: Time

  embeds_many :photos

  belongs_to :blog, counter_cache: :post_count

  scope :photos, -> { where(type: 'photo') }
  scope :newest, -> { order(:tumblr_id.desc) }

  MAX_POSTS = 100


  def id=(t_id)
    self.tumblr_id = t_id
  end

  def timestamp=(ts)
    self.published_at = Time.at(ts)
  end

  class << self
    def collect_posts!(blog)
      puts "collecting posts from #{blog.name}"
      offset = 0

      catch :post_exists do
        loop do
          puts "collecting posts: #{offset}"
          result = client.posts(blog.name, offset: offset)

          if result['status'] == 404
            blog.update_attributes! deactivated: true
            break
          end

          break unless result['posts'].is_a? Array
          result['posts'].map do |p|
            Post.upsert!(blog, p)
          end

          offset += 20
          break if offset > result['total_posts'] || offset >= MAX_POSTS
        end
      end
    end

    def upsert!(blog, post)
      blog.posts.find_or_initialize_by(tumblr_id: post['id']).tap do |pst|
        throw :post_exists if pst.persisted?

        pst.update_attributes!(post)
      end
    end
  end
end
