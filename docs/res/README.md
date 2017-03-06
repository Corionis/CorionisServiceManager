# CorionisServiceManager/docs/res/ Directory Notes

The images in this directory are used in the documentation.

This directory contains the base source files as .XCF files for 
[GIMP, the  GNU Image Manipulation Program](https://www.gimp.org/)
as well as the files used on the GitHub Pages site.

The screenshots were taken with [Greenshot](http://getgreenshot.org/).

Procedure for drop shadows on the screenshots:
 1. Take the screenshot.
 2. In GIMP goto menu Image, Set Image Canvas Size.
    1. Canvas size: Width + 30, Height + 20.
    2. Offset: X 20, Y 10.
    3. Click Resize.
 3. Set the GIMP background color to the color in the file tactile-background.jpg.
 4. Click menu Image, Flatten Image. This merges the screenshot with a background that matches the theme of the site.
 5. Using the Rectangular Select Tool select a box around the screenshot only, not the background.
 6. Click menu Filters, Light and Shadow, Drop Shadow ...
    1. Offset X 5, Offset Y 5
    2. Blur radius 10
    3. Opacity 60
    4. DISABLE Allow resizing.
 7. Save the GIMP XCF-format project file.
 8. Click menu File, Export As ...
    1. Export as the file type needed for the site.


