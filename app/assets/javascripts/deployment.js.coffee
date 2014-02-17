class Deployment
  constructor: ->
    $('[data-behavior=real_time_logs]').each @colorize
    $('[data-behavior=real_time_logs]').each @init_pusher_for

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

$ ->
  new Deployment
