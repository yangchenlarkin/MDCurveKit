//
//  MDBrokenLineCurve.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDBrokenLineCurve.h"
#import "MDPoint.h"

@interface MDCurve (MDBrokenLineCurve)

- (void)generateLengthCache;

@end

@interface MDBrokenLineCurve ()

@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation MDBrokenLineCurve

- (id)initWithStartPointPair:(MDPointPair *)pointPair {
  if (self = [super init]) {
    self.points = @[[MDPoint pointWithPoint:pointPair.startPoint],
                    [MDPoint pointWithPoint:pointPair.controlPoint]].mutableCopy;
    [self updateMethod];
  }
  return self;
}

- (CGPathRef)CGPath {
  CGMutablePathRef path = CGPathCreateMutable();
  MDPoint *point = self.points[0];
  CGPathMoveToPoint(path, NULL, point.x, point.y);
  for (int i = 1; i < self.points.count; i++) {
    MDPoint *point = self.points[0];
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
  }
  return path;
}

- (void)addPoint:(MDPoint *)point {
  [self.points addObject:point];
  [self generateLengthCache];
}

- (void)addPoints:(NSArray *)points {
  [self.points addObjectsFromArray:points];
  [self generateLengthCache];
}

- (void)drawInContext:(CGContextRef)context {
  CGContextAddPath(context, self.CGPath);
  CGContextStrokePath(context);
}

- (void)drawInCurrentContext {
  [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context step:(int)step {
  [self drawInContext:context];
}

- (void)drawInCurrentContextWithStep:(int)step {
  [self drawInCurrentContext];
}

- (void)updateMethod {
  if (self.points.count < 2) {
    return;
  }
  __weak MDBrokenLineCurve *self_weak_ = self;
  super.curveFunction = ^(double t) {
    NSUInteger number = self_weak_.points.count - 1;//曲线段数
    if (t >= 1) {
      return [self_weak_ pointWithT:1. inIndex:number - 1];
    }
    t = t * number;
    int index = (int)t;
    t = t - index;
    return [self_weak_ pointWithT:t inIndex:index];
  };
}

- (CGPoint)pointWithT:(CGFloat)t inIndex:(NSUInteger)index {
  if (index > self.points.count - 2) {
    return CGPointZero;
  }
  t = MAX(0, MIN(1, t));
  CGFloat it = 1- t;
  CGFloat x, y;
  MDPoint *point0 = self.points[index];
  MDPoint *point1 = self.points[index + 1];
  x = point0.x * it + point1.x * t;
  y = point0.y * it + point1.y * t;
  return CGPointMake(x, y);
}

@end
