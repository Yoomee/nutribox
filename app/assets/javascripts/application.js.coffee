# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.

#= require jquery
#= require jquery_ujs
#= require jquery-migrate
#= require ym_core
#= require ym_cms
#= require redactor
#= require bootstrap
#= require jquery.cycle
#= require jquery.smooth-scroll


$(document).ready ->
  $('.homepage-messages').cycle
    fx: 'fade',
    speed: 'slow',
    timeout: 4000,
    easing: 'easeOutQuint',
    # pager: '.cycle_nav',
    # next: '.cycle_next',
    # prev: '.cycle_prev'
