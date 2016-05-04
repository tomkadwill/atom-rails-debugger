fs = require "fs"

AtomRailsDebuggerView = require './atom-rails-debugger-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomRailsDebugger =
  atomRailsDebuggerView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomRailsDebuggerView = new AtomRailsDebuggerView(state.atomRailsDebuggerViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomRailsDebuggerView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-rails-debugger:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomRailsDebuggerView.destroy()

  serialize: ->
    atomRailsDebuggerViewState: @atomRailsDebuggerView.serialize()

  toggle: ->

    editor = atom.workspace.getActiveTextEditor()
    projectRoot = atom.project.getPaths()[0]
    row = editor.getCursorBufferPosition().row + 1
    path = editor.getPath()

    lineToWrite = "#{path}:#{row}\n"

    fs.appendFile "#{projectRoot}/.breakpoints", lineToWrite, (error) ->
      console.error("Error writing breakpoint to file", error) if error
