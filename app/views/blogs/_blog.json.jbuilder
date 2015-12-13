json.(blog, :name, :title, :description, :post_count, :syncing)
json.avatar blog.avatars.last
json.id blog.id.to_s
json.collections blog.collections do |collection|
  json.id collection.id.to_s
  json.name collection.name
end
