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
    display:
      mode: 'all'

  switch_blogs: (options) ->
    @setState display: options
    @state.blogs.fetch data: options

  render: ->
    R.div { className: 'suite' },
      C.CollectionsList
        collection: @state.collections
        switch_blogs: @switch_blogs
        display: @state.display
      B.BlogList { collection: @state.blogs }


$ ->
  if $('#main').length
    ReactDOM.render React.createElement(Suite), $('#main').get(0)
