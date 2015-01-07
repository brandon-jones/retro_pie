# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#order_delivery_type").on "change", scrapeData

  $(".price-changer").on "change", updateQuantity

scrapeData = (event) ->
  if $("#order_delivery_type").val() =='delivery'
    $('#shipping').show(300)
    $('#order_shipping_price').val('$10')
    $('.total')[0].text = "test" + $('.total')[0].text
  else
    $('#order_shipping_price').val('$0')
    $('#shipping').hide(300)
  return

updateQuantity = (event) ->
  total_price = 90
  $(".item-row").each (element) ->
    if isRowActive(this)
      quantity = getQuantity(this)
      price = getPrice(this, quantity)
      total_price =  parseInt(total_price) + parseInt(price)
    total_price = total_price + parseInt($('#order_shipping_price').val().replace('$',''))
  $('.total').text("$"+total_price)


getPrice = (row, quantity) ->
  if row.children[3].innerText == "included"
    if quantity > 1
      return row.children[3].children[0].value
    else
      return 0
  else
    return quantity * row.children[3].children[0].value

getQuantity = (row) ->
  row.children[4].children[0].value

isRowActive = (row) ->
  if row.children[0].children[0].checked == true
    return true
  else
    return false