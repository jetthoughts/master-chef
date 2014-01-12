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
      console.log('stub!')

  AceInitializer.init()
