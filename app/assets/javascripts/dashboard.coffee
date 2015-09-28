#$ ->
#  setTimeout (->
#    source = new EventSource('/status_updates/pumps')
#    source.addEventListener 'pump_status_update', (e) ->
#      # Get the status update into JSON format. For some reason we need to parse it twice.
#      status = JSON.parse(JSON.parse(e.data))
#      # Figure out the unique ID of the status update row.
#      row_id = 'pump-status-' + status.device_id + '-' + status.pump_id
#      # Build the row's HTML.
#      html = """
#<tr id="#{row_id}">
#  <td>#{status.device_id}</td>
#  <td>#{status.pump_id}</td>
#  <td>#{status.state}</td>
#  <td>#{status.stop_time}</td>
#  <td>#{status.speed}</td>
#</tr>
#      """
#
#      # If the Pump has already sent an update before, remove the old update.
#      if $("##{row_id}").length
#        $("##{row_id}").remove()
#
#      # Finally, add the new row.
#      $('#pump_statuses_dashboard').append($(html))
#      return
#    return
#  ), 1
#  return