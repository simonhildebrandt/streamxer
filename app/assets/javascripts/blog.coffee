React = require 'react'
Backbone = require 'backbone'
classNames = require 'classnames'
R = require './factories'
M = require './models'
C = require './collections'
$ = require 'jquery'
Masonry = React.createFactory(require('react-masonry-component')(React))

BlogView = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'BlogView'

  id: ->
    @props.model.id

  title: ->
    @state.model.title

  description: ->
    @state.model.description

  post_count: ->
    @state.model.post_count

  render: ->
    R.div { className: 'blog' },
      R.div { className: 'title' }, R.a { href: "/blogs/" + @id() }, @title() || @id()
      R.div { className: 'id' }, @id() + ' - ' + @post_count() + ' posts'
      R.div { className: 'description' }, @description()
      C.CollectionTools model: @props.model

BlogView = React.createFactory(BlogView)


BlogList = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'BlogList'

  componentDidMount: ->
    @props.collection.fetch()

  render: ->
    Masonry { className: 'blogs', options: {itemSelector: '.blog', columnWidth: 322} },
      @props.collection.map (blog) =>
        BlogView key: blog.id, model: blog


module.exports =
  BlogList: React.createFactory(BlogList)
