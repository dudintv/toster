App = window.App || {}

App.utils =
  render: (template, data) ->
    # если пришел НЕ JSON то надо его сделать
    data = $.parseJSON(data) unless typeof data == 'object'
    JST["templates/#{template}"](data)
  fa: (name, text="") ->
    JST["shared/fa"](icon: name, text: text)
