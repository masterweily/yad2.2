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

initApartmentItem = ($item) ->
  $item.find('a.archive').click (e) ->
    e.preventDefault()
    $a = $(this)
    url = $a.attr('href')
    $.post url, -> $item.fadeOut('slow',-> $(this).remove())

  $item.find('textarea.notes').each ->
    $this = $(this)
    url = $this.attr('data-url')
    save = ->
      data =
        apartment:
          notes: $this.val()
      $.post url,data

    $this.focus ->
      unless $this.editor
        $this.jqte
          change: -> save()
          blur: -> save()
      $this.editor = true


  return $item

queryId= ""
apartment_$li = (apartment) ->
    initApartmentItem $("""
      <li class="new apartment">
        <h3>#{apartment.title}</h3>
        <ul class="details">
          <li>
            <a href="#{apartment.link}" target="_blank">קישור</a>
          </li>
          <li>מחיר #{apartment.price}</li>
          <li>#{apartment.rooms} חדרים</li>
          <li>כניסה #{apartment.entry_date}</li>
          <li>קומה #{apartment.floor}</li>
          <li>עודכן לאחרונה ב #{apartment.updated_at}</li>
          <li>
            <a class="archive" href="/yad2/query/#{queryId}/apartment/#{apartment._id}/archive">תעיף לי מהעיניים</a>
          </li>
          <textarea class="notes" data-url="/yad2/query/#{queryId}/apartment/#{apartment._id}/update" name="apartment[notes]" placeholder="הערות">
            #{apartment.notes}
          </textarea>
        </ul>
      </li>
    """)

notify_audio = new Audio()
notify_audio.src = '/sounds/hihat.wav'
notify_audio.load()
notify = -> notify_audio.play()

$ ->
  $apartments_list = $('.apartments')
  $apartments_list.find('.apartment').each -> initApartmentItem $(this)

  queryId = $('.query').attr('data-id')
  socket = buildWebsoket "/yad2/crawl/#{queryId}",
    onopen: -> console.debug 'onopen',
    onclose: -> console.debug 'close',
    onmessage: (data) ->
      if data.length > 0 then notify()
      for apartment in data
        $apartments_list.prepend(apartment_$li(apartment).fadeIn('slow'))

  $('input[name="query[name]"]').change ->
    val = $(this).val()
    $('title').html(val)
    data =
      query:
        name: val
    url = $(this).attr('data-url')
    $.post url,data

  $('input[name="new-query"]').change ->
    value = $(this).val()
    if value.length > 0
      newTab "#{$(this).attr('data-url')}?#{value}"

  newTab = (url) -> window.open(url, '_blank').focus()



