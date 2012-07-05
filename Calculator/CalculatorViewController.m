//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Arno Bost on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userSelectedMinusBeforeEnteringADigit;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userSelectedMinusBeforeEnteringADigit = _userSelectedMinusBeforeEnteringADigit;
@synthesize brain = _brain;


//Only use this method to change the display-text,
//thus securing that display only shows what it shall
//
//Hint: don't use the default Setter-Method for display.text
//anywhere in this CalculatorViewController.m !!!
//
- (void) secureSetDisplayText:(NSString *)newDisplayString {
    NSString *workDisplayString = @"";
    NSString *zeroString = @"0";
    NSUInteger index;
    BOOL stateMinus = NO;   //change to YES at the 1st occurance of "-"
    BOOL stateDecimal = NO; //change to YES at the 1st occurance of period
    BOOL stateFreeShotforZeroAllowed = NO; //change to YES at period or 1st occurance of digit >=1
    BOOL stateDigit = NO;   //change to YES at the 1st occurance of a digit
    BOOL stateExponential = NO; //change to YES at 1st occurance of "e"
    NSString *curCharString = @"";
    NSString *prevCharString = @"";
    NSRange curRange;
    NSString *digitString = @"0123456789einf"; //allow "e" for operation results w/ large values
    
        
    //Check if newDisplayString is nil
    if (!newDisplayString) {
        workDisplayString = zeroString;
        
    //Check if newDisplayString is empty    
    } else if ([newDisplayString isEqualToString:@""]) {
        workDisplayString = zeroString;
    
    //**From now on, newDisplayString is NOT empty
    } else {
        for (index = 0; index <= ([newDisplayString length]-1); index++) {
            prevCharString = curCharString;
            curRange.length = 1;
            curRange.location = index;
            curCharString = [newDisplayString substringWithRange:curRange];
            
            //NSLog(@"Index=%i, curCharString=%@, prevCharString=%@", index, curCharString, prevCharString);
            
            //Check "-"
            if ([curCharString isEqualToString:@"-"]) {
                
                if (stateExponential) {
                    workDisplayString = [workDisplayString stringByAppendingString:@"-"];
                } else if (!stateMinus) {
                    workDisplayString = [@"-" stringByAppendingString:workDisplayString];
                    stateMinus = YES;
                };
            } 
            
            // Check period
            else if ([curCharString isEqualToString:@"."]) {
                if (!stateDecimal) {
                    if ([digitString rangeOfString:prevCharString].location == NSNotFound) {
                        workDisplayString = [workDisplayString stringByAppendingString:@"0."];
                    } else {
                        workDisplayString = [workDisplayString stringByAppendingString:@"."];
                        stateDigit = YES;
                    }
                    stateDecimal = YES;
                    stateFreeShotforZeroAllowed = YES;
                    
                }
            }
            
            // Check digits with "zero-handling"
            //
            else if ([digitString rangeOfString:curCharString].location != NSNotFound) {
                if (stateFreeShotforZeroAllowed) {
                    workDisplayString = [workDisplayString stringByAppendingString:curCharString];
                } else {
                    if ([prevCharString isEqualToString:@"0"]) {
                        workDisplayString = [[workDisplayString substringToIndex:([workDisplayString length]-1)] stringByAppendingString:curCharString];
                    } else {
                        workDisplayString = [workDisplayString stringByAppendingString:curCharString];
                    };
                    if (![curCharString isEqualToString:@"0"]) {
                        stateFreeShotforZeroAllowed = YES;
                    }
                }
                
                stateDigit = YES;
                if ([curCharString isEqualToString:@"e"]) {
                    stateExponential = YES;
                    stateFreeShotforZeroAllowed = YES;
                }
            }
        }
    }

    //last check of workDisplayString
    if ([workDisplayString isEqualToString:@"-"]) {
       workDisplayString = @"-0";
    }
    
    //assign to display.text
    
    self.display.text = workDisplayString;
    
    //correct state information
    
    if ([workDisplayString isEqualToString:@"0"]) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
    } else if ([workDisplayString isEqualToString:@"- 0"]) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
    
}

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void) setIsResultIndicator; {
    NSString *sumSignLong = @" =";
    NSRange posOfSumSign = [self.historyDisplay.text rangeOfString:sumSignLong];
    if (posOfSumSign.location == NSNotFound) {
        self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:sumSignLong];
    }
}

- (void) delIsResultIndicator; {
    NSString *sumSignLong = @" =";
    NSRange posOfSumSign = [self.historyDisplay.text rangeOfString:sumSignLong];
    if (posOfSumSign.location != NSNotFound) {
        self.historyDisplay.text = [self.historyDisplay.text substringToIndex:posOfSumSign.location];
    }
    
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
 
    [self delIsResultIndicator];

    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self secureSetDisplayText:([self.display.text stringByAppendingString:digit])];
    } else {
        if (self.userSelectedMinusBeforeEnteringADigit) {
            [self secureSetDisplayText:[@"-" stringByAppendingString:(digit)]];
        } else {
            [self secureSetDisplayText:digit];
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }

}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userSelectedMinusBeforeEnteringADigit = NO;
    
    [self delIsResultIndicator];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:self.display.text];

}

- (IBAction)operationPressed:(UIButton *)sender {
    [self delIsResultIndicator];
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    NSString *operation = sender.currentTitle;
    
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:operation];
    
    double result = [self.brain performOperation:operation];
    [self secureSetDisplayText:([NSString stringWithFormat:@"%g", result])];
    [self setIsResultIndicator];
}

- (IBAction)decimalDelimiterPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self secureSetDisplayText:([self.display.text stringByAppendingString:@"."])];
    } else {
        if (self.userSelectedMinusBeforeEnteringADigit) {
            [self secureSetDisplayText:@"-."];
        } else {
            [self secureSetDisplayText:@"."];
            
        }
        self.userIsInTheMiddleOfEnteringANumber = YES;
        [self delIsResultIndicator];
    }
}

- (IBAction)clearButtonPressed {
    self.historyDisplay.text = @"";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userSelectedMinusBeforeEnteringADigit = NO;
    [self.brain clearCalculatorBrain];
}

- (IBAction)backspacePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self secureSetDisplayText:([self.display.text substringToIndex:([self.display.text length]-1)])];
    }
}

- (IBAction)signChangePressed:(id)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        
        BOOL saveStatePeriod = [@"." isEqualToString:([self.display.text substringFromIndex:([self.display.text length] - 1)])];
        
        //NSLog(@"DoubleValue = %g", [self.display.text doubleValue]);
        [self secureSetDisplayText:([NSString stringWithFormat:@"%g", [self.display.text doubleValue] * (-1)])];
        
        if (saveStatePeriod) {
            [self secureSetDisplayText:([self.display.text stringByAppendingString:@"."])];
        }
        [self delIsResultIndicator];
    } else {
        [self operationPressed:sender];
    }
    self.userSelectedMinusBeforeEnteringADigit = [[self.display.text substringToIndex:1] isEqualToString:@"-"];
}


@end
