class Blog
  include Mongoid::Document
  include Mongoid::Timestamps
  include TumblrClient

  field :name, type: String
  field :title, type: String
  field :description, type: String
  field :url, type: String
  field :posts, type: Integer
  field :likes, type: Integer
  field :updated, type: DateTime
  field :ask, type: Boolean
  field :ask_anon, type: Boolean
  field :display_type, type: String
  field :last_updated_at, type: Time
  field :deactivated, type: Boolean, default: false
  field :syncing, type: Boolean, default: false

  field :post_count, type: Integer

  AVATAR_SIZES = [16, 24, 30, 40, 48, 64, 96, 128, 512]
  embeds_many :avatars, class_name: 'Image', as: :imageish

  has_and_belongs_to_many :users
  has_and_belongs_to_many :collections
  has_many :posts, dependent: :destroy

  validates :name, presence: true

  scope :uncollected, -> { where(:collection_ids.in => [[], nil]) }
  scope :sfw, -> { queryable.not.where(name: /porn|slut|anal|sexy|dominat|bitch|gag|women/) }
  scope :active, -> { where deactivated: false }

  after_create do |blog|
    blog.sync!
  end


  def to_param
    name
  end

  def collection_names
    collections.map(&:name)
  end

  def update_avatars!
    update_attributes! avatars: all_avatar_images
  end

  def all_avatar_images
    AVATAR_SIZES.map do |size|
      { url: self.class.client.avatar(name, size), width: size, height: size }
    end
  end

  def update_posts!
    Post.collect_posts!(self)
    posts.newest.skip(Post::MAX_POSTS).destroy_all
    update_attributes! last_updated_at: Time.current
  end

  def sync!
    start_post_sync!
    SyncAvatarsForBlogWorker.perform_async(id)
  end

  def start_post_sync!
    update_attributes! syncing: true
    SyncPostsForBlogWorker.perform_async(id)
  end

  def finished_post_sync!
    update_attributes! syncing: false
  end

  class << self
    def upsert!(blog)
      find_or_initialize_by(name: blog['name']).tap do |bl|
        bl.update_attributes!(blog)
      end
    end
  end
end
