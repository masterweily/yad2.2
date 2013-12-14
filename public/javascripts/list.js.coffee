buildWebsoket = (path,options) ->
  ws = new WebSocket('ws://' + window.location.host + path)
  ws.onopen = options.onopen
  ws.onclose = options.onclose
  ws.onmessage = (msg) ->
    data = try
      JSON.parse msg.data
    catch e
      msg.data
    options.onmessage(data)
  ws

$ ->
  $apartments_list = $('.apartments')

  apartment_$li = (apartment) ->
    $ """
      <li class="new apartment">
        <h3>#{apartment.title}</h3>
        <ul class="details">
          <li>
            <a href="#{apartment.link}.">קישור</a>
          </li>
          <li>מחיר #{apartment.price}</li>
          <li>#{apartment.rooms} חדרים</li>
          <li>כניסה #{apartment.entry_date}</li>
          <li>קומה #{apartment.floor}</li>
          <li>עודכן לאחרונה ב #{apartment.last_update}</li>
        </ul>
      </li>
    """

  notify_audio = new Audio()
  notify_audio.src = '/sounds/hihat.wav'
  notify_audio.load()
  notify = -> notify_audio.play()

  queryId = $('.query').attr('data-id')
  socket = buildWebsoket "/yad2/crawl/#{queryId}",
    onopen: -> console.debug 'onopen',
    onclose: -> console.debug 'close',
    onmessage: (data) ->
      if data.length > 0 then notify()
      for apartment in data
        $apartments_list.prepend(apartment_$li(apartment).fadeIn('slow'))




