jQuery ->
  editorSelector = $('#ace-editor')
  if editorSelector[0]
    language = editorSelector.data('language') || 'javascript'
    theme = editorSelector.data('theme') || 'monokai'
    editor = ace.edit('ace-editor')
    editor.setTheme('ace/theme/' + theme)
    editor.getSession().setMode('ace/mode/' + language)
