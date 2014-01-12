class Project
  constructor: ->
    $('[data-behavior=update_cookbooks_lock]').on 'ajax:success', (event, project, status, xhr) ->
      $target = $($(event.currentTarget).data('rel'))
      console.log project.cookbooks_lock
      $target.html project.cookbooks_lock
      true

$ ->
  new Project()
