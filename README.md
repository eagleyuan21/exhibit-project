# exhibit-project
This is the code for an autonomous functioning museum exhibit built using arduino in Matlab. Add-ons are required to use Arduino in Matlab. In order to download the add-ons, click Add-Ons > Get Hardware Support Packages. Select 'Install from Internet', then select Arduino and finish installing. In order to connect Arduino, there needs to be an initialization of the port name connected to the Arduino usb. Use these:
```Matlab
Windows Users: a=arduino(‘COM#’, ‘Uno’)
Mac Users: a=arduino(‘/dev/tty.USB#’, ‘Uno’)
```
The Matlab environment should now be ready.

The exhibit was targetted towards teaching health resiliency to age groups between 3rd and 5th grade.

A picture of the exhibit: 

<img src=exhibit-image.jpg width="420">

The exhibit has a motor and track located on the top of the exhibit that show progression, three buttons to play with the exhibit, and an ultrasonic sensor that acts as both a trigger to start and a restart for the exhibit. A specific image of the hardware layout can be found in "exhibit-image.jpg".

"exhibit.m" is the Matlab file for the exhibit. Anywhere in the code with a ".jpg" file is where an image is projected onto the screen relevant to the story line of the exhibit.
