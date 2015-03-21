var showShippingInfo;

$(function() {
  return $("#select-delivery-type").on("change", showShippingInfo);
});

showShippingInfo = function(event) {
  if ($("#select-delivery-type").val() === 'delivery') {
    $('#shipping').show(300, 'linear');
  } else {
    $('#shipping').hide(300, 'linear');
  }
};