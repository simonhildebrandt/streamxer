React = require 'react'
Backbone = require 'backbone'
R = require './factories'
M = require './models'
C = require './collections'
$ = require 'jquery'


BlogView = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'BlogView'

  id: ->
    @props.model.id

  render: ->
    R.div {},
      R.a {href: "/blogs/" + @id()}, @id()
      C.CollectionTools model: @props.model

BlogView = React.createFactory(BlogView)


BlogList = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'BlogList'

  componentDidMount: ->
    @props.collection.fetch()

  render: ->
    R.div {},
      @props.collection.map (blog) =>
        BlogView key: blog.id, model: blog


module.exports =
  BlogList: React.createFactory(BlogList)
