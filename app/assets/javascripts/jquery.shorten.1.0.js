jQuery.fn.shorten = function(settings) {
  var config = {
    showChars : 100,
    ellipsesText : "...",
    moreText : "more",
    lessText : "less"
  };

  if (settings) {
    $.extend(config, settings);
  }

  $('.morelink').live('click', function() {
    var $this = $(this);
    if ($this.hasClass('less')) {
      $this.removeClass('less');
      $this.html(config.moreText);
    } else {
      $this.addClass('less');
      $this.html(config.lessText);
    }
    $this.parent().prev().toggle();
    $this.prev().toggle();
    return false;
  });

  return this.each(function() {
    var $this = $(this);
 
    var content = $this.html();
    var leng_string = $this.html().split("<br>")[0] +'<br>' + $this.html().split("<br>")[1]
    if (content.length > leng_string.length) {
      var c = content.substr(0, leng_string.length);
      var h = content.substr(leng_string.length , content.length - leng_string.length);
      var html = c + '<span class="moreellipses">' + config.ellipsesText + '&nbsp;</span><span class="morecontent"><span>' + h + '</span>&nbsp;&nbsp;<a href="javascript://nop/" class="morelink">' + config.moreText + '</a></span>';
      $this.html(html);
      $(".morecontent span").hide();
    }
  });
};