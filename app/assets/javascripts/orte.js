function find_ort_in_map(){
  name = $('#ortname').val()
  plz = $('#plz').val()        
  $.post('/orte/search_in_map', {
             ortname: name,
             plz: plz
        });
}
