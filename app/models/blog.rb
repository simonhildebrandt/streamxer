class Blog
  include Mongoid::Document

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

  field :post_count, type: Integer

  has_and_belongs_to_many :users
  has_and_belongs_to_many :collections
  has_many :posts

  validates :name, presence: true

  scope :uncollected, -> { where(:collection_ids.in => [[], nil]) }
  

  def to_param
    name
  end

  def collection_names
    collections.map(&:name)
  end

  def update_posts!
    Post.collect_posts!(self)
    update_attributes! last_updated_at: Time.current
  end

  class << self
    def upsert!(blog)
      find_or_initialize_by(name: blog['name']).tap do |bl|
        bl.update_attributes!(blog)
      end
    end
  end
end
