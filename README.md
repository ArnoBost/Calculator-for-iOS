## Welcome to the Assignment-1---Calculator wiki!

This repo contains the source code for an iPhone-App named "**Calculator**", which is my work on [Assignment 1](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071#).

I've developed it as member of the [Stanford University](http://www.stanford.edu) class "Coding together-Apps for iPhone & iPad" (CS193p). This class has been setup by Standford University in summer 2012 as an online peer collaboration community on [piazza.com](http://www.piazza.com). Moderated by instructors, members can communicate about iOS development issues in order to finish their given assignments.

The Coding-together class is based on lectures [Developing Apps for iOS (CS193P)](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071) from Prof. Paul Hegarty, that are distributed online via iTunes U.

## App features

![image](https://github.com/ArnoBost/Assignment-1---Calculator/blob/master/Screenshot.png)

The requested features for the App are defined in the class's [Assignment 1](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071#). There are mandatory and optional requests, that give extra credits in the "real world".

The main task was to develop a single-view app for iPhone (>= iOS 5.x), that works as a **RPN-Calculator**. "RPN" stands for "Reverse Polish notation". This is some old-fashioned stuff of the early days of digital calculators (-> [Wikipedia article](http://en.wikipedia.org/wiki/Reverse_Polish_notation)).

I've implemented all of those **features**, e.g.:
* a **history label**, that displays the operands and operations pushed onto the calculator stack. A "="-character indicates, that the main display is representing the result of an operation.
* provide **digit buttons** for the user input of numbers.
* provide an **enter button** to push the current display number onto the calculator stack.
* provide **operation buttons** to let the user perform math operations (+, -, /, *).
* provide **additional operation buttons** like sin, cos, log, √, x²
* provide **period button** and handle input of decimal delimiter properly.
* provide **+/- button** to change the leading sign. If user is entering a number, switch the sign of the main display. Else handle it like an operator, to math the last operation's result by * (-1).
* provide **π button** to enter Pi and push it onto the calculator stack.
* **Error Handling** has to be done not by an error indicator, but by delivering "0" as an operation's result, e.g. when division "/0" gets calculated.

**Additional features by my own:**
* provide **logo image** for app.
* provide **image backgrounds** for buttons and history/main display label.

## Remarks
This repo is the base for further Assignments.

Outlook:
* Assignment 2: "Programmable Calculator"
* Assignment 3: "Universal App"
