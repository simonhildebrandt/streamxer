class Photo
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :caption, type: String

  embedded_in :post
  embeds_many :alt_sizes, class_name: 'Image', as: :imageish
  embeds_one :original_size, class_name: 'Image', as: :imageish
end
