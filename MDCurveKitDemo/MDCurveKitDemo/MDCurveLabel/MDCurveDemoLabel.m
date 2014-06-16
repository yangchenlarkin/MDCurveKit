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
  CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor redColor].CGColor);
  [self drawPointAtPoint:self.curve.curveFunction(0)];
  [self drawPointAtPoint:self.curve.curveFunction(1)];
  [self.curve drawInCurrentContextWithStep:100];
  [super drawRect:rect];
}

- (void)drawPointAtPoint:(CGPoint)point {
  CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(point.x - 1, point.y - 1, 10, 10));
}

@end
