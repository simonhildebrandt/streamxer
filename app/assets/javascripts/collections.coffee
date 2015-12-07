React = require 'react'
R = require './factories'
M = require './models'
Backbone = require 'backbone'
ReactSelectAsync = React.createFactory(require('react-select').Async)
classNames = require 'classnames'
$ = require 'jquery'


CollectionView = React.createClass
  displayName: 'CollectionView'

  delete: ->
    @props.model.destroy()

  render: ->
    R.li { onClick: @props.onClick, className: classNames('selected': @props.selected) },
      R.span {}, @props.name
      R.span { className: 'delete', onClick: @delete }, '×' if @props.selected && @props.deleteable

CollectionView = React.createFactory(CollectionView)


CollectionCreator = React.createClass
  displayName: 'CollectionCreator'

  getInitialState: ->
    editing: false

  cancelEditing: ->
    @setState editing: false,

  keyDown: (event) ->
    if event.keyCode == 13
      event.preventDefault()
      c = new M.Collection(name: $(event.target).val())
      c.save()
      @props.collection.add c
      @setState editing: false

  render: ->
    if @state.editing
      R.li { className: 'selected' },
        R.input {
          placeholder: 'Create a collection...',
          autoFocus: true,
          onBlur: @cancelEditing,
          onKeyDown: @keyDown
        }
    else
      R.li
        onClick: =>
          @setState editing: true,
        R.span {}, '+'

CollectionCreator = React.createFactory(CollectionCreator)


CollectionsList = React.createClass
  mixins: [Backbone.React.Component.mixin]
  displayName: 'CollectionsList'

  componentDidMount: ->
    @props.collection.fetch()

  render: ->
    R.div { className: 'collection-wrapper' },
      R.ul { className: 'collections_list' },
        CollectionView
          key: '_all',
          name: 'all',
          selected: @props.display.mode == 'all',
          onClick: =>
            @props.switch_blogs
              mode: 'all'
        CollectionView
          key: '_none',
          name: 'none',
          selected: @props.display.mode == 'none',
          onClick: =>
            @props.switch_blogs
              mode: 'none'
        @props.collection.map (collection) =>
          CollectionView
            key: collection.cid,
            name: collection.get('name'),
            selected: @props.display.collection == collection.id,
            deleteable: true,
            model: collection,
            onClick: =>
              @props.switch_blogs
                collection: collection.id
        CollectionCreator key: '_add', collection: @props.collection



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
    @collections().set(newValue)
    @props.model.save()

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
