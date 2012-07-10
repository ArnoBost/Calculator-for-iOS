//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Arno Bost on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *dictVariableValues;

//private helper methods by my own convention w/ prefix "abo_"

+ (int)abo_deepEvaluateKindOfString:(NSString *)lookupString;
+ (NSSet *)abo_supported_Operations:(int)byNumberOfOperands;
+ (BOOL)abo_stringIsOperation:(NSString *)lookupString;
+ (BOOL)abo_stringIsVariable:(NSString *)lookupString;
+ (int)abo_numberOfOperandsNeeded: (NSString *)lookupString;

@end



@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize dictVariableValues = _dictVariableValues;

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (NSMutableDictionary *)dictVariableValues
{
    if (!_dictVariableValues) {
        _dictVariableValues = [[NSMutableDictionary alloc] init];
    }
    return _dictVariableValues;
}

+ (NSSet *)abo_supported_Operations:(int)byNumberOfOperands
{
    NSSet *mySetOfOperations;
    
    if (byNumberOfOperands == 0) {
        mySetOfOperations = [[NSSet alloc] initWithObjects: @"π", nil];
    } else if (byNumberOfOperands == 1) {
        mySetOfOperations = [[NSSet alloc] initWithObjects:@"sin",@"cos",@"log",@"√",@"x²",@"^",@"+/-",@"1/x", nil];
    } else if (byNumberOfOperands == 2) {
        mySetOfOperations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    }
    
    return mySetOfOperations;
}

+ (int)abo_deepEvaluateKindOfString:(NSString *)lookupString
{
// return values: -2 = is Number
//                -1 = is Variable (=any string that is not a number and not an operation
//                 0 = is Operation with 0 operands
//                 1 = is Operation with 1 operand
//                 2 = is Operation with 2 operands
    int result = -1;
    
    if (lookupString) {
        if ([lookupString isKindOfClass:[NSNumber class]]) {
            result = - 2;
        } else if ([[self abo_supported_Operations:0] member:lookupString]) {
            result = 0;
        } else if ([[self abo_supported_Operations:1] member:lookupString]) {
            result = 1;
        } else if ([[self abo_supported_Operations:2] member:lookupString]) {
            result = 2;
        }
    }
    
    return result;
}

+ (BOOL)abo_stringIsOperation:(NSString *)lookupString
{
    BOOL result = FALSE;
    
    if (lookupString) {
        result = ([self abo_deepEvaluateKindOfString:lookupString] >= 0);
    }
    
    return result;
}

+ (BOOL)abo_stringIsVariable:(NSString *)lookupString;
{
    BOOL result = FALSE;
    
    if (lookupString) {
        result = ([self abo_deepEvaluateKindOfString:lookupString] == -1);
    }
    
    return result;
}

+ (int)abo_numberOfOperandsNeeded: (NSString *)lookupString
//returns number of operands, that a given operator expects.
//if lookupString is not an operator => return value = -1
{
    int result = -1;
    
    if ([self abo_stringIsOperation:lookupString]) {
        result = [self abo_deepEvaluateKindOfString:lookupString];
    }
    
    return result;
}

- (BOOL)pushVariable:(NSString *)nameOfVariable
{
    BOOL result = FALSE;
        
    if ([CalculatorBrain abo_stringIsVariable:nameOfVariable]) {
        [self.programStack addObject:nameOfVariable];
        result = TRUE;
    }
    
    return result;
}

- (void)setVariableValues:(NSDictionary *)variableValues;
{
    [self.dictVariableValues removeAllObjects];
    NSString *key;
    id value;
    
    for (key in variableValues) {
        if ([CalculatorBrain abo_stringIsVariable:key]) {
            value = [variableValues objectForKey:key];
            if ([value isKindOfClass:[NSNumber class]]) {
                [self.dictVariableValues setObject:(NSNumber *)value forKey:key];
            }
        }

    }
}

- (NSNumber *)getVariableValue:(NSString *)variableName
{
    return [self.dictVariableValues objectForKey:variableName];
}

- (void)pushOperand: (double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)removeTopItemFromProgram
{
    id anObject = [self.programStack lastObject];
    if (anObject) {
        [self.programStack removeLastObject];
    }
}

