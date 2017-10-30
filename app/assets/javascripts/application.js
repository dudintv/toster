// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks
//= require jquery3
//= require rails-ujs
// require jquery-ujs
//= require jquery.remotipart
//= require popper
//= require bootstrap-sprockets
//= require cocoon
//= require_tree .

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
