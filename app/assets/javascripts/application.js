// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require metro.js
//= require_tree .

if(document.querySelector('#birthday-calendar')) {
  setTimeout(function() {
    $("#birthday-calendar").calendar('setDate', TODAY);
  }, 10);
}

function dayClick(short, full) {
  var month = full.getMonth() + 1;
  var day = full.getDate();
  var url = "/characters/date/" + month + "/" + day;
  window.location = url;
}
