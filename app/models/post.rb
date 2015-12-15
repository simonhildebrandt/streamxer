class Post
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include TumblrClient

  field :tumblr_id, type: String
  field :published_at, type: Time

  embeds_many :photos

  belongs_to :blog

  scope :photos, -> { where type: 'photo' }
  scope :newest, -> { order :tumblr_id.desc }

  index(blog_id: 1)
  index({tumblr_id: 1}, {unique: true})

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
      new_posts = []

      loop do
        puts "collecting posts: #{offset}"
        result = client.posts(blog.name, offset: offset)

        if result['status'] == 404
          blog.update_attributes! deactivated: true
          break
        end

        break unless result['posts'].is_a? Array

        tids = result['posts'].map { |p| p['id'].to_s }
        overlaps = blog.posts.in(tumblr_id: tids).pluck(:tumblr_id)
        new_posts += result['posts'].reject {|p| overlaps.include?(p['id'].to_s) }

        offset += TumblrClient::PAGE_SIZE
        break if !overlaps.empty? || offset > result['total_posts'] || offset >= MAX_POSTS
      end

      blog.posts.create!(new_posts)
    end
  end
end
