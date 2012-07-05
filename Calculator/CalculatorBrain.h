//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Arno Bost on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand: (double) operand;
- (double) performOperation: (NSString *) operation;
- (void) clearCalculatorBrain;

@property (readonly) id program;
+ (double) runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
