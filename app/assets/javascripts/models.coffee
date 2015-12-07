Backbone = require 'backbone'
require 'backbone-relational'
_ = require 'underscore'


Collection = Backbone.RelationalModel.extend
  urlRoot: '/collections'


Blog = Backbone.RelationalModel.extend
  idAttribute: 'name'
  toJSON: (options) ->
    {
      collection_ids: @get('collections').map (collection) =>
        collection.get('id')
    }

  relations: [
    type: Backbone.HasMany,
    key: 'collections',
    relatedModel: Collection
  ]


Blogs = Backbone.Collection.extend
  model: Blog
  url: '/blogs'


Collections = Backbone.Collection.extend
  model: Collection
  url: '/collections'


module.exports =
  Blogs: Blogs
  Collections: Collections
  Collection: Collection
