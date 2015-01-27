# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $("#faq-search").on "keyup", search

search = ->
  $.get '/faqs',
      question: $('#faq-search').val()
      (data) -> 
        $('#faq-section').html(data)