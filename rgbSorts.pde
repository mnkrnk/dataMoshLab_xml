/*
ALL RGB SORTS
 FIRST THE SIMPLE ONES
 THEN MASKED
 LAST WITH ARRAY THRESHOLD
 */

//rgb sorts work exactly the same as the hsb ones, with the sole difference that instead of separating and sorting hue, saturation and brightness, we are going to sort red green and blue (DUH)
//the hsb sorts are the ones that are properly commented, so go check that if curious about whatever :D
PImage rgbV (PImage img, int minBrThresh, int maxBrThresh, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);
      float briTemp = brightness(img.pixels[pxPos]);

      if (briTemp > minBrightness && briTemp < maxBrightness) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);
          
          //this is basically the only difference with the hsb sorts
          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

PImage rgbIV (PImage img, int minBrThresh, int maxBrThresh, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);
      float briTemp = brightness(img.pixels[pxPos]);

      if (briTemp < minBrightness || briTemp > maxBrightness) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

PImage rgbH (PImage img, int minBrThresh, int maxBrThresh, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);
  float minBrightness = minBrThresh;
  float maxBrightness = maxBrThresh;

  for (int i = 0; i < img.height; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.width; j++) {

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

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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


PImage rgbIH (PImage img, int minBrThresh, int maxBrThresh, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);
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

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

//2ND SORTS
PImage rgbMSV (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);

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

      if (briTemp == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

PImage rgbMISV (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);
  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp;
      if (j == img.height - 1) {
        briTemp = 255;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (briTemp == 0) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

PImage rgbMSH (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);
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


      int arrThresh = round(random(30, 50));
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

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
        }

        startRow = 0;
        endRow = 0;
        sort = false;
      }
    }
  }
  return img;
}


PImage rgbMISH (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);

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

      if (briTemp == 0) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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


PImage rgbDMSV (PImage img, PImage mask1, PImage mask2, boolean redFlg, boolean greenFlg, boolean blueFlg) {
  colorMode(RGB);

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);
      float briTemp1 = brightness(mask1.pixels[pxPos]);
      float briTemp2 = brightness(mask2.pixels[pxPos]);

      if (briTemp1 == 255 && briTemp2 == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

//3RD SORTS
PImage rgbMSVT (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg, int arrThresh) {
  colorMode(RGB);

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

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

PImage rgbMISVT (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg, int arrThresh) {
  colorMode(RGB);

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp;
      if (j == img.height - 1) {
        briTemp = 255;
        endRow = endRow + 1;
      } else {
        briTemp = brightness(mask.pixels[pxPos]);
      }

      if (endRow - startRow > arrThresh) {
        briTemp = 0;
      }

      if (briTemp == 0) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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

PImage rgbMSHT (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg, int arrThresh) {
  colorMode(RGB);

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

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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


PImage rgbMISHT (PImage img, PImage mask, boolean redFlg, boolean greenFlg, boolean blueFlg, int arrThresh) {
  colorMode(RGB);

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

      if (endRow - startRow > arrThresh) {
        briTemp = 0;
      }

      if (briTemp == 0) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(x, i, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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


PImage rgbDMSVT (PImage img, PImage mask1, PImage mask2, boolean redFlg, boolean greenFlg, boolean blueFlg, int arrThresh) {
  colorMode(RGB);

  for (int i = 0; i < img.width; i++) {

    int startRow = 0;
    int endRow = 0;
    boolean sort = false;

    for (int j = 0; j < img.height; j++) {

      int pxPos = pxIndex(i, j, img.width);

      float briTemp1 = brightness(mask1.pixels[pxPos]);
      float briTemp2 = brightness(mask2.pixels[pxPos]);

      if (endRow - startRow > arrThresh) {
        briTemp1 = 0;
        briTemp2 = 0;
      }

      if (briTemp1 == 255 && briTemp2 == 255) {

        if (sort == false) {
          startRow = j;
          sort = true;
        }
        endRow = j;
      } else if (sort == true) {

        int pxCount = endRow - startRow + 1;

        float[] redArr = new float[pxCount];
        float[] greenArr = new float[pxCount];
        float[] blueArr = new float[pxCount];
        int[] refArr = new int[pxCount];

        int pxSortIndex = 0;

        for (int x = startRow; x <= endRow; x++) {

          int pxIndex = pxIndex(i, x, img.width);

          float red = red(img.pixels[pxIndex]);
          float green = green(img.pixels[pxIndex]);
          float blue = blue(img.pixels[pxIndex]);

          refArr[pxSortIndex] = pxIndex;
          redArr[pxSortIndex] = red;
          greenArr[pxSortIndex] = green;
          blueArr[pxSortIndex] = blue;
          pxSortIndex++;
        }

        if (redFlg) {
          redArr = sortFloatPxArr(redArr);
        }
        if (greenFlg) {
          greenArr = sortFloatPxArr(greenArr);
        }
        if (blueFlg) {
          blueArr = sortFloatPxArr(blueArr);
        }

        pxSortIndex = 0;

        for (int x = 0; x < refArr.length; x++) {
          int pxRef = refArr[x];

          img.pixels[pxRef] = color(redArr[x], greenArr[x], blueArr[x]);
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
