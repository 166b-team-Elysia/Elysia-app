$(document).on('change', '#cart_product_number', function() {
  let form = $("#form-for-" + $(this).attr("data_id"))
  console.log("#form-for-" + $(this).attr("data_id"))
  form.submit();
});


$(document).on('click','.choose-product',function() {
  updateIds();
});

function updateIds() {   
  var allVals = [];
  var sum = 0;    
  $('input:checked').each(function() {
    sum += parseFloat($(this).attr("data"));
    allVals.push($(this).val());
  })
  $('.total-place').html("<h1>Total: "+ formatMoney(sum) + "</h1>")
  $('#order_product_ids').val(allVals)
}

$(document).on('click','.submit-order',function() {
  if ($('input:checked').length === 0) {
    alert("You must select at least one item !")
  } else {
    $('#new_order')[0].submit();
  }
});
function formatMoney(number) {
  return number.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
}