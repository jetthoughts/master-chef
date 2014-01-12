jQuery ->
  AceInitializer =

    init: ->
      AceInitializer.initEditors()
      AceInitializer.initHighlights()

    setTheme: (selector, editor) ->
      theme = $(selector).data('theme') || 'monokai'
      editor.setTheme('ace/theme/' + theme)

    setLanguage: (selector, editor) ->
      language = $(selector).data('language') || 'json'
      editor.getSession().setMode('ace/mode/' + language)

    createEditorTarget: (source) ->
      target = $('<div>')
      target.addClass(source.attr('class'))
      target.insertAfter(source)
      target


    initEditors: ->
      editorSelector = $('.ace-editor')

      editorSelector.each (index, editorSource) ->
        editorSource = $(editorSource)
        editorSource.hide()

        editorTarget = AceInitializer.createEditorTarget(editorSource)

        editor = ace.edit(editorTarget[0])
        AceInitializer.setTheme(editorSource, editor)
        AceInitializer.setLanguage(editorSource, editor)

        editor.setValue(editorSource.val())

        editorSource.closest('form').on 'submit', ->
          editorSource.val(editor.getValue())

    initHighlights: ->
      highlightSelector = $('.ace-highlight')

      highlightSelector.each (index, highlightSource) ->
        highlightSource = $(highlightSource)

        editor = ace.edit(highlightSource[0])
        AceInitializer.setTheme(highlightSource, editor)
        AceInitializer.setLanguage(highlightSource, editor)
        editor.setReadOnly(true)
        editor.setHighlightGutterLine(false)

  AceInitializer.init()
