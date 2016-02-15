## Based off of
## http://stackoverflow.com/questions/26289601/rails-4-1-4-custom-confirmation-alert
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
<div class="modal" id="confirmationDialog">
 <div class="modal-dialog">
   <div class="modal-content">
     <div class="modal-header navbar-inverse">
       <button class="btn btn-sm btn-danger glyphicon glyphicon-remove" data-dismiss="modal" />
       <h4><i class="glyphicon glyphicon-warning-sign"></i>  #{message}</h4>
     </div>
     <div class="modal-footer">
       <a data-dismiss="modal" class="btn btn-danger">Cancel</a>
       <a data-dismiss="modal" class="btn btn-primary confirm">Delete</a>
     </div>
   </div>
 </div>
</div>
           """
    $(html).modal()
    $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)
