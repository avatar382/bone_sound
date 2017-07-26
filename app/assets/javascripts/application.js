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

// DATEPICKER

var ui_activate_datepicker = function () {
  $('#datetimepicker').datetimepicker({format: "YYYY-MM-DD"});
};

// MATERIALS CHARGE HANDLER

var charges_clear_materials_form = function() {
  $('#js-description-label').html("");
  $('#js-unit-label').html("");
  $('#js-total-label').html("");
  $('#js-description-hidden').val("");
  $('#js-amount-hidden').val("");
  $('#item-not-found').show();
};

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
};

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

// BATCH ACCOUNT FORM

var batch_accounts_bind_to_controls = function() {
  $('#js-arch-button').click(function() {
    accounts_select_dcp_college();
  });

  $('#js-arts-button').click(function() {
    accounts_select_arts_college();
  });

  $('#js-other-button').click(function() {
    accounts_select_other_college();
  });
};

var accounts_select_dcp_college = function() {
  $('#account_uf_college option:nth-child(1)').attr("selected", "selected"); 
  $('#account_uf_college option:nth-child(2)').removeAttr("selected"); 
  $('#account_uf_college option:nth-child(3)').removeAttr("selected"); 

};

var accounts_select_arts_college = function() {
  $('#account_uf_college option:nth-child(1)').removeAttr("selected"); 
  $('#account_uf_college option:nth-child(2)').attr("selected", "selected"); 
  $('#account_uf_college option:nth-child(3)').removeAttr("selected"); 
};

var accounts_select_other_college = function() {
  $('#account_uf_college option:nth-child(1)').removeAttr("selected"); 
  $('#account_uf_college option:nth-child(2)').removeAttr("selected"); 
  $('#account_uf_college option:nth-child(3)').attr("selected", "selected"); 
};

// ACCOUNT FORM

var uf_section       
var staff_section   
var external_section 

var uf_showing      
var staff_showing    
var external_showing 

var accounts_show_uf_section = function() {
  if(!uf_showing) {
    $("#js-subform").append(uf_section); 
    uf_showing = true;

    // make email address automatically fill from gatorlink
    $("#account_gatorlink_id").focusout(function() {
     accounts_fill_email_from_gatorlink_id();
    });
  }

  if(staff_showing) {
    staff_section = $("#js-staff-section").detach();
    staff_showing = false;
  }

  if(external_showing) {
    external_section = $("#js-external-section").detach();
    external_showing = false;
  }
};

var accounts_show_staff_section = function() {
  if(uf_showing) {
    uf_section = $("#js-uf-section").detach();
    uf_showing = false;
  }

  if(!staff_showing) {
    $("#js-subform").append(staff_section); 
    staff_showing = true;
  }

  if(external_showing) {
    external_section = $("#js-external-section").detach();
    external_showing = false;
  }
};

var accounts_show_external_section = function() {
  if(uf_showing) {
    uf_section = $("#js-uf-section").detach();
    uf_showing = false;
  }

  if(staff_showing) {
    staff_section = $("#js-staff-section").detach();
    staff_showing = false;
  }

  if(!external_showing) {
    $("#js-subform").append(external_section); 
    external_showing = true;
  }
};

var accounts_update_radio_from_select = function() {
  if($('#account_uf_college').val() == "College of Design, Construction, and Planning") {
    $('#js-arch-button').prop("checked", true)
  }
  else if($('#account_uf_college').val() == "College of the Arts") {
    $('#js-arts-button').prop("checked", true)
  }
  else {
    $('#js-other-button').prop("checked", true)
  }
}

var accounts_bind_to_controls = function() {
  $('#js-laser-button').click(function() {
    accounts_show_uf_section();
  });

  $('#js-internal-button').click(function() {
    accounts_show_uf_section();
  });

  $('#js-external-button').click(function() {
    accounts_show_external_section();
  });

  $('#js-staff-button').click(function() {
    accounts_show_staff_section();
  });

  $('#account_uf_college').change(function() {
    accounts_update_radio_from_select();

  });
};

var accounts_fill_email_from_gatorlink_id = function() {
  if($("#account_email").val() == "") {
    var gl_username = $("#account_gatorlink_id").val();
    $("#account_email").val(gl_username + "@ufl.edu");  
  }
};

var charges_reset_invoice_form = function() {
  $(".js-checkbox-invoice").prop("checked", false);
  $("#js-invoice-submit").prop("disabled", true);
};

var charges_enable_invoice_form = function() {
  var atLeastOneIsChecked = $('.js-checkbox-invoice:checkbox:checked').length > 0;

  if(atLeastOneIsChecked) {
    $("#js-invoice-submit").prop("disabled", false);
  }
  else {
    $("#js-invoice-submit").prop("disabled", true);
  }

}

$(document).ready(function() {
  // activate datepicker elements
  ui_activate_datepicker();

  // script to query for material details when an SKU is entered on the materials field
  charges_bind_to_controls();

  // script to switch college affiliation when lab affiliation selected
  batch_accounts_bind_to_controls();

  // script to display different areas of account form when account type selected
  accounts_bind_to_controls();

  uf_section       = $("#js-uf-section").detach();
  staff_section    = $("#js-staff-section").detach()
  external_section = $("#js-external-section").detach();
  
  uf_showing       = false;
  staff_showing    = false;
  external_showing = false;

  // auto focus on SKU field on charge page
  $("#js-material-sku").focus();

  // reset invoice form on submit
  $("#js-invoice-submit").click(function(e) {
    e.preventDefault();
    $("#js-invoice-form").submit();
    charges_reset_invoice_form();
  });

  // submit invoice form
  $(".js-checkbox-invoice").click(function(e) {
    charges_enable_invoice_form();
  });



})
