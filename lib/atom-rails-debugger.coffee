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
    console.log 'AtomRailsDebugger was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
