class Collection
  include Mongoid::Document

  field :name, type: String

  belongs_to :user
  has_and_belongs_to_many :blogs

  validates :user, :name, presence: true


end
