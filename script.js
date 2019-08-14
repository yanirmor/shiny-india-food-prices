$(document).on("shiny:sessioninitialized", function(event) {
  
  "use strict";
  
  // screen width
  Shiny.setInputValue("screen_width", window.innerWidth);
  
  $(window).on("resize", function() { 
    Shiny.setInputValue("screen_width", window.innerWidth);
  });
  
  // licenses tooltip

	$("#licenses > span").hover(
		function() { $("#licenses > div").fadeIn(); },
		function() { $("#licenses > div").fadeOut(); }
	);
	
  // privacy notice acknowledge

  Shiny.addCustomMessageHandler("privacyNoticeOk", function(message) {
    $("#privacy_notice").slideUp();
  });
	
	// analytics events

	$("#my_email").click(function() { _paq.push(['trackEvent', 'Contact Form', 'Mailto', 'Mailto']); } );

	$("#header_buttons a[href='https://www.yanirmor.com'").click(function() { _paq.push(['trackEvent', 'Header Buttons', 'Click', 'Website']); } );
	$("#header_buttons a[href='https://github.com/yanirmor/shiny-india-food-prices'").click(function() { _paq.push(['trackEvent', 'Header Buttons', 'Click', 'GitHub']); } );
	
	Shiny.addCustomMessageHandler("matomoEvent", function(message) {
	  _paq.push(['trackEvent', message[0], message[1], message[2]]);
	});
  
});
