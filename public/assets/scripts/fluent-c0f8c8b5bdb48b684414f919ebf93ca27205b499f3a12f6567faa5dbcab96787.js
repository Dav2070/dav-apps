"use strict";var parallax=function(){const e=[...document.getElementsByClassName("parallax")],t=function(e){var t=e.getBoundingClientRect();if(t.top<=window.innerHeight&&t.bottom>0){const r=e.getAttribute("data-parallax-speed")?e.getAttribute("data-parallax-speed"):2;let a=t.top/window.innerHeight*t.height*-1/r+"px";e.style.backgroundPosition=`center ${a}`}};window.addEventListener("scroll",function(){e.forEach(e=>{t(e)})}),e.forEach(e=>{t(e)})};parallax();var reveal=function(){const e=[...document.getElementsByClassName("reveal")],t=function(e){var t=e.getBoundingClientRect(),r=t.width,a=t.height,n=event.clientX-t.left,o=event.clientY-t.top;if(n>-100&&n<r+100&&o>-100&&o<a+100){var l=n/r*100,i=o/a*100,s=.1;if(l>0&&l<100&&i>0&&i<100)return s=.85,e.style.borderColor="transparent",void(e.style.borderImage="radial-gradient(circle at "+l+"% "+i+"%, rgba(255,255,255,"+s+"), rgba(255,255,255,0.3) 200px) 1");n>-20&&n<r+20&&o>-20&&o<a+20?s=.65:n>-40&&n<r+40&&o>-40&&o<a+40?s=.5:n>-60&&n<r+60&&o>-60&&o<a+60?s=.35:n>-80&&n<r+80&&o>-80&&o<a+80?s=.2:n>-100&&n<r+100&&o>-100&&o<a+100&&(s=.1),e.style.borderColor="transparent",e.style.borderImage="radial-gradient(circle at "+l+"% "+i+"%, rgba(255,255,255,"+s+"), transparent 200px) 1"}else e.style.borderColor="transparent",e.style.borderImage="none"};document.addEventListener("mousemove",function(){e.forEach(e=>{t(e)})})};reveal();