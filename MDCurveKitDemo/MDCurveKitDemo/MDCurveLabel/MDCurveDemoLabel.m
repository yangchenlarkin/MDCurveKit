//
//  MDCurveDemoLabel.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDCurveDemoLabel.h"
#import "MDCurveKit.h"

@implementation MDCurveDemoLabel

- (void)drawRect:(CGRect)rect {
  [self.curve drawInCurrentContextWithStep:100];
  [super drawRect:rect];
}

- (void)drawPointAtPoint:(CGPoint)point {
  CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(point.x - 1, point.y - 1, 10, 10));
}

@end
