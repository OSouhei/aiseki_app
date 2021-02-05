$(function() {
  const input = $('.profile-image-input');
  input.on('input', function() {
    const file = $(this).prop('files')[0];
    $('.filename').text("添付ファイル：" + file.name);
  });
})
