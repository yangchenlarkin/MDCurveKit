//
//  MDDemoView.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/27/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDDemoView.h"
#import "MDCurve.h"
#import "mach/mach_time.h"

#define pointCount 200

@implementation MDDemoView

@synthesize curve = _curve;

- (MDCurve *)curve {
  return _curve ?: (_curve = [[MDCurve alloc] init]);
}

- (void)setCurve:(MDCurve *)curve {
  _curve = curve;
  [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)setCurveFunction:(MDCurvePointFuction)function {
  self.curve.curveFuction = function;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  [self.curve drawInCurrentContextWithStep:10000];
  
  uint64_t start = mach_absolute_time();
  
  for (int i = 0; i < pointCount; i++) {
    CGPoint p = [self.curve pointWithUniformT:(i + 1.) / pointCount];
    [self drawPointAtPoint:p];
  }
  uint64_t end = mach_absolute_time();
  uint64_t elapsed = end - start;
  
  mach_timebase_info_data_t info;
  if (mach_timebase_info (&info) != KERN_SUCCESS) {
    printf ("mach_timebase_info failed\n");
  }
  
  uint64_t nanosecs = elapsed * info.numer / info.denom;
  uint64_t millisecs = nanosecs / 1000000;
  NSLog(@"绘制用时：%llu", millisecs);
  [self drawPoints];
}

- (void)drawPoints {
  //参考用时
  uint64_t start = mach_absolute_time();
  
  for (int i = 0; i < pointCount; i++) {
    [self drawPointAtPoint:CGPointMake(1, 1)];
  }
  uint64_t end = mach_absolute_time();
  uint64_t elapsed = end - start;
  
  mach_timebase_info_data_t info;
  if (mach_timebase_info (&info) != KERN_SUCCESS) {
    printf ("mach_timebase_info failed\n");
  }
  
  uint64_t nanosecs = elapsed * info.numer / info.denom;
  uint64_t millisecs = nanosecs / 1000000;
  NSLog(@"绘制参考点用时(无MDCurve运算情况下，绘制相同数量点的时间)：%llu", millisecs);
}

- (void)drawPointAtPoint:(CGPoint)point {
  CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(point.x - 1, point.y - 1, 2, 2));
}

@end
