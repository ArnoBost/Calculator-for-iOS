//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Arno Bost on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (id)performOperation:(NSString *)operation;
- (void)clearCalculatorBrain;
- (BOOL)pushVariable:(NSString *)nameOfVariable;
- (void)setVariableValues:(NSDictionary *)variableValues;
- (NSNumber *)getVariableValue:(NSString *)variableName;
- (void)removeTopItemFromProgram;


@property (readonly) id program;
@property (readonly) id variables;
+ (id)runProgram:(id)program; //doesn't calculate Variables
+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
