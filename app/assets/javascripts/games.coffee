# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->
  $("#game_players_count").change ->
    max_players = $("#settings").data('max-players')
    cur_players = @value
    i = 1
    while i <= max_players
      if i <= cur_players
        $(".player_wrapper_" + i).show()
      else
        $(".player_wrapper_" + i).hide()
        $("#player" + i).val('')
      i++
    return
