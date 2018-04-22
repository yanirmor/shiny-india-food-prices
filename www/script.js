$(document).keyup(function(event) {
  if (
    event.keyCode == 13 &&
    (
      $("#name").is(":focus") || 
      $("#email").is(":focus") || 
      $("#subject").is(":focus") || 
      $("#message").is(":focus")
    )
  ) {
    $("#submit").click();
  }
});
