//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require refugee_manager
//= require_tree .
//= require turbolinks

/*global $, ForAdmin */

// コントローラー名からオブジェクトを取得してフックを実行する
// @see http://qiita.com/naoty_k/items/d490b456e0f385942be8
$(function () {
  var
    $body = $('body'),
    controller = $body.data('controller').replace(/\//, '_'),
    action = $body.data('action'),
    activeController = ForAdmin[controller];

  if (activeController !== undefined) {
    if ($.isFunction(activeController[action])) {
      activeController[action]();
    }
  }
});
