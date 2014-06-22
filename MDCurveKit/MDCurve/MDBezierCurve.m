//
//  MDBezierCurve.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDBezierCurve.h"

@interface MDCurve (generateLengthCache)

- (void)generateLengthCache;

@end

@interface MDBezierCurve ()

@property (nonatomic, strong) NSMutableArray *pointPairs;

@end

@implementation MDBezierCurve

#pragma mark - method forbidden

- (void)setCurveFunction:(MDCurvePointFunction)curveFunction {
  NSLog(@"method %s is forbidden in MDBezierCurve", __FUNCTION__);
  assert(NO);
}

- (void)setIsCubic:(BOOL)isCubic {
  _isCubic = isCubic;
  [self updateMethod];
  [self generateLengthCache];
}

#pragma mark - method

- (id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1 {
  if (self = [super init]) {
    self.pointPairs = [NSMutableArray arrayWithObjects:pointPair0, pointPair1, nil];
    [self updateMethod];
  }
  return self;
}

- (void)addPointPair:(MDPointPair *)pointPair {
  [self.pointPairs addObject:pointPair];
  [self generateLengthCache];
}

- (void)addPointPairs:(NSArray *)pointPairs {
  [self.pointPairs addObjectsFromArray:pointPairs];
  [self generateLengthCache];
}

- (void)updateMethod {
  if (_pointPairs.count < 2) {
    return;
  }
  __weak MDBezierCurve *self_weak_ = self;
  super.curveFunction = ^(double t) {
    NSUInteger number = self_weak_.pointPairs.count - 1;//曲线段数
    if (t >= 1) {
      return [self_weak_ pointWithT:1. inIndex:number - 1];
    }
    t = t * number;
    int index = (int)t;
    t = t - index;
    return [self_weak_ pointWithT:t inIndex:index];
  };
}

- (CGPathRef)CGPath {
  CGMutablePathRef path = CGPathCreateMutable();
  MDPointPair *pointPair = self.pointPairs[0];
  CGPoint startPoint = pointPair.startPoint;
  CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
  for (int index = 1; index < self.pointPairs.count; index++) {
    MDPointPair *lastPointPair = self.pointPairs[index - 1];
    MDPointPair *pointPair = self.pointPairs[index];
    if (self.isCubic) {
      CGPathAddCurveToPoint(path, NULL,
                            lastPointPair.controlPoint.x,
                            lastPointPair.controlPoint.y,
                            pointPair.reverseControlPoint.x,
                            pointPair.reverseControlPoint.y,
                            pointPair.startPoint.x,
                            pointPair.startPoint.y);
    } else {
      CGPathAddQuadCurveToPoint(path, NULL,
                                lastPointPair.controlPoint.x,
                                lastPointPair.controlPoint.y,
                                pointPair.startPoint.x,
                                pointPair.startPoint.y);
    }
  }
  return path;
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

#pragma mark - calculate method

- (CGPoint)pointWithT:(CGFloat)t inIndex:(NSUInteger)index {
  if (index > _pointPairs.count - 2) {
    return CGPointZero;
  }
  t = MAX(0, MIN(1, t));
  MDPointPair *pointPair0 = _pointPairs[index];
  MDPointPair *pointPair1 = _pointPairs[index + 1];
  CGPoint p0 = pointPair0.startPoint;
  CGPoint p1 = pointPair0.controlPoint;
  CGPoint p2 = pointPair1.reverseControlPoint;
  CGPoint p3 = pointPair1.startPoint;
  
  CGFloat it = 1 - t;
  
  CGFloat x, y;
  if (self.isCubic) {
    x =
    p0.x * it * it * it +
    3 * p1.x * t * it * it +
    3 * p2.x * t * t * it +
    p3.x * t * t * t;
    
    y =
    p0.y * it * it * it +
    3 * p1.y * t * it * it +
    3 * p2.y * t * t * it +
    p3.y * t * t * t;
  } else {
    x =
    p0.x * it * it +
    2 * p1.x * it * t +
    p3.x * t * t;
    
    y =
    p0.y * it * it +
    2 * p1.y * it * t +
    p3.y * t * t;
  }
  return CGPointMake(x, y);
}

@end
