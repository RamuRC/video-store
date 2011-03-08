jQuery(document).ready(function() {
  $('input#file_or_url_video_url').click(function(){
    $('form .video_url').removeClass('hidden');
    $('form .url_field').append('<span class="required"> *</span>');
    $('form .video_file').addClass('hidden');
    $('form .file_field span').remove();
  }),
  $('input#file_or_url_video_file').click(function(){
    $('form .video_file').removeClass('hidden');
    $('form .file_field').append('<span class="required"> *</span>');
    $('form .video_url').addClass('hidden');
    $('form .url_field span').remove();
  }),
  $('input#file_or_url_video_url').click();
});
