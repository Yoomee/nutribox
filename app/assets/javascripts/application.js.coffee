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
#= require twitter


$(document).ready ->
  $('.homepage-messages').cycle
    fx: 'fade',
    speed: 'slow',
    timeout: 4000,
    easing: 'easeOutQuint',
    # pager: '.cycle_nav',
    # next: '.cycle_next',
    # prev: '.cycle_prev'
  TwitterLinks.init()

TwitterLinks =
  init:() ->
    if $('a.follow-twitter').length > 0
      $('a.follow-twitter').on 'click', (event) ->
        event.preventDefault()        
        url = this.href;
        width = 550
        height = 470
        left = (screen.width / 2) - (width / 2)
        top = (screen.height / 2) - (height / 2)
        window.open(url, 'Follow on Twitter', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=#{width}, height=#{height}, top=#{top}, left=#{left}")

