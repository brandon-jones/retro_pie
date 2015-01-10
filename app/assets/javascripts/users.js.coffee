# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#select-delivery-type").on "change", showShippingInfo

showShippingInfo = (event) ->
  if $("#select-delivery-type").val() =='delivery'
    $('#shipping').show(300,'linear')
  else
    $('#shipping').hide(300,'linear')
  return