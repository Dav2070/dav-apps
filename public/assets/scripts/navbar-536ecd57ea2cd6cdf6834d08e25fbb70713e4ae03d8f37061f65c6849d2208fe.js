function navbarCollapse(){$("#mainNav").offset().top>100?$("#mainNav").addClass("acrylic light shadow"):$("#mainNav").removeClass("acrylic light shadow")}function onSizeChange(){$(".navbar-collapse").collapse("hide"),window.innerWidth>575?$("#navbar-list").removeClass("acrylic light shadow"):$("#navbar-list").addClass("acrylic light shadow")}$(function(){navbarCollapse(),onSizeChange(),$(window).scroll(navbarCollapse),$(window).on("resize",onSizeChange)});