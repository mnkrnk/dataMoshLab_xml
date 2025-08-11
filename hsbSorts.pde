/*
ALL HSB SORTS
 FIRST THE SIMPLE ONES
 THEN MASKED
 LAST WITH ARRAY THRESHOLD
 */



PImage hsbV (PImage img, int minBrThresh, int maxBrThresh, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  //we loop through the image, if we want to sort vertically we start with columns and then nest another loop to check for each pixel below our first row
  //if we want a horizontal sort we just swap the order of the for each loops (check hsbH)
  //we want to check what pixels have a brightness that sits between our input thresholds "minBrThresh" and "maxBrThresh"
  //all pixels that meet the condition will be stored in an array
  //once a pixel outside the range is found -or we just get to the end of the image- we will sort those pixels and reintroduce them in the original image
  //this process is just copy and pasted in all the other sorts, with some functionality added that will be commented as it shows up

  for (int i = 0; i < img.width; i++) { //for each column...

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) { //for each row...

      int pxPos = pxIndex(i, j, img.width); //this is the current pixel's index, or position within the pixel array (quite useful piece of information right 'ere)
      float briTemp = brightness(img.pixels[pxPos]);

      if (briTemp > minBrightness && briTemp < maxBrightness) { //while our current brightness value sits between our set thresholds, we will add that pixel to the "sort array"

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) { //once we finish counting pixels, we go through with the sorting

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount]; //we initialize the arrays for each color property with the amount of pixels we alredy know we'll need
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount]; //and this last array is where we store the indexes of all the pixels, so that we can then know which pixels we need to replace from the original image

        int pxSortIndex = 0; //we initialize a new index for the new array

        for (int x = startRow; x <= endRow; x++) { //here we obtain the color properties of each pixel we are sorting

          int pxIndex = pxIndex(i, x, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          //each value gets saved in its respective array
          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        //here we do the sorting, with some ifs to be able to select which properties we want sorted
        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) { //the pixel replacing, literally manually setting the HSB values of each pixel xdd

          int pxRef = refArr[x];
          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0; //once we replaced all the pixels, we reset every variable for the next j loop to start clean
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//same sort as before, but the threshold condition is now inverted (x < min; x > max)
PImage hsbIV (PImage img, int minBrThresh, int maxBrThresh, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);
      float briTemp = brightness(img.pixels[pxPos]);

      if (briTemp < minBrightness || briTemp > maxBrightness) { //the swapped condition, the rest's just the same

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//like the first one, but horizontal
PImage hsbH (PImage img, int minBrThresh, int maxBrThresh, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  for (int i = 0; i < img.height; i++) { //instead of starting from each pixel horizontally, we do that vertically

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.width; j++) { //and here is the other for loop, also swapped to now check horizontally. rest is the same

      int pxPos = pxIndex(j, i, img.width);
      float briTemp = brightness(img.pixels[pxPos]);


      if (briTemp > minBrightness && briTemp < maxBrightness) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//you get the drill already don't ya? xdd this is just horizontal with inverted threshold, this pattern will continue in the other sorts (vertical, vertical inverted, horizontal, horizontal inverted)
PImage hsbIH (PImage img, int minBrThresh, int maxBrThresh, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  for (int i = 0; i < img.height; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.width; j++) {

      int pxPos = pxIndex(j, i, img.width);
      float briTemp = brightness(img.pixels[pxPos]);


      if (briTemp < minBrightness || briTemp > maxBrightness) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//2ND SORTS - with another PImage input that works as a sorting mask, it should be an image that only contains black OR white pixels
//white pixels will be grouped up in pixel arrays to then sort those specific chunks
PImage hsbMSV (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp;
      if (j == img.height - 1) { //we always consider the last pixel as a black one so that the array actually ends, but we still count it in the endRow
        briTemp = 0;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (briTemp == 255) { //as long as the pixel is white, we are gonna sort this

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//same as before but now the threshold is backwards, so black pixels from the mask are the ones dictating the sorting
PImage hsbMISV (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp;
      if (j == img.height - 1) {
        briTemp = 0;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (briTemp == 0) { //as long as the pixel is black, we sort, yada yada

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//horizontal masked
PImage hsbMSH (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);

  for (int i = 0; i < img.height; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.width; j++) {

      int pxPos = pxIndex(j, i, img.width);

      float briTemp;
      if (j == img.width - 1) {
        briTemp = 0;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (briTemp == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//horizontal masked inverted
PImage hsbMISH (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg) {
  colorMode(HSB);
  for (int i = 0; i < img.height; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.width; j++) {

      int pxPos = pxIndex(j, i, img.width);

      float briTemp;
      if (j == img.width - 1) {
        briTemp = 255;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (briTemp == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//3RD SORTS - added the possibility to limit the max amount of pixels within each array, so that you get the "stepped" effect instead of just a continuous gradient
//vertical

PImage hsbMSVT (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg, int arrThresh) {
  colorMode(HSB);
  int inputArr = arrThresh;

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;

    int randArr;
    boolean sort = false;

    if (randThreshCheckbox.isSelected()) {//rand thresh check, check before 2nd loop
      randArr = int(randThreshSlider.getValueS());
      arrThresh = abs(int(random(inputArr - randArr, inputArr + randArr)));
    }

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp;
      if (j == img.height - 1) {
        briTemp = 0;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (endRow - startRow > arrThresh) { // each time an array surpasses the threshold taken as an input, a black pixel is faked to trigger the sorting
        briTemp = 0;
      }

      if (briTemp == 255) {
        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//vertical inverted
PImage hsbMISVT (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg, int arrThresh) {
  colorMode(HSB);
  int inputArr = arrThresh;

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    int randArr;
    boolean sort = false;

    if (randThreshCheckbox.isSelected()) {//rand thresh check, check before 2nd loop
      randArr = int(randThreshSlider.getValueS());
      arrThresh = abs(int(random(inputArr - randArr, inputArr + randArr)));
    }

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp;
      if (j == img.height - 1) {
        briTemp = 0;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (endRow - startRow > arrThresh) {
        briTemp = 0;
      }

      if (briTemp == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//horizontal
PImage hsbMSHT (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg, int arrThresh) {
  colorMode(HSB);
  int inputArr = arrThresh;

  for (int i = 0; i < img.height; i++) {

    int startRow = 0;
    int endRow = 0;
    int randArr;
    boolean sort = false;

    if (randThreshCheckbox.isSelected()) {//rand thresh check, check before 2nd loop
      randArr = int(randThreshSlider.getValueS());
      arrThresh = abs(int(random(inputArr - randArr, inputArr + randArr)));
    }

    for (int j = 0; j < img.width; j++) {

      int pxPos = pxIndex(j, i, img.width);

      float briTemp;
      if (j == img.width - 1) {
        briTemp = 0;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (endRow - startRow > arrThresh) {
        briTemp = 0;
      }

      if (briTemp == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}

//horizontal inverted
PImage hsbMISHT (PImage img, PImage mask, boolean hueFlg, boolean satFlg, boolean briFlg, int arrThresh) {
  colorMode(HSB);
  int inputArr = arrThresh;

  for (int i = 0; i < img.height; i++) {

    int startRow = 0;
    int endRow = 0;
    int randArr;
    boolean sort = false;

    if (randThreshCheckbox.isSelected()) {//rand thresh check, check before 2nd loop
      randArr = int(randThreshSlider.getValueS());
      arrThresh = abs(int(random(inputArr - randArr, inputArr + randArr)));
    }

    for (int j = 0; j < img.width; j++) {

      int pxPos = pxIndex(j, i, img.width);
      float briTemp;

      if (j == img.width - 1) {
        briTemp = 255;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (endRow - startRow > arrThresh) {
        briTemp = 0;
      }

      if (briTemp == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] briArr = new float[pxCount];
        float[] satArr = new float[pxCount];
        float[] hueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float hue = hue(img.pixels[pxIndex]);
          float sat = saturation(img.pixels[pxIndex]);
          float bri = brightness(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          hueArr[pxSortIndex] = hue;
          satArr[pxSortIndex] = sat;
          briArr[pxSortIndex] = bri;

          pxSortIndex++;
        }

        if (hueFlg) {
          hueArr = sortFloatPxArr(hueArr);
        }
        if (satFlg) {
          satArr = sortFloatPxArr(satArr);
        }
        if (briFlg) {
          briArr = sortFloatPxArr(briArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(hueArr[x], satArr[x], briArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  img.updatePixels();
  return img;
}