- (id)performOperation: (NSString *) operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:self.dictVariableValues];
}

- (id)program 
{
    return [self.programStack copy];
}

- (id)variables
{
    return [self.dictVariableValues copy];
}

+ (NSSet *)variablesUsedInProgram:(id)program
//returns all variables in the whole programStack,
//thus not only in the last operation part!
//Coding together class http://piazza.com/class#summer2012/codingtogether/1089
{
    NSMutableSet *foundVariables;
    
    if ([program isKindOfClass:[NSArray class]]) {
        id stackObject;
        for (stackObject in program) {
            if ([stackObject isKindOfClass:[NSString class]]) {
                if ([self abo_stringIsVariable:(NSString *)stackObject]) {
                    if (!foundVariables) foundVariables = [[NSMutableSet alloc] initWithCapacity:3];
                    [foundVariables addObject:stackObject];
                }
            }
        }
    }
    
    return foundVariables;
}

+ (id)popOperandOffStack:(NSMutableArray *)stack 
//
//returns an object tpyeof NSNumber or NSString, never NIL
//type is NSNumber -> method result is a correct math operation
//type is NSString -> method result is an error string
//
{
    id resultObject;
    id operand1, operand2;
    NSNumber *resultNumberObject;
    NSString *resultStringObject = @"Error";
    int evalResult;
    int popErrorNr = 0;
    
    double result = 0;
    resultNumberObject = [NSNumber numberWithDouble:result];
    
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    } else {
        popErrorNr = 1;
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) 
    {
        NSString *operation = topOfStack;
        
        evalResult = [self abo_deepEvaluateKindOfString:operation];
        
        if (evalResult == -1) { //unknown operation
            popErrorNr = 4;
        } else if (evalResult == 0) { //no operands needed
            if ([@"π" isEqualToString:operation]) {
                result = M_PI;
            } else {
                popErrorNr = 5;
            }
        } else if (evalResult == 1) { //one operand needed
            operand1 = [self popOperandOffStack:stack];
            
            if ([operand1 isKindOfClass:[NSNumber class]]) 
            {   //perform operations with one operand
                
                
                if ([@"sin" isEqualToString:operation]) {
                    result = sin([operand1 doubleValue]);
                } else if ([@"cos" isEqualToString:operation]) {
                    result = cos([operand1 doubleValue]);
                } else if ([@"log" isEqualToString:operation]) {
                    
                    if ([operand1 doubleValue] >= 0) {
                        result = log10([operand1 doubleValue]);
                    } else {
                        popErrorNr = 3;
                    }
                } else if ([@"√" isEqualToString:operation]) {
                    
                    if ([operand1 doubleValue] >= 0) {
                        result = sqrt([operand1 doubleValue]);
                    } else {
                        popErrorNr = 3;
                    }
                } else if ([@"x²" isEqualToString:operation]) {
                    result = [operand1 doubleValue] * [operand1 doubleValue];
                } else if ([@"+/-" isEqualToString:operation]) {
                    result = [operand1 doubleValue] * (-1);
                } else if ([@"1/x" isEqualToString:operation]) {
                    
                    if ([operand1 doubleValue] == 0) {
                        popErrorNr = 2;
                    } else {
                        result = 1 / [operand1 doubleValue];
                    }
                } else {
                    popErrorNr = 5;
                }
            } else {
                popErrorNr = -1;
                if ([operand1 isKindOfClass:[NSString class]]) {
                    resultStringObject = operand1;
                }
            }
        } else if (evalResult == 2) { //two operands needed
            operand1 = [self popOperandOffStack:stack];
            
            if ([operand1 isKindOfClass:[NSNumber class]]) //validate operand1
            {   
                operand2 = [self popOperandOffStack:stack];
                
                if ([operand2 isKindOfClass:[NSNumber class]]) //validate operand2
                {
                    //perform operations with two operands
                    
                    if ([operation isEqualToString:@"+"]) {
                        result = [operand1 doubleValue] + [operand2 doubleValue];
                    } else if ([@"*" isEqualToString:operation]) {
                        result = [operand1 doubleValue] * [operand2 doubleValue];
                    } else if ([@"-" isEqualToString:operation]) {
                        result = [operand2 doubleValue] - [operand1 doubleValue];
                    } else if ([@"/" isEqualToString:operation]) {
                        if ([operand1 doubleValue] != 0) {
                            result = [operand2 doubleValue] / [operand1 doubleValue];
                        } else {
                            popErrorNr = 2;
                        }
                    } else {
                        popErrorNr = -1;
                        if ([operand1 isKindOfClass:[NSString class]]) {
                            resultStringObject = operand1;
                        }
                    }
                } 
                else { //getting operand2 resulted in error
                    popErrorNr = -1;
                    if ([operand2 isKindOfClass:[NSString class]]) {
                        resultStringObject = operand2;
                    }
                }
            } 
            else { //getting operand1 resulted in error
                popErrorNr = -1;
                if ([operand1 isKindOfClass:[NSString class]]) {
                    resultStringObject = operand1;
                }
            }
        }
    }
    
    //return result;
    if (popErrorNr == 0) {
        resultNumberObject = [NSNumber numberWithDouble:result];
        resultObject = resultNumberObject;
    } else {
        if (popErrorNr == -1) { //error resulting from recursive method call
            ; //do nothing, resultStringObject was initalized above
        } else if (popErrorNr == 1) {
            resultStringObject = @"Error: missing operand";
        } else if (popErrorNr == 2) {
            resultStringObject = @"Error: division by zero";
        } else if (popErrorNr == 3) {
            resultStringObject = @"Error: operand must be >= 0";
        } else if (popErrorNr == 4) {
            resultStringObject = @"Error: operand is not a number";
        } else if (popErrorNr == 5) {
            resultStringObject = @"Error: unknown operation";
        }
        
        resultObject = resultStringObject;
    }
    
    return resultObject;
}

