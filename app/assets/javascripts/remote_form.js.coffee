class @RemoteForm
  constructor: (element)->
    @element = $(element)
    @bindings()

  bindings: ->
    @element.on 'ajax:before', @onAjaxStart
    @element.on 'ajax:complete', @onAjaxFinish

  onAjaxStart: =>
    @submitButton = @element.find(':submit')
    @addSpinner()
    @disableSubmitButton()

  onAjaxFinish: =>
    @removeSpinner()
    @enableSubmitButton()

  addSpinner: ->
    @submitButton.addClass('active')
    @submitButton.prepend @spinnerIcon()

  removeSpinner: ->
    @submitButton.find('.remote-form-spinner').remove()

  disableSubmitButton: ->
    @submitButton.addClass('active')
    @submitButton.attr("disabled", "disabled")

  enableSubmitButton: ->
    @submitButton.removeClass('active')
    @submitButton.removeAttr("disabled")

  spinnerIcon: ->
    '<span class="remote-form-spinner"><i class="fa fa-spinner fa-spin"></i>&nbsp;</span>'

$ ->
  $('form[data-remote="true"]').each (i, element) ->
    new RemoteForm element
