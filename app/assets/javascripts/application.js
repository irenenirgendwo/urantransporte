// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require leaflet
//= require bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require moment/de

function beobachtung_toleranz_tage(){          
  $("#toleranz_tage").change(function() {
    var beobachtung_id, tage;
    beobachtung_id = $("#beobachtung_id").val();
    tage = $("#toleranz_tage").val();
    jQuery.get("/beobachtungen/set_toleranz_tage/" + beobachtung_id + "/" + tage, function(data) {
      return $("#show_transportabschnitt_panel").html(data);
    });
    return false;
  });
}


function verkehrsmittel_wahl(){
  $(".beobachtung_lkw").hide();

  $(".beobachtung_zug").hide();

  $(".beobachtung_schiff").hide();

  $("#beobachtung_verkehrstraeger").change(function() {
    var verkehrsmittel;
    verkehrsmittel = $('#beobachtung_verkehrstraeger option:selected').text();
    switch (verkehrsmittel) {
      case "LKW":
        $(".beobachtung_lkw").show();
        $('.beobachtung_zug').hide();
        return $('.beobachtung_schiff').hide();
      case "Zug":
        $(".beobachtung_lkw").hide();
        $('.beobachtung_zug').show();
        return $('.beobachtung_schiff').hide();
      case "Schiff":
        $(".beobachtung_lkw").hide();
        $(".beobachtung_zug").hide();
        return $(".beobachtung_schiff").show();
      default:
        $(".beobachtung_lkw").hide();
        $(".beobachtung_zug").hide();
        return $(".beobachtung_schiff").hide();
    }
  });
}
