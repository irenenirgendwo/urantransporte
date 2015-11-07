# Bei einer Routenwahl werden automatisch die Start- und Endorte 
# des Transportabschnitts im Formular gesetzt.
# Die anderen Moeglichkeiten zur Eingabe des Ortes werden deaktiviert.
#
# Das Herausbekommen der Orte funktioniert mit einem AJAX-Call 
# ueber routen/route_id/get_end_orte
# Bei Auswahl von Unbekannt werden alle Felder geleert

ready = ->
  $("#transportabschnitt_route_id").change ->
    if $('#transportabschnitt_route_id option:selected').text() == "Unbekannt"
      $("#start_ort_eingabe").prop("disabled",false)
      $("#start_ort_anlage").prop("disabled",false)
      $("#end_ort_eingabe").prop("disabled",false)
      $("#end_ort_anlage").prop("disabled",false)
      $("#transportabschnitt_start_ort").val("")
      $("#transportabschnitt_end_ort").val("")
      $("#start_ort_ident").val("")
      $("#end_ort_ident").val("")
    else
      route_id = $('#transportabschnitt_route_id option:selected').val()
      get_orte_url = "/routen/" + route_id + "/get_end_orte" 
      $.ajax(url: get_orte_url).done (json) ->
        #Start-Ort
        start_ort_id = json.start_ort
        $("#start_ort_ident").val(start_ort_id)
        start_ort_name = json.start_ort_name
        $("#transportabschnitt_start_ort").val(start_ort_name)
        $("#start_ort_eingabe").prop("disabled",true)
        $("#start_ort_anlage").prop("disabled",true)
        # End-Ort
        $("#end_ort_ident").val(json.end_ort)
        $("#transportabschnitt_end_ort").val(json.end_ort_name)
        $("#end_ort_eingabe").prop("disabled",true)
        $("#end_ort_anlage").prop("disabled",true)
    end
  
$(document).ready(ready)
$(document).on('page:load', ready)
