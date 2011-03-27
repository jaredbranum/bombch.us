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
      if ( e.keyCode == 13 ){
        Bombchus.generateShortUrl();
      }
    });
    txtbox.keypress(function(e){
      txtbox.css('color', '#000');
    });
  },
  generateShortUrl: function(){
    var url_to_shorten = $('#url_textbox').val();
    if ( !url_to_shorten.test(/^[^:]+:\/\//) ){
      if ( url_to_shorten.test(/^www\./) ){
        url_to_shorten = 'http://' + url_to_shorten;
      } else {
        url_to_shorten = 'http://www.' + url_to_shorten;
      }
      $('#url_textbox').val(url_to_shorten);
    }
    $.ajax({
      type: 'POST',
      url: '/api/shorten/new/',
      data:
      { 
        "long_url": url_to_shorten
      },
      success: function(res){
        Bombchus.displayShortUrl(res.short_url);
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