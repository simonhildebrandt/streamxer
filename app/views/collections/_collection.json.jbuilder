json.(c, :name, :post_count)
json.id c.id.to_s
json.blogs c.blogs do |blog|
  json.id blog.id.to_s
  json.name blog.name
end
