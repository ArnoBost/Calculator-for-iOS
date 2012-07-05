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

@end



@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)pushOperand: (double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}


- (double)performOperation: (NSString *) operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program 
{
    return [self.programStack copy];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack 
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"-" isEqualToString:operation]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([@"/" isEqualToString:operation]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([@"sin" isEqualToString:operation]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([@"cos" isEqualToString:operation]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([@"log" isEqualToString:operation]) {
            double logOperand = [self popOperandOffStack:stack];
            if (logOperand > 0.0) {
                result = log10(logOperand);
            }
        } else if ([@"√" isEqualToString:operation]) {
            double sqrtOperand = [self popOperandOffStack:stack];
            if (sqrtOperand > 0.0) result = sqrt(sqrtOperand);
        } else if ([@"π" isEqualToString:operation]) {
            result = M_PI;
        } else if ([@"x²" isEqualToString:operation]) {
            double quadratZahl = [self popOperandOffStack:stack];
            result = quadratZahl * quadratZahl;
        } else if ([@"+/-" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * (-1);
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program 
{
    return @"Implement this in Assignment 2";
}

+ (double)runProgram:(id)program 
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}
    

- (void)clearCalculatorBrain
{
    [self.programStack removeAllObjects];
}

@end
