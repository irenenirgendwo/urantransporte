function set_aehnliche_transporte_options(){ 
  $("#toleranz_tage").change(function() {save_transporte_options();});
  $("#start").change(function() {save_transporte_options();});
  $("#ziel").change(function() {save_transporte_options();});
}


function save_transporte_options(){
  var transport_id, tage, start, ziel;
  transport_id = $("#transport_id").val();
  tage = $("#toleranz_tage").val();
  start = $("#start").prop('checked');
  ziel = $("#ziel").prop('checked');
  alert("start" +start + "/" + ziel)
  jQuery.get("/transporte/set_aehnliche_transporte_options/" + transport_id + "/" 
              + tage + "/" +start + "/" + ziel, function(data) {
      return $("#show_aehnliche_panel").html(data);
  });
  return false;
}


