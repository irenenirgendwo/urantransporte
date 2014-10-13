# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "ready page:change", ->
  $(".beobachtung_lkw").hide()
  $(".beobachtung_zug").hide()
  $(".beobachtung_schiff").hide()
  $("#beobachtung_verkehrstraeger").change ->
    verkehrsmittel = $('#beobachtung_verkehrstraeger option:selected').text()
    switch verkehrsmittel
      when "LKW"
        $(".beobachtung_lkw").show()
        $('.beobachtung_zug').hide()
        $('.beobachtung_schiff').hide()
      when "Zug"
        $(".beobachtung_lkw").hide()
        $('.beobachtung_zug').show()
        $('.beobachtung_schiff').hide()
      when "Schiff"
        $(".beobachtung_lkw").hide()
        $(".beobachtung_zug").hide()
        $(".beobachtung_schiff").show()
      else
        $(".beobachtung_lkw").hide()
        $(".beobachtung_zug").hide()
        $(".beobachtung_schiff").hide()
