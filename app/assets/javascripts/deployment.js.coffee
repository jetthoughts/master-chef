class Deployment
  constructor: ->
    $('[data-behavior=real_time_logs]').each @init_pusher_for

  init_pusher_for: (index, element) =>
    $this = $(element)
    pusher_key = $this.data('pusher-key')
    channel_name = $this.data('pusher-channel')
    pusher = new Pusher(pusher_key)
    channel = pusher.subscribe(channel_name)

    @channel_bindings(channel, $this)

  channel_bindings: (channel, $element) ->

    channel.bind 'append_log', (data) ->
      $element.append data.message
      $element.scrollTop $element.scrollHeight

$ ->
  new Deployment
