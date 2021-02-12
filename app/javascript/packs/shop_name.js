$(document).on('turbolinks:load', function(){
  // 検索結果を表示
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
        $('#result').append('<li class="shop_name list-group-item">' + shop + '</li>');
      });
    })
  });
  // 検索結果をフィールドにセット
  $(document).on('click', '.shop_name', function(e){
    e.preventDefault();
    shop = $(this).text();
    $("#room_shop_name").val(shop);
    // 検索結果を空に
    $("#result").html('');
  });
});