+ (NSString *)forceOuterParentheses:(NSString *)mathExpression;
//do it only if necessary, no duplicate open/close-pairs!
{
    NSString *workString = mathExpression;
    NSString *helpString;
    BOOL hasThem = FALSE;
    int nrOfOpenBrackets;
    
    NSRange myRange;
    myRange.length = 1;
    myRange.location = 0;
    
    if ([@"(" isEqualToString:[workString substringWithRange:myRange]]) {
        nrOfOpenBrackets = 1;
        while (nrOfOpenBrackets !=0) {
            myRange.location++;
            if ((myRange.location) < [workString length]) {
                helpString = [workString substringWithRange:myRange];
                if ([@"(" isEqualToString:helpString]) {
                    nrOfOpenBrackets++;
                } else if ([@")" isEqualToString:helpString]) {
                    nrOfOpenBrackets--;
                }
                if (nrOfOpenBrackets == 0) {
                    hasThem = (myRange.location == [workString length] - 1);
                }
            }
            else {
                nrOfOpenBrackets = 0; //force exit of loop, is end of workstring
            }
        }
        
    }
    
    if (!hasThem) {
        workString = [NSString stringWithFormat:@"(%@)", workString];
    }
        
    return workString;
}

+ (int)priorityOfOperandByString:(NSString *)anOperandString;
/*
    Priority is intended to be as follows:
    7 for Operators with only 1 Operand (sin, cos, ...)
    6 for 1-operand-Operation x².
    5 for Operators with 2 Operands (/)
    4 for Operators with 2 Operands (*)
    3 for Operators with 2 Operands (-)
    2 for Operators with 2 Operands (+)
    1 - not returned here, reserved priority for leading "-" of a number
    0 for anything else (numbers, Pi, variables)
    
    Thesis: 
    Parentheses around a child operation must be set, when the priority of the parent operator is higher than
    the priority of the child operator.
*/
{
    int nrOfOperands;
    int result = 0;
    
    nrOfOperands = [self abo_deepEvaluateKindOfString:anOperandString];
    
    if (nrOfOperands == 1) {
        if ([anOperandString isEqualToString:@"x²"]) { 
            result = 6; 
        } else {
            result = 7;
        }
    } else if (nrOfOperands == 2) {
        //NSSet *prio2Operators = [[NSSet alloc] initWithObjects:@"*", @"/", nil];
        //NSSet *prio1Operators = [[NSSet alloc] initWithObjects:@"+", @"-", nil];

        if ([anOperandString isEqualToString:@"/"]) {
            result = 5;
        } else if ([anOperandString isEqualToString:@"*"]) {
            result = 4;
        } else if ([anOperandString isEqualToString:@"-"]) {
            result = 3;
        } else if ([anOperandString isEqualToString:@"+"]) {
            result = 2;
        }
    }
    
    return result;
}

