welcomeIndex = ->
  $shelterDataUpdatedAt = $('#shelter_data_updated_at')
  $numOfRefugees = $('#num_of_refugees')
  $numOfRegisteredRefugees = $('#num_of_registered_refugees')
  $numOfPresentRefugees = $('#num_of_present_refugees')

  # 避難者数の表示を更新する
  updateNumbers = (data) ->
    formatTime = (timestamp) ->
      m = timestamp.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})/)
      return '' unless m
      str = [m[1], '-', m[2], '-', m[3], ' ', m[4], ':', m[5], ':', m[6]].join('')
      str

    # 最終更新
    $shelterDataUpdatedAt.text(formatTime(data.timestamp))

    refugees = data.refugees
    # 合計世帯人数
    $numOfRefugees.text(refugees.total)
    # 登録避難者数
    $numOfRegisteredRefugees.text(refugees.registered)
    # 在室避難者数
    $numOfPresentRefugees.text(refugees.present)

  # 避難所データを取得する
  queryShelterData = ->
    $.ajax({
      url: '/shelter.json',
      dataType: 'json',
      success: updateNumbers
    })

  # 周期ハンドラを設定する
  window.setInterval(queryShelterData, 5000)

class WelcomeController
  index: welcomeIndex

this.ForAdmin.for_admin_welcome = new WelcomeController
