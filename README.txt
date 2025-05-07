//<DATA MOSH LAB v0.0.1a>//
/* RGB and HSB sorts with masking and a few filter options
 written in processing 4.x, download here: https://processing.org/

1- installation and setup
	download and install processing (v4.3 or newer)
	open sketch (double click on any ".pde" file within the sketch folder, they should all open at once since they are part of the same project)
	in the toolbar, go to sketch-> import libraries-> manage libraries-> search and download G4P library (by Peter Lager, v4.3.11 or newer, the entire GUI is built on this library)
	press run on the sketch (the big ol' play button)

2- running the program
 all photos should be in *.jpg format and have to be dropped in the "data" folder. Saved frames will be stored in the "output" folder.

---desde acá hay que reescribir 
GENERIC GUI, WHAT BUTTONS DO (PREV, NEXT, UNDO, SAVE, RESET)
 key bindings: --> DEPRECATED
	t: toggles text
	d: toggles save frame --> will start to number files up to 4 digits, after the 999nth file it will start overwriting (watch out, it goes fast. lower the frameRate value for a more controlled looping)
	s: save current frame only --> will keep original file name?
	l: toggles loop
	r: reset canvas
	a: sorting
	f: filtering
	m: next photo
	n: prev photo

  /* SORTING --- oooh boy, here we go...
WHAT CHECKBOXES DO
HOW TO CHAIN MANUALLY
MASKING
   
   M = masked, will sort pixels based on an input mask, an image with only black and white pixels (more on this later)
   I = inverted, will use the mask the other way around (this will all make sense... eventually)
   V = vertical, self explanatory
   H = horizontal, ^
   T = threshold, the amount of pixels to sort at a time
   
   every hsb/rgb sort has 3 flag inputs for each of the three parameters (hue, sat and brightness, red, green and blue respectively)
   ALL RANGES GO FROM 0-255, THIS APPLIES TO BOTH HSB AND RGB!
   all parameters expect integer numbers, and also, be careful with masks and picture sizes, if u get outside the canvas it will clamp all values to 0 (no biggie, it just does nothing lol)
   
   ALLRIGHT 1ST THE SORTS
   --- 1 ---
   no mask, has threshold of brightness
   --- HSB - 1 ---
   hsbV, hsbIV, hsbH, hsbIH
   --- RGB - 1 ---
   rgbV, rgbIV, rgbH, rgbIH
   
   example:
   imgSorted = hsbV(imgSorted, 50, 250, true, true, true);
   
   this means we are sorting vertically, from 50 to 250 brightness, and all 3 parameters will be sorted
   the order of the parameters if always the same for each group, both hsb and rgb
   
   --- 2 ---
   1 mask, so that means there's no brightness inputs now
   --- HSB - 2 ---
   hsbMSV, hsbMISV, hsbMSH, hsbMISH
   --- RGB - 2 ---
   rgbMSV, rgbIMSV, rgbMSH, rgbMISH, rgbDMSV --> D stands for double, there's a mask summer now so this is kinda useless
   
   example:
   imgMask1 = contrastMask(imgSorted, 50, 250); //masks need the original image size to return a mask the same size. also this is the goat mask, just use contrast masks lmao
   imgSorted = rgbMSH(imgSorted, imgMask1, true, false, true);
   in this one we are using rgb, there's a mask, and we will not sort green
   
   --- 3 ---
   the actual good ones
   --- HSB - 3 ---
   hsbMSVT, hsbMISVT, hsbMSHT, hsbMISHT
   --- RGB - 3 ---
   rgbMSVT, rgbMISVT, rgbMSHT, rgbMISHT, rgbDMSVT
   
   example:
   imgSorted = rgbMSVT(imgSorted, imgMask1, true, true, true, 50);
   rgb again, same mask we set up before, and we are sorting 50 pixels at a time for each column
   you can use the variable "pxSixe" to make one of theese sort the whole image
   
   --- MASKS ---
I SHOULD RE-WRITE THIS AS THERE'S ONLY 1 MASK IMPLEMENTED CURRENTLY
   there's 2 range masks:
   by contrast (really the goat), recieves a base image for size reference, and min and max values
   imgMask1 = contrastMask(imgSorted, 50, 250);
   
   the hue one adds min and max hue to the contrast mask above
   imgMask1 = hueContrastMask(imgSorted, 50, 250, 50, 150);
   
   there's a gimmicky random mask (can work well in sums, kinda shit otherwise lol)
   imgMask1 = randomMask(imgSorted);
   
   then there's 2 geometrical masks
   rectangular, with a starting point and height and width inputs
   first 2 values are x and y in pixels, then width and height (again, in pixels)
   imgMask1 = rectMask(imgSorted, 50, 100, 150, 200);
   
   the elliptic one is pretty similar, needs x and y for the centre and width and height of the ellipse
   imgMask1 = ellipticMask(imgSorted, 50, 100, 150, 200);
   
   last but not least, theres a function that allows us to sum masks
   this function will return an image with the white pixels of both masks recieved as an input
   imgMask3 = maskSum(imgMask1, imgMask2);
   
   --- OTHER ---
THIS IS THE FILTERING SECTION, EXPLAIN WHAT IS IMPLEMENTED AND HOW TO USE
CHAINING (AND NATURAL ORDER IF EVERYTHING IS CHECKED)
   theres a floyd-steinberg dither, it's fucking awesome (usually best after sorting, it can mess up the masking)
   recieves the image and the amount of steps u want (input of 1 means 1 step => 2 different reds, 2 different greens, 2 different blues)
   imgSorted = fsDither(imgSorted, 4);
   
   the name kinda tells everything u need to know other than it doesn't really work that well lmao
   imgSorted = pixelator(imgSorted, 50);
   
   processing built in filters are pretty nice too, i personally use "ERODE" a lot in the end of my chains
   imgSorted.filter(ERODE);
   (official doc: https://processing.org/reference/filter_.html)
   
   using the random function can give pretty cool results when animated (you can export a number of frames and make gifs or whatever)
   random(50) will give a random number between 0 and 50
   random(50, 150) will give a random number between 50 and 150
   for example:
   imgMask1 = contrastMask(imgSorted, random(50), random(200, 250));
   imgSorted = rgbMSH(imgSorted, imgMask1, true, false, true);
   this needs to loop in order to work for obvious reasons
   
   last we have the text on screen, with an outline (it's not hard to set up coloring input i'm just lazy lmao)
   inside the code you will be able to write the text and select the x and y positions on the image
   as for the font, inside the "data" folder there's a "fonts" folder, drop the font file there and write the namefile in the code
   */

have fun :D - mnkrnk