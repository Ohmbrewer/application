## Riffing on the example found at http://www.benkirane.ch/ajax-bootstrap-modals-rails
#$ ->
#  $.rails.allowAction = (link) ->
#    return true unless link.data('confirm')
#    $.rails.showConfirmDialog(link)
#    false
#
#  $.rails.confirmed = (link) ->
#    link.removeAttr('data-confirm')
#    link.trigger('click.rails') unless link.is('form')
#    link.trigger('submit.rails') if link.is('form')
#
#  $.rails.showConfirmDialog = (link) ->
#    message = link.data 'confirm'
#    confirm_id = link.data 'for'
#    html = """
#           <div class="modal fade" id="confirmationDialog-#{confirm_id}">
#             <div class="modal-dialog">
#               <div class="modal-content">
#                 <div class="modal-header navbar-inverse">
#                   <button class="btn btn-sm btn-danger glyphicon glyphicon-remove" data-dismiss="modal" />
#                   <h4><i class="glyphicon glyphicon-trash"></i>  #{message}</h4>
#                 </div>
#                 <div class="modal-footer">
#                   <a data-dismiss="modal" class="btn btn-primary">I dunno...</a>
#                   <a data-dismiss="modal" class="btn btn-danger confirm">Yep, really sure</a>
#                 </div>
#               </div>
#             </div>
#           </div>
#           """
#    $(html).modal()
#    $('#confirmationDialog-' + confirm_id + ' .confirm').on 'click', -> $.rails.confirmed(link)
