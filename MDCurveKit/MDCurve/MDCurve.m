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

- (CGPoint)pointWithUniformParameter:(double)v {
  double t = [self t_v:v];
  return CGPointMake([self x:t], [self y:t]);
}

- (CGPoint)primePointWithUniformParameter:(double)v {
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

- (void)setCurveFunction:(MDCurvePointFunction)curveFunction {
  _curveFunction = [curveFunction copy];
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
  if (self.curveFunction) {
    return self.curveFunction(t).x;
  }
  return 0;
}

- (double)y:(double)t {
  if (self.curveFunction) {
    return self.curveFunction(t).y;
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
  if (!self.curveFunction) {
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
