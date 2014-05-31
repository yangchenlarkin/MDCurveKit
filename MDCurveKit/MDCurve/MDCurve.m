//
//  MDCurve.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/26/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDCurve.h"

#define cacheSize 250

#define deviation 0.00001
#define doubleEqual(a,b) ((a - b) < deviation && (b - a) < deviation)

@interface MDCurve () {
  double _lengthWithTList[cacheSize];
}

@end

@implementation MDCurve

- (BOOL)isBezierCurve {
  return NO;
}

- (CGPoint)pointWithUniformT:(double)v {
  double t = [self t_v:v];
  return CGPointMake([self x:t], [self y:t]);
}

- (CGPoint)primePointWithUniformT:(double)v {
  double t = [self t_v:v];
  return CGPointMake([self dx_dt:t], [self dy_dt:t]);
}

- (void)drawInContext:(CGContextRef)context step:(int)step {
  CGContextMoveToPoint(context, [self x:0], [self y:0]);
  for (int i = 0; i < step; i++) {
    double t = (i + 1.) / step;
    CGContextAddLineToPoint(context, [self x:t], [self y:t]);
  }
  CGContextStrokePath(context);
}

- (void)drawInCurrentContextWithStep:(int)step {
  [self drawInContext:UIGraphicsGetCurrentContext() step:step];
}

#pragma mark - setter

- (void)setCurveFuction:(MDCurvePointFuction)curveFuction {
  _curveFuction = [curveFuction copy];
  [self generateLengthCache];
}

- (double)length {
  return _lengthWithTList[cacheSize - 1];
}

#pragma mark - math

- (void)generateLengthCache {
  double len = 0.;
  for (int i = 0; i < cacheSize; i++) {
    double tx = i / (double)cacheSize;
    double delt = 1 / (double)cacheSize;
    len += delt * [self gradient_t:tx + delt / 2];
    _lengthWithTList[i] = len;
  }
}

- (double)x:(double)t {
  if (self.curveFuction) {
    return self.curveFuction(t).x;
  }
  return 0;
}

- (double)y:(double)t {
  if (self.curveFuction) {
    return self.curveFuction(t).y;
  }
  return 0;
}

- (double)dx_dt:(double)t {
  if (t < deviation) {
    return ([self x:deviation] - [self x:0]) / deviation;
  } else if (t > 1 - deviation) {
    return ([self x:1] - [self x:1 - deviation]) / deviation;
  } else {
    return ([self x:t + deviation] - [self x:t - deviation]) / deviation / 2;
  }
}

- (double)dy_dt:(double)t {
  if (t < deviation) {
    return ([self y:deviation] - [self y:0]) / deviation;
  } else if (t > 1 - deviation) {
    return ([self y:1] - [self y:1 - deviation]) / deviation;
  } else {
    return ([self y:t + deviation] - [self y:t - deviation]) / deviation / 2;
  }
}

- (double)gradient_t:(double)t {
  return hypot([self dx_dt:t], [self dy_dt:t]);
}

- (double)s_t:(double)t {
  if (t <= 0) {
    return 0;
  }
  if (t > 1) {
    t = 1;
  }
  if (doubleEqual(t, 1)) {
    return self.length;
  }
  int index = (int)(t * cacheSize);
  double percent = t * cacheSize - index;
  double lenMin = index == 0 ? 0 : _lengthWithTList[index - 1];
  double lenMax = _lengthWithTList[index];
  return percent * lenMax + (1 - percent) * lenMin;
}

- (double)v_t:(double)t {
  if (t >= 1) {
    return 1;
  }
  if (t <= 0) {
    return 0;
  }
  return [self s_t:t] / self.length;
}

- (double)dv_dt:(double)t {
  if (t < deviation) {
    return ([self v_t:deviation] - [self v_t:0]) / deviation;
  } else if (t > 1 - deviation) {
    return ([self v_t:1] - [self v_t:1 - deviation]) / deviation;
  } else {
    return ([self v_t:t + deviation] - [self v_t:t - deviation]) / deviation / 2;
  }
}

- (double)t_v:(double)v {
  if (!self.curveFuction) {
    return 0;
  }
  if (v <= 0) {
    return 0;
  }
  if (v >= 1) {
    return 1;
  }
  //在不动点处直接返回
  if (doubleEqual([self v_t:v], v)) {
    return v;
  }
  double t = 0.5, testingV = [self v_t:0.5];
  double bigT = 1.0, smallT = 0.0;
  do {
    if (testingV > v) {
      bigT = t;
    } else {
      smallT = t;
    }
    t = (bigT + smallT) / 2.;
    testingV = [self v_t:t];
  } while (!doubleEqual(v, testingV));
  return t;
}

@end



@interface MDBezierCurve ()

@property (nonatomic, strong) NSMutableArray *pointPairs;

@end

@implementation MDBezierCurve

#pragma mark - method forbidden

- (void)setCurveFuction:(MDCurvePointFuction)curveFuction {
  NSLog(@"method %s is forbidden in MDBezierCurve", __FUNCTION__);
  assert(NO);
}

- (void)setIsCubic:(BOOL)isCubic {
  _isCubic = isCubic;
  [self updateMethod];
  [self generateLengthCache];
}

#pragma mark - method

- (BOOL)isBezierCurve {
  return YES;
}

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
  super.curveFuction = ^(double t) {
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
