passwordController = ->
  passwordProtected = false

  $form = $('form')
  $passwordProtected = $('#refugee_password_protected')
  $password = $('.refugee-password')
  $refugeePassword = $('#refugee_password')
  $refugeePasswordConfirmation = $('#refugee_password_confirmation')
  $passwordFields = $('#refugee_password, #refugee_password_confirmation')
  $passwordConfirmationError = $('#password-confirmation-error small')

  # パスワード保護のチェック状態に合わせて
  # パスワード欄の表示を切り替える
  # 関数を返すようにし、アニメーションのスピードを変更できるようにする
  # speed: アニメーションのスピード。undefined ならばアニメーションなし
  updatePasswordProperties = (speed = undefined) ->
    ->
      passwordProtected = $passwordProtected.prop('checked')
      if passwordProtected
        $passwordFields.attr('minlength', 4)
        $passwordFields.prop('required', true)
        $password.show(speed)
      else
        $passwordFields.removeAttr('minlength')
        $passwordFields.prop('required', false)
        $password.hide(speed)
      return

  # 送信時にパスワードを確認する
  confirmPassword = ->
    return true unless passwordProtected

    password = $refugeePassword.val()
    confirmation = $refugeePasswordConfirmation.val()
    unless confirmation == password
      $passwordConfirmationError.text('パスワードが確認欄に入力されたものと一致しません。')
      return false

  $form.submit(confirmPassword)

  # 確認エラーの文章をクリアする
  clearError = ->
    $passwordConfirmationError.text('')

  $passwordFields.focus(clearError)

  # チェック状態が変化するときは、アニメーションを付ける
  $passwordProtected.change(updatePasswordProperties('fast'))
  # 初期状態ではアニメーションなし
  (updatePasswordProperties())()

class RefugeesPasswordController
  edit: passwordController
  update: passwordController

this.ForAdmin.for_admin_refugees_password = new RefugeesPasswordController
