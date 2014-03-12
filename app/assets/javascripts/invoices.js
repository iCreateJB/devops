$('#del-confirmation').bind('blur keyup', function(){
  if ($('#del-confirmation').val().match(/delete/i) != null){
    $('#delete').show()
  }else{
    $('#delete').hide()
  }
})

function getInvoices(){
  var clientId     = $('#client_id').val();
  $.ajax({
    url: '/c/'+clientId,
    type: 'GET',
    data: { },
    success: function(result){}
  });
}

function deleteClient(){
  var clientId     = $('#clientId').val();
  var customer_key = $('#customer_key').val();
  $.ajax({
    url: '/client/'+clientId,
    type: 'DELETE',
    data: { customer_key: customer_key },
    success: function(result) {
      window.location.reload();
    }
  });
}
