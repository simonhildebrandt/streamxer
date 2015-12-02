json.array! @collections do |collection|
  json.partial! 'collection', c: collection
end
