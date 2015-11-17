class Image
  include Mongoid::Document

  field :url, type: String
  field :width, type: Integer
  field :height, type: Integer

  embedded_in :imageish, polymorphic: true
end
