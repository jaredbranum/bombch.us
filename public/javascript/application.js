$(document).ready(function(){
  Bombchus.init();
});

var Bombchus = {
  init: function(){
    Bombchus.bindEventHandlers();
  },
  bindEventHandlers: function(event){
    var btn = $('#shorten_button');
    var txtbox = $('#url_textbox');
    btn.click(Bombchus.generateShortUrl);
    txtbox.keydown(function(e){
      if ( e.keyCode == 13 ){ // Enter key
        Bombchus.generateShortUrl();
      }
    });
    txtbox.one('focus', function(){
      txtbox.val("");
      txtbox.css('color', '#000');
    });
  },
  generateShortUrl: function(){
    var url_to_shorten = $('#url_textbox').val();
    if ( !(/^[\w]+:\/\//).test(url_to_shorten) ){
      if ( (/^www\./).test(url_to_shorten) ){
        url_to_shorten = 'http://' + url_to_shorten;
      } else {
        url_to_shorten = 'http://www.' + url_to_shorten;
      }
      $('#url_textbox').val(url_to_shorten);
    }
    $.ajax({
      type: 'POST',
      url: '/shorten/new/',
      data: { "url": url_to_shorten },
      success: function(res){
        Bombchus.displayShortUrl(res.url);
      },
      error: function(res){
        $('body').append(res.responseText);
      },
      dataType: 'json'
    });
  },
  displayShortUrl: function(sh_url){
    var out = $('#output');
    out.html('<a href="' + sh_url + '">' + sh_url + '</a>');
    out.fadeIn('fast');
  }
};