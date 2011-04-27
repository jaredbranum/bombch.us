$(document).ready(function(){
  Bombchus.init();
});

var Bombchus = {
  init: function(){
    Bombchus.bindEventHandlers();
  },
  enabled: false,
  validUrl: /[a-zA-Z][-+.a-zA-Z\d]*:\/\//,
  bindEventHandlers: function(event){
    var btn = $('#shorten_button');
    var txtbox = $('#url_textbox');
    btn.click(Bombchus.generateShortUrl);
    txtbox.keydown(function(e){
      if ( e.keyCode == 13 ){ // Enter key
        Bombchus.enabled = true;
        Bombchus.generateShortUrl();
        $(this).unbind(e);
      }
    });
    txtbox.one('focus', function(){
      Bombchus.enabled = true;
      txtbox.val("").css('color', '#000');
    });
  },
  generateShortUrl: function(){
    if ( !Bombchus.enabled ){
      Bombchus.displayErrorMessage("Please enter a URL to shorten.");
      return;
    }
    var urlToShorten = $('#url_textbox').val();
    if ( !Bombchus.validUrl.test(urlToShorten) ){
      urlToShorten = "http://" + urlToShorten;
    }
    $('#url_textbox').val(urlToShorten);
    $.ajax({
      type: 'POST',
      url: '/shorten/new/',
      data: { url : urlToShorten },
      success: function(res){
        Bombchus.enabled = false;
        Bombchus.displayShortUrl(res.url, res.clicks);
      },
      error: function(res){
        Bombchus.displayErrorMessage(res.responseText);
      },
      dataType: 'json'
    });
    $('#shorten_button').css({
      backgroundColor: '#81838E',
      color: '#CCC394'
    });
  },
  displayShortUrl: function(shortUrl,count){
    $('#output')
      .html($("<a></a>").attr('href', shortUrl).text(shortUrl))
      .append("this link has been clicked " 
        + count + " time" + (count != 1 ? "s" : ""))
      .fadeIn('fast');    
  },
  displayErrorMessage: function(msg){
    $('#output')
      .html($("<span></span>").addClass("error").text(msg))
      .fadeIn('fast');
  }
};