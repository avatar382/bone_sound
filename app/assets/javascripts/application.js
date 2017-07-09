// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-3.2.1.min
//= require rails-ujs
//= require bootstrap.min
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

var ui_activate_datepicker = function () {
  $('#datetimepicker').datetimepicker({format: "MM/DD/YYYY"});
};

// CHARGE HANDLER

var charges_clear_materials_form = function() {
  $('#js-description-label').html("");
  $('#js-unit-label').html("");
  $('#js-total-label').html("");
  $('#js-description-hidden').val("");
  $('#js-amount-hidden').val("");
  $('#item-not-found').show();
}

var charges_fill_form_with_material_data = function(obj) {
  var qty   = $('#js-material-qty').val();
  var sum   = parseFloat(Math.round((obj["price"] * qty) * 100) / 100).toFixed(2);
  var price = parseFloat(Math.round(obj["price"] * 100) / 100).toFixed(2);

  // set label values
  $('#js-description-label').html(obj["description"]);
  $('#js-unit-label').html(price);
  $('#js-total-label').html("$" + sum);

  // set hidden field values
  $('#js-description-hidden').val(qty + "x:" + " " + obj["description"]);
  $('#js-amount-hidden').val(sum);

  // hide not found
  $('#item-not-found').hide();

  // animate fields
  $('#js-description-label').fadeOut(500);
  $('#js-description-label').fadeIn(500);
  $('#js-unit-label').fadeOut(500);
  $('#js-unit-label').fadeIn(500);
  $('#js-total-label').fadeOut(500);
  $('#js-total-label').fadeIn(500);

};

var charges_get_material_via_sku = function(sku) {
  url = "../materials/" + sku + ".json";
  var qty = $("#js-material-qty").val();

  if(qty == "" || isNaN(qty)) {
    $("#js-material-qty").val(1);
  }

  $.getJSON(url, function(data) {
    charges_fill_form_with_material_data(data);
  })
  .fail(function() {
    charges_clear_materials_form();
  });
}

var charges_bind_to_controls = function() {
  $('.js-material-control').keypress(function(event) {
    if(event.keyCode == 13) {
      var sku = $("#js-material-sku").val();
      charges_get_material_via_sku(sku);

      event.stopPropagation();
      event.preventDefault();
    }
  });
};

$(document).ready(function() {
  // activate datepicker elements
  ui_activate_datepicker();

  // script to query for material details when an SKU is entered on the materials field
  charges_bind_to_controls();
})
