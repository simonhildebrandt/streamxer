json.(blog, :name, :post_count)
json.id blog.id.to_s
json.collections blog.collections do |collection|
  json.id collection.id.to_s
  json.name collection.name
end
