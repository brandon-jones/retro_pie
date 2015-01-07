# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#scrape_data").on "click", scrapeData

scrapeData = (event) ->
  event.stopPropagation()
  $("#scrape-info").html('getting information')
  if $("#item_amazon_url").val().length > 0
    $.post '/scrape_data',
      item_amazon_url: $("#item_amazon_url").val()
      title_css: $("#item_title_css").val()
      description_css: $("#item_description_css").val()
      image_url_css: $("#item_image_url_css").val()
      price_css: $("#item_price_css").val()
      (data) -> 
        $("#item_title").val(data.title)
        $("#item_description").val(data.description)
        $("#item_image_url").val(data.image_url)
        $("#item_price").val(data.price)
        $("#scrape-info").html(data.error)
  else
    $("#scrape-info").html('no url info')