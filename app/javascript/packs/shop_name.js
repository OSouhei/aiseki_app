$(document).on('turbolinks:load', function(){
  $(document).on('keyup', '#room_shop_name', function(e){
    e.preventDefault();
    var input = $.trim($(this).val());
    $.ajax({
      url: '/rooms/search_shop',
      type: 'GET',
      data: ('keyword=' + input),
      processData: false,
      contentType: false,
      dataType: 'json'
    })
    .done(function(data){
      $('#result').find('li').remove();
      $(data).each(function(i, shop){
        $('#result').append('<li>' + shop + '</li>');
      });
    })
  });
  $(".shop-suggest").on("click", function(e){
    e.preventDefault();
    console.log("foobar!!!")
    // $("#room_shop_name").value = $(this).text
  });
});