+ (NSMutableArray *)replaceSignOperatorByMultiplication:(NSMutableArray *) anArray;
// replace any occurance of "+/-"-Operator-Objects by combination of "(-1)" and "*")
{
    NSMutableArray *resultArray;
    id curObjectRead;
    id curObjectWrite;
    BOOL isPlusMinus;
    
    if (anArray) {
        resultArray = [[NSMutableArray alloc] init];
    }
    
    for (curObjectRead in anArray) {
        isPlusMinus = FALSE;
        curObjectWrite = curObjectRead;
        
        if ([curObjectRead isKindOfClass:[NSString class]]) {
            if ([curObjectRead isEqualToString:@"+/-"]) isPlusMinus = TRUE;
        }
        
        if (isPlusMinus) {
            [resultArray addObject:[[NSNumber alloc] initWithInt:(-1)]];
            curObjectWrite = @"*";
        }
                
        [resultArray addObject:curObjectWrite];
    }
    
    return resultArray;
}

+ (NSString *)descriptionOfProgramArray:(NSMutableArray *)stack priorityOfCaller:(int)callerPriority;
{
    NSString *myDescription = @"";
    NSString *formatHelpStringOpen = @"";
    NSString *formatHelpStringClose = @"";
    NSString *operand1 = @"";
    NSString *operand2 = @"";
    int ownPriority;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) //Number
    {
        NSNumber *myZeroNumber = [[NSNumber alloc] initWithInt:0];
        if ([(NSNumber *)topOfStack compare:myZeroNumber] == NSOrderedAscending) {
            
            ownPriority = 1;
            if (ownPriority < callerPriority) {
                formatHelpStringOpen = @"(";
                formatHelpStringClose = @")";
            } else {
                formatHelpStringOpen = @"";
                formatHelpStringClose = @"";
            }
            myDescription = [NSString stringWithFormat:@"%@%@%@", formatHelpStringOpen, [topOfStack stringValue], formatHelpStringClose];
        } else {
            myDescription = [NSString stringWithFormat:@"%@", [topOfStack stringValue]];
        }
    } 
    else if ([topOfStack isKindOfClass:[NSString class]]) 
    {
        if ([self abo_stringIsVariable:(NSString *)topOfStack]) { //Variable
            myDescription = [NSString stringWithFormat:@"%@", (NSString *)topOfStack];
        }
        else //Operation
        {
            int numberOfOperands = [self abo_numberOfOperandsNeeded:(NSString *)topOfStack];
            
            if (numberOfOperands == 0) {
                myDescription = (NSString *)topOfStack;
            }
            else {
                
                ownPriority = [self priorityOfOperandByString:(NSString *)topOfStack];
                if (ownPriority < callerPriority) {
                    formatHelpStringOpen = @"(";
                    formatHelpStringClose = @")";
                } 
                
                if (numberOfOperands == 1) {
                    operand1 = [self descriptionOfProgramArray:stack priorityOfCaller:ownPriority];
                    //if ([operand1 length] == 0) operand1 = @"0";
                    if ([operand1 length] == 0) operand1 = @"☹";

                    
                    if ([(NSString *)topOfStack isEqualToString:@"x²"]) {
                        myDescription = [NSString stringWithFormat:@"%@%@%@^2", formatHelpStringOpen, operand1, formatHelpStringClose];

                    } else {
                        operand1 = [self forceOuterParentheses:operand1];
                        
                        NSString *minusHelper = (NSString *)topOfStack;
                        if ([minusHelper isEqualToString:@"+/-"]) {
                            minusHelper = @"-";
                        } else if ([minusHelper isEqualToString:@"1/x"]) {
                            minusHelper = @"1/";
                        }
                        
                        myDescription = [minusHelper stringByAppendingString:operand1];
                    }
                    
                }
                else if (numberOfOperands == 2) {
                    operand2 = [self descriptionOfProgramArray:stack priorityOfCaller:ownPriority]; 
                    //if ([operand2 length] == 0) operand2 = @"0";
                    if ([operand2 length] == 0) operand2 = @"☹";
                    operand1 = [self descriptionOfProgramArray:stack priorityOfCaller:ownPriority];
                    //if ([operand1 length] == 0) operand1 = @"0";
                    if ([operand1 length] == 0) operand1 = @"☹";
                    
                    myDescription = [NSString stringWithFormat:@"%@%@ %@ %@%@", formatHelpStringOpen, operand1, (NSString *)topOfStack, operand2, formatHelpStringClose];
                }
            }
        }
    }

    return myDescription;
}

