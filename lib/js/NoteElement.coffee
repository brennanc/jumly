HTMLElement = require "HTMLElement"

class NoteElement extends HTMLElement
  constructor: (args, attrs)->
    super args, (me)->
      me.append($("<div>").addClass("name"))
    @css attrs.css if attrs

core = require "core"

if core.env.is_node
  module.exports = NoteElement
else
  core.exports NoteElement