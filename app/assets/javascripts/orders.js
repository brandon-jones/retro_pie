var delay, rows, changeSort, showOrderDetails, fadeOutGreen, getPrice, getQuantity, isRowActive, remove_updated_classes, saveOrderEdits, updateQuantity, toggleChangedFlag;

$(document).ready(function() {
  updateFinalTotal();
  $(".price-changer").on("change", updateFinalTotal);
  $('.order-change').on("change", toggleChangedFlag);
  $('#save_order_edits').on("click", saveOrderEdits);
  $('.change_sort').on("click", changeSort);
  $('.radio-order-update').on("click", updateRadioButtons);
  $('.clear-radios').on("click", clearTbody);
  return $('.order-details').on("click", showOrderDetails);
});

clearTbody = function(e) {
  e.preventDefault();
  e.stopPropagation();
  var input = this;
  var table = input.dataset.table;
  clearRadioButtons($('.'+table));
  updateFinalTotal();
};

clearRadioButtons = function(rows) {
  $.each(rows, function( index, value ) {
    value.children[0].children[0].checked = false
  });
};

tableHasAnyChecked = function(rows) {
  $.each(rows, function( index, value ) {
    if (value.children[0].children[0].checked == true) {
      return true
    }
  });
  return false;
}

tableHasBase = function(rows) {
  var base = false;
  $.each(rows, function( index, value ) {
    if (value.dataset.base == "true") {
      base = value.children[0].children[0];
    }
  });
  return base;
};

updateRadioButtons = function(e) {
  e.stopPropagation();
  // e.preventDefault();
  var selected_radio = this;
  var table = selected_radio.id.split('_')[0];
  var rows = $('.'+table);

  if (selected_radio.checked == false) {
    var checked = tableHasAnyChecked(rows);
    if (checked == false) {
      var base = tableHasBase(rows);
      if (base) {
        base.checked = true;
      }
    }
  } else {
    var base = tableHasBase(rows);
    if (base) {
      clearRadioButtons(rows);
      selected_radio.checked = true;
    }
  }

  updateFinalTotal();
}

showOrderDetails = function(e) {
  var details_id;
  e.stopPropagation();
  e.preventDefault();
  details_id = "#" + this.getAttribute('data');
  if ($(details_id)[0].style.display === 'none') {
    return $(details_id).show(200, 'linear');
  } else {
    return $(details_id).hide(200, 'linear');
  }
};

changeSort = function(event) {
  event.stopPropagation();
  event.preventDefault();
  $('#save_order_edits').addClass('hidden');
  return $.get('/orders', {
    sort_by: this.getAttribute('data'),
    sort_order: $('#sort_order').val(),
    table_only: true
  }, function(data) {
    $('#order_table').html(data);
    $('.change_sort').on("click", changeSort);
    $('.order-details').on("click", showOrderDetails);
    return $('.order-change').on("change", toggleChangedFlag);
  });
};

updateFinalTotal = function(event) {
  var total_price;
  total_price = 0;
  $(".item-row").each(function(element) {
    var price, quantity;
    if (isRowActive(this)) {
      quantity = getQuantity(this);
      price = getPrice(this, quantity);
      total_price = total_price + price;
    }
  });
 var temp = (total_price).toLocaleString("en-USD", {style: "currency", currency: "USD", minimumFractionDigits: 2}) 
  // return $('.total').text("$" + Math.round(total_price * 100) / 100);
  return $('.total').text(temp);
};

getPrice = function(row, quantity) {
  if (row.children[3].innerText === "included") {
    if (quantity > 1) {
      return row.children[3].children[0].value;
    } else {
      return 0;
    }
  } else {
    return quantity * row.children[3].innerText.replace('$','');
  }
};

getQuantity = function(row) {
  return row.children[4].children[0].value;
};

isRowActive = function(row) {
  if (row.children[0].children[0].checked === true) {
    return true;
  } else {
    return false;
  }
};

toggleChangedFlag = function() {
  $('#order-index').addClass('unsaved-changes');
  $(this).addClass('unsaved-changes-background');
  if ($('#save_order_edits').hasClass('hidden')) {
    return $('#save_order_edits').removeClass('hidden');
  }
};

saveOrderEdits = function() {
  var changedRows;
  changedRows = [];
  $('.unsaved-changes-background').each(function(element) {
    var parentElement;
    $(this).removeClass('unsaved-changes-background');
    $(this).closest(".order-row").addClass('flash-save');
    delay(1, fadeOutGreen);
    parentElement = this.parentElement.parentElement;
    return changedRows.push([parentElement.getElementsByClassName('order_id')[0].innerHTML, parentElement.getElementsByClassName('status_id')[0].value]);
  });
  $('#save_order_edits').addClass('hidden');
  $('#order-index').removeClass('unsaved-changes');
  if (changedRows.length > 0) {
    return $.post('/orders/update', {
      changed_orders: changedRows.toString()
    }, function(data) {});
  }
};

fadeOutGreen = function() {
  return $('.flash-save').each(function(element) {
    $(this).removeClass('flash-save');
    $(this).addClass('fade-out');
    return delay(5000, remove_updated_classes);
  });
};

remove_updated_classes = function() {
  console.log('remove_updated_classes');
  return $('.fade-out').each(function(element) {
    return $(this).removeClass('fade-out');
  });
};

delay = function(ms, func) {
  return setTimeout(func, ms);
};

stripDollarSign = function(str) {
  return str.replace(/\$/g,'');
}

// ---
// generated by coffee-script 1.9.0
