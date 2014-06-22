//
//  MDPoint.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDPoint.h"

@implementation MDPoint

+ (MDPoint *)pointWithPoint:(CGPoint)point {
  MDPoint *p = [[self alloc] init];
  p.point = point;
  return p;
}

- (CGFloat)x {
  return self.point.x;
}

- (void)setX:(CGFloat)x {
  CGPoint point = self.point;
  point.x = x;
  self.point = point;
}

- (CGFloat)y {
  return self.point.y;
}

- (void)setY:(CGFloat)y {
  CGPoint point = self.point;
  point.y = y;
  self.point = point;
}

@end
