function setup_datetimepicker(name){ 
  $(name).datetimepicker({
    language: 'de'
  });
  $(name).on("dp.change",function (e) {
    $(name).data("DateTimePicker").setMinDate(e.date);
  });
}
