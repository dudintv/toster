//= require turbolinks
//= require js-routes
//= require jquery3
//= require rails-ujs
//= require jquery.remotipart
//= require popper
//= require bootstrap-sprockets
//= require cocoon
//= require_tree .

// FLASH MESSAGES:
var autohide_flash_messages = function(){
  setTimeout(function(){ $('#flash-messages .container').fadeOut(1000); }, 1000);
};

var set_notice = function(message) {
  $('#flash-messages').html("<div class='container'><div class='alert alert-success'>" + message + "<div></div>");
  autohide_flash_messages();
};

var set_alert = function(message) {
  $('#flash-messages').html("<div class='container'><div class='alert alert-danger'>" + message + "<div></div>");
  autohide_flash_messages();
};
// :FLASH MESSAGES
