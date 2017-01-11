'use babel';

{ CompositeDisposable } = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'letify:convert': => @convert()

  deactivate: ->
    @subscriptions.dispose()

  convert: ->
    if editor = atom.workspace.getActiveTextEditor()
      if editor.hasMultipleCursors()
        console.log("Giving up, multiple cursors")
        return

      if editor.getSelectedText().match(/\n/)
        console.log("Giving up, multiple lines")
        return

      point = editor.getCursorBufferPosition()
      editor.selectLinesContainingCursors()
      selection = editor.getSelectedText()
      match = selection.match(/(\s*)(.*)=(.*)/)
      if !match
        console.log("Giving up, no match on line");
        return

      letStatement = match[1] + 'let(:' + match[2].trim() + ') { ' + match[3].trim() + " }\n"
      editor.insertText(letStatement)
      editor.setCursorScreenPosition(point)
