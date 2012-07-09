## Welcome to the Calculator App for iPhone!

This repo contains the source code for an iPhone-App named "**Calculator**", which is my work on [Assignment 1 and 2](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071#).

I've developed it as member of the [Stanford University](http://www.stanford.edu) class "Coding together-Apps for iPhone & iPad" (CS193p). This class has been setup by Standford University in summer 2012 as an online peer collaboration community on [piazza.com](http://www.piazza.com). Moderated by instructors, members can communicate about iOS development issues in order to finish their given assignments.

The Coding-together class is based on lectures [Developing Apps for iOS (CS193P)](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071) from Prof. Paul Hegarty, that are distributed online via iTunes U.

## App features

![image](http://www.arnobost.de/SiteImages/2012-07-09-CalcScreenshot-01.png)

The requested features for the App are defined in the class's [Assignments 1 and 2](http://itunes.apple.com/us/course/coding-together-apps-for-iphone/id537447071#). There are mandatory and optional requests, that give extra credits in the "real world".

The main task was to develop a single-view app for iPhone (>= iOS 5.x), that works as a **RPN-Calculator**. "RPN" stands for "Reverse Polish notation". This is some old-fashioned stuff of the early days of digital calculators (-> [Wikipedia article](http://en.wikipedia.org/wiki/Reverse_Polish_notation)).


## Features for Assignment 2 (Programmable Calculator)

Assignment 2 is based on the code for Assignment 1.
I've added these **features** in accordance with Assignment 1:

* enhance the calculator to be **programmable**.
* new **variable buttons** for entering variables named "x", "a" and "b".
* new **test buttons** for applying (hard coded) values to the variables.
* new **variable display** in the view to display the variable with values, which are used in the current program.
* changed the **history label** to show the program entered by a user in a more convenient way with outbreaking minimization of the use of parentheses.
* new **undo button** as an enhancement to the formerly backspace button: when there is no last digit to be deleted, the user can delete the last operation or operand from the program stack.

**Extra Credit:**
* enhanced **error handling**: now displaying an error message instead of a Zero-Number, when an error occured during run of the program (e.g. division by zero). 
* It's a great enhancement of user experience, especially in combination with the new **undo feature** (see above).

**Additional features on my own:**

* new **logo images** for app.
* new **golden background image** for the main calculator view.
* new **1/x button** delivers functionality to calculate reversal numbers.
* enhanced **error handling** by displaying a smiley in the history label, when an operand was missed by the last operation (instead of the formerly "0" in this situation).


## Features for Assignment 1 (RPN-Calculator)

I've implemented all of those **features**, e.g.:

* a **history label**, that displays the operands and operations pushed onto the calculator stack. A "="-character indicates, that the main display is representing the result of an operation.
* provide **digit buttons** for the user input of numbers.
* provide an **enter button** to push the current display number onto the calculator stack.
* provide **operation buttons** to let the user perform math operations (+, -, /, *).
* provide **additional operation buttons** like sin, cos, log, √, x²
* provide **period button** and handle input of decimal delimiter properly.
* provide **+/- button** to change the leading sign. If user is entering a number, switch the sign of the main display. Else handle it like an operator, to math the last operation's result by * (-1).
* provide **π button** to enter Pi and push it onto the calculator stack.
* **rror handling** has to be done not by an error indicator, but by delivering "0" as an operation's result, e.g. when division "/0" gets calculated.
* **backspace button** to delete the last digit of a number, that the user currently is entering.

**Additional features on my own:**

* provide **logo image** for app.
* provide **image backgrounds** for buttons and history/main display label.


## Remarks

History:
* Assignment 1: "RPN-Calculator"
* Assignment 2: "Programmable Calculator"
* Assignment 3: "Universal App"
