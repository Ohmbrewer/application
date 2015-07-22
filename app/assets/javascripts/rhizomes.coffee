# Riffing on the example found at http://www.benkirane.ch/ajax-bootstrap-modals-rails
$ ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link)
    false

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
           <div class="modal fade" id="confirmationDialog">
             <div class="modal-dialog">
               <div class="modal-content">
                 <div class="modal-header navbar-inverse">
                   <button class="btn btn-sm btn-danger glyphicon glyphicon-remove" data-dismiss="modal" />
                   <h4><i class="glyphicon glyphicon-trash"></i>  #{message}</h4>
                 </div>
                 <div class="modal-footer">
                   <a data-dismiss="modal" class="btn btn-primary">I dunno...</a>
                   <a data-dismiss="modal" class="btn btn-danger confirm">Yep, really sure</a>
                 </div>
               </div>
             </div>
           </div>
           """
    $(html).modal('show')
    $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)
