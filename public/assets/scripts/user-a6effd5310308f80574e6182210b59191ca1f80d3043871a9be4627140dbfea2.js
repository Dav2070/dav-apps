$(function(){
   $('#toggle-button').sidr();
   setMenuVisibility();

   $(window).bind('hashchange', function() {
      setMenuVisibility();
   });

   $(window).resize(function() {
      arrangeSidebar();
   });
});

function setMenuVisibility(){
   var type = window.location.hash.substr(1);
   if(type == "plans"){
      // Hide main div and show plan div
      $("#main-menu").hide();
      $("#plans-menu").show();
      $("#apps-menu").hide();
      $("#archives-menu").hide();

      $("#plans-sidebar-entry").addClass("active");
   }else if(type == "apps"){
      $("#main-menu").hide();
      $("#plans-menu").hide();
      $("#apps-menu").show();
      $("#archives-menu").hide();

      $("#apps-sidebar-entry").addClass("active");
   }else if(type == "archives"){
      $("#main-menu").hide();
      $("#plans-menu").hide();
      $("#apps-menu").hide();
      $("#archives-menu").show();

      $("#archives-sidebar-entry").addClass("active");
   }else{
      // Show main menu
      $("#main-menu").show();
      $("#plans-menu").hide();
      $("#apps-menu").hide();
      $("#archives-menu").hide();

      $("#main-sidebar-entry").addClass("active");
   }

   arrangeSidebar();
}

function arrangeSidebar(){
   var width = $(window).width();

   if(width < 992){
      // Hide all menus
      $("#sidebar-content").hide();
      $("#toggle-button").show();
   }else{
      $("#sidebar-content").show();
      $("#toggle-button").hide();
      $.sidr('close', 'sidr');
   }
}
;
