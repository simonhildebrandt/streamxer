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

  has_and_belongs_to_many :users
  has_and_belongs_to_many :collections

  validates :name, presence: true


  def collection_names
    collections.map(&:name)
  end

  class << self
    def upsert!(blog)
      find_or_initialize_by(name: blog['name']).tap do |bl|
        bl.update_attributes!(blog)
      end
    end
  end
end
