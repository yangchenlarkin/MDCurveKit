//
//  MDCurveDemoLabel.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDCurveDemoLabel.h"

@implementation MDCurveDemoLabel

- (void)drawRect:(CGRect)rect {
  [self.curve drawInCurrentContextWithStep:100];
  [super drawRect:rect];
}

@end
