//<DATA MOSH LAB v0.1.0b>//
/* RGB and HSB sorts with masking and a few filter options
 written in processing 4.x, download here: https://processing.org/

alright, as this stands right now its just a glorified pixel sorter, but theres a lot of code already written that has not yet been implemented since i JUST made the GUI.
once i figure out how to present these features in said GUI, i will throw some updates so that everything lying around the project is usable.

shoutouts to Peter Lager for the GUI library, the coding train for endless fun projects (and the fs dither present here) and tim rodenbröker for the rasterizer idea!
and massive thanks to everyone that posts on the processing forum, i got to resolve lots of issues just surfing through there :D

1- installation and setup --> only needed for first time setup
	download and install processing (v4.3 or newer)
	open sketch (double click on any ".pde" file within the sketch folder, they should all open at once since they are part of the same project).
	in the toolbar, go to sketch-> import libraries-> manage libraries-> search and download G4P library (by Peter Lager, v4.3.11 or newer, the entire GUI is built on this library).
	press run on the sketch (the big ol' play button).

2- running the program
	all photos should be in *.jpg format and have to be dropped in the "data" folder. Saved frames will be stored in the "output" folder.

	the gui presents 3 separate sections, each with it's own trigger button and some parameters we can choose from.
	the basic sections are:

		-sorting: executes different sorting algorithms over the image's pixels based on the parameters selected.

		-filtering: applies different filters to the image based on the parameters selected.

		-text: allows for custom text to be displayed in the center of the image. (PENDING: font selection and custom position)

	on the bottom part we'll see the following buttons:

		-previous: will select the previous image in the data folder.

		-next: will select the next image in the data folder.

		-reset: resets the image back to the original, and deletes all temporal files created during editing.

		-undo: will go back one step, works the same for all sections, and saves every step since the original photo is uploaded.

		-save: saves the current canvas in the output folder.

	lastly, there's an event viewer at the bottom. It serves as a debug feature for now -will probably be deleted or hidden in later versions-.
	if you encounter a bug or and error, post the event viewer log in the repo as an issue so i can check it out.
   */

/* SORTING --- oooh boy, here we go...

   the sorting algorithms will grab chunks of pixels and sort them based on the parameters we pick
   the main parameters here are the two big sliders that represent minimum brightness and maximum brightness thresholds.
   the algorithms will use these thresholds to decide which pixels should be sorted together, more on this later.
   the next most important part are the checkboxes up top, these do the following:

	-rgb: will sort pixels based on red green and blue values of each pixel

	-hsb: will sort pixels based on hue, saturation and brightness values of each pixel

	-vertical: will sort pixels vertically

	-horizontal: will sort pixels horizontally

	-invert: will invert the behavior of the thresholds. When this is selected, the algorithm will check for pixels outside of the defined range. 
	(instead of maxBright > x > minBright, its x < minBright && x > maxBright)

	-masked: will sort pixels based on an input mask, an image with only black and white pixels (more on this later)
	the parameters for the mask are the same as the parameters for the unmasked sorts, so the same brightness sliders work both ways.

   the last checkbox (that has it's own slider) is the threshold: this value will control the maximum amount of pixels we can sort at any given time.
   this will create a sort of "stepped" effect, it works really well with extreme settings to allow for whatever figures we have in the image to not just turn into a giant     blur.
   
   this will all make sense... eventually :P
   */
   
/* FILTERING --- the sauce

   the filtering section allows for some post-sort goodness.
   same as with the sorts, we will be presented with a series of checkboxes to select what filter we want to apply, as well as some parameters for specific filters.

	-dither: floyd-steinberg dithering (shoutout to the coding train :D), aka error diffusion dithering, the slider here will represent the amount of "cuts" our color 	scale has.
	for example, a value of 2 will result in 3 different "shades" of each color

	-rasterize: i honestly don't know how to explain this lmao, just chech the video where i took the idea from: https://www.youtube.com/watch?v=XO8u0Y75FRk
	(shoutout to tim rodenbröker)

	-posterize: built in processing filter, we can control the input value with the given slider.

	-erode and dilate: built in processing filters that fiddle with the lightning of the image.

	for more info on the built in filters you can check the official processing reference.
  */

/* TEXT--- biiiiig WIP tbh

   the text feature will display whatever we write in the text box in the center of the image
   position, colour and font parameters are wips (and pretty important ones tbh, i'll get to them once i finish implementing masks).

   the controls we have available are just 2:
	text size: self explanatory, just font size
	text outline: will draw the text with a set black outline
  */

/* aaaaaaand that's all for now! If there's anything left out (can happen, i like coding not writing readmes :P) feel free to ask in the repo or just contact me on my socials.
   
   have fun sorting :D - mnkrnk
  */
   

/* if you want to fiddle with the code, this is the old readme before the GUI was created:

   --- SORTS ---
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
