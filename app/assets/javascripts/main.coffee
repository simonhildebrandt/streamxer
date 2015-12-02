React = require 'react'
ReactDOM = require 'react-dom'
Backbone = require 'backbone'
R = require './factories'
M = require './models'
B = require './blog'
C = require './collections'
$ = require 'jquery'


Suite = React.createClass
  displayName: 'Suite'

  getInitialState: ->
    blogs: new M.Blogs()
    collections: new M.Collections()

  switch_blogs: (options) ->
    @state.blogs.fetch data: options

  render: ->
    R.div {},
      C.CollectionsList
        collection: @state.collections
        switch_blogs: @switch_blogs
      B.BlogList { collection: @state.blogs }


$ ->
  ReactDOM.render React.createElement(Suite), $('#main').get(0)
