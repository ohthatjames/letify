# require '../lib/letify'

describe "waiting for the packages to load", ->
  [activationPromise, editor, workspaceElement] = []

  executeCommand = (callback) ->
    atom.commands.dispatch(workspaceElement, 'letify:convert')
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      workspaceElement = atom.views.getView(atom.workspace)
      activationPromise = atom.packages.activatePackage('letify')

  it 'turns a local variable assignment to a let statement', ->
    editor.setText("variable = 'answer'")
    editor.setCursorBufferPosition([0,0])
    executeCommand ->
      expect(editor.getText()).toEqual "let(:variable) { 'answer' }\n"

  it 'respects indentation', ->
    editor.setText("    variable = 'answer'")
    editor.setCursorBufferPosition([0,0])
    executeCommand ->
      expect(editor.getText()).toEqual "    let(:variable) { 'answer' }\n"

  it 'strips whitespace around the =', ->
    editor.setText("variable   =    'answer'")
    editor.setCursorBufferPosition([0,0])
    executeCommand ->
      expect(editor.getText()).toEqual "let(:variable) { 'answer' }\n"

  it "doesn't change lines that don't contain assignment", ->
    editor.setText("omg")
    editor.setCursorBufferPosition([0,0])
    executeCommand ->
      expect(editor.getText()).toEqual "omg"

  it "ignores multiple cursors", ->
    editor.setText("variable = 'answer'")
    editor.setCursorBufferPosition([0,0])
    editor.addCursorAtBufferPosition([0,1])
    executeCommand ->
      expect(editor.getText()).toEqual "variable = 'answer'"

  it "ignores initial selections spanning multiple lines", ->
    editor.setText("variable = 'answer'\nomg = 'blah'")
    editor.setCursorBufferPosition([0,0])
    editor.addCursorAtBufferPosition([0,1])
    executeCommand ->
      expect(editor.getText()).toEqual "variable = 'answer'\nomg = 'blah'"
