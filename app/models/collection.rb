class Collection
  include Mongoid::Document

  field :name, type: String

  belongs_to :user
  has_and_belongs_to_many :blogs

  validates :user, :name, presence: true

  scope :search_by_name, -> (name) { where name: /#{name}/ }


  def posts
    Post.in(blog: blogs.map(&:id))
  end
end
