# パスワード保護のチェック状態に合わせて
# パスワード欄の表示を切り替える処理
toggle_password_display = ->
  $password_protected = $('#refugee_password_protected')
  $password = $('.refugee-password')

  # パスワード保護のチェック状態に合わせて
  # パスワード欄の表示を切り替える
  # 関数を返すようにし、アニメーションのスピードを変更できるようにする
  # speed: アニメーションのスピード。undefined ならばアニメーションなし
  update_password_display = (speed = undefined) ->
    ->
      if $password_protected.prop('checked')
        $password.show(speed)
      else
        $password.hide(speed)

  # チェック状態が変化するときは、アニメーションを付ける
  $password_protected.change(update_password_display('fast'))
  # 初期状態ではアニメーションなし
  (update_password_display())()

class ProfilePasswordController
  edit: toggle_password_display
  update: toggle_password_display

this.RefugeeManager.profile_password = new ProfilePasswordController
