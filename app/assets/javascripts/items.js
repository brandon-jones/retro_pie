var scrapeData;

$(function() {
  return $("#scrape_data").on("click", scrapeData);
});

scrapeData = function(event) {
  event.stopPropagation();
  $("#scrape-info").html('getting information');
  if ($("#item_amazon_url").val().length > 0) {
    return $.ajax({
      type: "POST",
      url: "/scrape_data",
      data: {
        item_amazon_url: $("#item_amazon_url").val(),
        title_css: $("#item_title_css").val(),
        description_css: $("#item_description_css").val(),
        image_url_css: $("#item_image_url_css").val(),
        cost_css: $("#item_cost_css").val()
      },
      success: function(data, textStatus) {
        if (data.errors) {
          $("#scrape-info").html(data.errors);
        } else {
          $("#item_title").val(data.title);
          $("#item_description").val(data.description);
          $("#item_image_url").val(data.image_url);
          console.log(data);
          $("#item_cost").val(data.cost);
          return $("#scrape-info").html(data.error);
        }
        
      },
      error: function(data, textStatus) {
        $("#scrape-info").html('error scrapping info');
      }
    });
  } else {
    return $("#scrape-info").html('no url info');
  }
};