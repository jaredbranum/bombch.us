$(document).ready(function(){
  Bombchus.init();
});

var Bombchus = {
  init: function(){
    Bombchus.bindEventHandlers();
  },
  enabled: true,
  validUrl: /[a-zA-Z]+:\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/,
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
    if ( !Bombchus.enabled ){
      return;
    }
    var url_to_shorten = $('#url_textbox').val();
    if ( !Bombchus.validUrl.test(url_to_shorten) ){
      url_to_shorten = 'http://' + url_to_shorten;
      if ( !Bombchus.validUrl.test(url_to_shorten) ){
        return;
      }
    }
    $('#url_textbox').val(url_to_shorten);
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
    Bombchus.enabled = false;
    $('#shorten_button').css({
      backgroundColor: '#81838E',
      color: '#CCC394'
    });
  },
  displayShortUrl: function(sh_url){
    var out = $('#output');
    out.html('<a href="' + sh_url + '">' + sh_url + '</a>');
    out.fadeIn('fast');
  }
};