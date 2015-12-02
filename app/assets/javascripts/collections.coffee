React = require 'react'
R = require './factories'
M = require './models'
Backbone = require 'backbone'
ReactSelectAsync = React.createFactory(require('react-select').Async)


CollectionView = React.createClass
  displayName: 'CollectionView'

  render: ->
    R.div { onClick: @props.onClick }, @props.name

CollectionView = React.createFactory(CollectionView)


CollectionsList = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'CollectionsList'

  componentDidMount: ->
    @props.collection.fetch()

  render: ->
    R.div {},
      CollectionView
        key: '_all',
        name: 'all',
        onClick: =>
          @props.switch_blogs
            mode: 'all'
      CollectionView
        key: '_none',
        name: 'none',
        onClick: =>
          @props.switch_blogs
            mode: 'none'
      @props.collection.map (collection) =>
        CollectionView
          key: collection.id,
          name: collection.get('name'),
          onClick: =>
            @props.switch_blogs
              collection: collection.id


CollectionTools = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'CollectionTools'

  getInitialState: ->
    { results: new M.Collections() }

  suggestions: (input) ->
    @state.results.fetch
      data:
        search: input
    .then =>
      {
        options: @state.results.models
      }

  changed: (newValue, selectedOptions) ->
    console.log(newValue)
    @collections().set(newValue)

  collections: ->
    @props.model.get('collections')

  renderer: (value) ->
    value.get('name')

  render: ->
    ReactSelectAsync
      value: @collections().models
      inputProps:
        autoFocus: true
      multi: true
      onChange: @changed
      loadOptions: @suggestions
      cache: null
      valueRenderer: @renderer
      optionRenderer: @renderer
      placeholder: "Add to collections..."
      filterOptions: (options) ->
        options
      allowCreate: true
      newOptionCreator: (name) ->
        console.log 'creating ' + name


module.exports =
  CollectionTools: React.createFactory(CollectionTools)
  CollectionsList: React.createFactory(CollectionsList)
