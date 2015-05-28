function setup_datetimepicker(name){ 
  $(name).datetimepicker({
    language: 'de'
  });
  $(name).click(function(event){
   $(name).data("DateTimePicker").show();
});
}