+ (NSString *)descriptionOfProgram:(id)program 
{
    NSString *myDescription = @"";
    NSString *strAppendOps = @", ";
    NSString *strHelper;
    NSMutableArray *stack;
    int nrOfStackObjects, nrOfCurrentLoop;

    //NSLog(@"descriptionOfProgram BEGIN");
    
    if ([program isKindOfClass:[NSArray class]]) 
    {
        stack = [self replaceSignOperatorByMultiplication:[program mutableCopy]];
        
        nrOfStackObjects = [stack count];
        nrOfCurrentLoop = 0;
        
        while ([stack count] > 0) {
            nrOfCurrentLoop++;
            
            //NSLog(@"While-Loop Nr. %i BEGIN - nrOfStackObjects=%i, myDescription='%@'", nrOfCurrentLoop, nrOfStackObjects, myDescription);
            
            strHelper = @"";
            if (nrOfCurrentLoop > 1) strHelper = strAppendOps;
            
            myDescription = [NSString stringWithFormat:@"%@%@%@", myDescription, strHelper, [self descriptionOfProgramArray:stack priorityOfCaller:0]];
            nrOfStackObjects = [stack count];
            
            //NSLog(@"While-Loop Nr. %i END - nrOfStackObjects=%i, myDescription='%@'", nrOfCurrentLoop, nrOfStackObjects, myDescription);

        }
    }

    //NSLog(@"descriptionOfProgram END - myDescription='%@'", myDescription);
    //NSLog(@" ");

    return myDescription;
}

+ (id)runProgram:(id)program
//in Assignment 1, there were no variables, so +runProgram was called from -performOperation.
//in Assignment 2, variables were introduced and +runProgram:usingVariableValues
//for that, runProgram gets wrapped into +runProgram:usingVariableValues
//and +runProgram changed to call +runProgram:usingVariablesValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    if ([stack count]) {
        return [self popOperandOffStack:stack];
    } else {
        return [NSNumber numberWithDouble:0];
    }
}

+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    if (variableValues) 
    {
        NSMutableArray *stack;
        if ([program isKindOfClass:[NSArray class]]) {
            stack = [program mutableCopy];
        }
        
        //todo: replace variables by values in stack.

        id testObject = [stack lastObject];
        if (testObject) {
            int index;
            for (index = 0; index <= ([stack count]-1); index++) {
                id stackObject = [stack objectAtIndex:index];
                if ([stackObject isKindOfClass:[NSString class]]) {
                    
                    if ([self abo_stringIsVariable:stackObject]) {
                        NSNumber *numberObject = [variableValues objectForKey:stackObject];
                        if (!numberObject) {
                            numberObject = [NSNumber numberWithDouble:0];
                        } 
                        [stack replaceObjectAtIndex:index withObject:numberObject];
                    }
                }    
            }
        }
        return [self runProgram:stack];
    }
    else 
    {
        return [self runProgram:program];
    }    
}
    

- (void)clearCalculatorBrain
{
    [self.programStack removeAllObjects];
    //[self.dictVariableValues removeAllObjects];
    /* commented out, the as Clear should not remove the variable values.
       http://piazza.com/class#summer2012/codingtogether/1151 
    */
}

@end
