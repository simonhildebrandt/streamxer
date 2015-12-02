React = require 'react'

tags = ['div', 'em', 'span', 'a', 'button', 'input']

module.exports = tags.reduce (x, y) ->
    x[y]= React.createFactory y
    x
, {}
