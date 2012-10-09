/*
JavaScript for the demo: Recreating the Nikebetterworld.com Parallax Demo
Demo: Recreating the Nikebetterworld.com Parallax Demo
Author: Ian Lunn
Author URL: http://www.ianlunn.co.uk/
Demo URL: http://www.ianlunn.co.uk/demos/recreate-nikebetterworld-parallax/
Tutorial URL: http://www.ianlunn.co.uk/blog/code-tutorials/recreate-nikebetterworld-parallax/

License: http://creativecommons.org/licenses/by-sa/3.0/ (Attribution Share Alike). Please attribute work to Ian Lunn simply by leaving these comments in the source code or if you'd prefer, place a link on your website to http://www.ianlunn.co.uk/.

Dual licensed under the MIT and GPL licenses:
http://www.opensource.org/licenses/mit-license.php
http://www.gnu.org/licenses/gpl.html
*/

$(document).ready(function() { //when the document is ready...


	//save selectors as variables to increase performance
	var $window = $(window);
	var $firstBG = $('#intro');
	var $secondBG = $('#second');
	var $thirdBG = $('#third');
	var $fourthBG = $('#fourth');
	var $fifthBG = $('#fifth');
	var $sixthBG = $('#sixth');
	var $seventhBG = $('#seventh');
	var $eighthBG = $('#eighth');
	var $ninthBG = $('#ninth');
	var $tenthBG = $('#tenth');			
	var inner_image = $(".home_box .bg1");
	var inner_image2 = $(".home_box .bg2");
	var inner_image3 = $(".home_box .bg3");	
	
	var windowHeight = $window.height(); //get the height of the window
	
	//apply the class "inview" to a section that is in the viewport
	$('#intro, #second, #third, #fourth, #fifth, #sixth, #seventh, #eighth, #ninth, #tenth').bind('inview', function (event, visible) {
			if (visible == true) {
			$(this).addClass("inview");
			} else {
			$(this).removeClass("inview");
			}
		});
	
			
	//function that places the navigation in the center of the window
	function RepositionNav(){
		var windowHeight = $window.height(); //get the height of the window
		var navHeight = $('#nav').height() / 2;
		var windowCenter = (windowHeight / 2); 
		var newtop = windowCenter - navHeight;
		$('#nav').css({"top": newtop}); //set the new top position of the navigation list
	}
	
	//function that is called for every pixel the user scrolls. Determines the position of the background
	/*arguments: 
		x = horizontal position of background
		windowHeight = height of the viewport
		pos = position of the scrollbar
		adjuster = adjust the position of the background
		inertia = how fast the background moves in relation to scrolling
	*/
	function newPos(x, windowHeight, pos, adjuster, inertia){
		return x + "% " + (-((windowHeight + pos) - adjuster) * inertia)  + "px";
	}
	
	//function to be called whenever the window is scrolled or resized
	function Move(){ 
		var pos = $window.scrollTop(); //position of the scrollbar

		//if the first section is in view...
		if($firstBG.hasClass("inview")){
			//call the newPos function and change the background position
			$firstBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 700, 0.1)}); 
			inner_image.css({'backgroundPosition': newPos(50, windowHeight, pos, 1400, 1.4)});
			
		}
		
		//if the second section is in view...
		if($secondBG.hasClass("inview")){
			//call the newPos function and change the background position
			$secondBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 3000, 0.3)});
			//call the newPos function and change the secnond background position
			inner_image.css({'backgroundPosition': newPos(50, windowHeight, pos, 3000, 0.6)});

			
		}
		
		//if the third section is in view...
		if($thirdBG.hasClass("inview")){
			//call the newPos function and change the background position
      $thirdBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 600, 0.3)});
      inner_image.css({'backgroundPosition': newPos(50, windowHeight, pos, 1700, 1.4)});
		}
		
		//if the fourth section is in view...
		if($fourthBG.hasClass("inview")){
			$fourthBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 2340, 0.2)});
			inner_image.css({'backgroundPosition': newPos(50, windowHeight, pos, 4400, 0.1)});
		}
		//if the fifth section is in view...
    if($fifthBG.hasClass("inview")){
    //  $fifthBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 4050, 1.7)});
		}
		//if the sixth section is in view...
		if($sixthBG.hasClass("inview")){
			$sixthBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 4200, 0.2)});
		}	
		//if the seventh section is in view...
		if($seventhBG.hasClass("inview")){
		  // $seventhBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 5650, 1.2)});
		}									
		//if the eighth section is in view...
		if($eighthBG.hasClass("inview")){
			$eighthBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 6600, 0.2)});
		}		
		//if the ninth section is in view...
		if($ninthBG.hasClass("inview")){
		  // $ninthBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 7250, 1.2)});
		}				
		//if the tenth section is in view...
		if($tenthBG.hasClass("inview")){
			$tenthBG.css({'backgroundPosition': newPos(50, windowHeight, pos, 7250, 0.2)});
		}				
		
			
		$('#pixels').html(pos); //display the number of pixels scrolled at the bottom of the page
	}
		
	Move();
	RepositionNav(); //Reposition the Navigation to center it in the window when the script loads
	
	$window.resize(function(){ //if the user resizes the window...
		Move(); //move the background images in relation to the movement of the scrollbar
		RepositionNav(); //reposition the navigation list so it remains vertically central
	});		
	
	$window.bind('scroll', function(){ //when the user is scrolling...
		Move(); //move the background images in relation to the movement of the scrollbar
	});
	
});