class Deployment
  constructor: ->
    $logElements = $('[data-behavior=real_time_logs]')
    $logElements.each @colorize
    $logElements.each @init_pusher_for

  colorize: (index, element) ->
    $this = $ element
    html = ansi_up.ansi_to_html($this.text())
    $this.html html

  init_pusher_for: (index, element) =>
    $this = $(element)
    pusher_key = $this.data('pusher-key')
    channel_name = $this.data('pusher-channel')
    pusher = new Pusher(pusher_key)
    channel = pusher.subscribe(channel_name)
    @channel_bindings(channel, $this)

  channel_bindings: (channel, $element) ->

    channel.bind 'append_log', (data) ->
      content = ansi_up.ansi_to_html data.message
      $element.append content
      $element.scrollTop $element.scrollHeight

    channel.bind 'changed_state', (data) ->
      $("[data-behavior=#{channel.name}_state]").text(data.message)

$ ->
  new Deployment
