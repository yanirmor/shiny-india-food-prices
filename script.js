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
  
});
