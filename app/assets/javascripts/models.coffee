Backbone = require 'backbone'
require 'backbone-relational'
_ = require 'underscore'


Collection = Backbone.RelationalModel.extend
  url: '/collections'


Blog = Backbone.RelationalModel.extend
  idAttribute: 'name'

  relations: [
    type: Backbone.HasMany,
    key: 'collections',
    relatedModel: Collection
  ]

  initialize: ->
    @bind 'add:collections remove:collections', (collection, coll) =>
      @save
        collection_ids: @get('collections').map (collection) ->
          collection.get('id')

      @trigger("change", @)


Blogs = Backbone.Collection.extend
  model: Blog
  url: '/blogs'


Collections = Backbone.Collection.extend
  model: Collection
  url: '/collections'


module.exports =
  Blogs: Blogs
  Collections: Collections
