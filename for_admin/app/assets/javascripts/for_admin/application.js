//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require refugee_manager
//= require ../for_admin
//= require_tree .

/*global $, ForAdmin */

// コントローラー名からオブジェクトを取得してフックを実行する
// @see http://qiita.com/naoty_k/items/d490b456e0f385942be8
$(function () {
  var
    $body = $('body'),
    controller = $body.data('controller').replace(/\//g, '_'),
    action = $body.data('action'),
    activeController = ForAdmin[controller];

  if (activeController !== undefined) {
    if ($.isFunction(activeController[action])) {
      activeController[action]();
    }
  }
});
