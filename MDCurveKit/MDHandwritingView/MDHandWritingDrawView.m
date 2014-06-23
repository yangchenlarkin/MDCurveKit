//
//  MDHandWritingDrawView.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDHandWritingDrawView.h"
#import "MDCurves.h"
#import "MDPoint.h"

@interface MDHandWritingDrawView () {
  NSMutableArray *_pointPairs;
  CGPoint _lastPoint;
  MDPointPair *_lastPointPair;
  id _drawingCurve;
  int _pointCount;
}

@end

@implementation MDHandWritingDrawView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _pointPairs = [NSMutableArray array];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:gesture];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
  CGPoint point = [panGesture locationInView:self];
  if (panGesture.state == UIGestureRecognizerStateBegan) {
    [self addPoint:point];
  }
  if (panGesture.state == UIGestureRecognizerStateChanged) {
    if ([MDPoint distanceBetweenPoint:point andPoint:_lastPoint] < MAX(self.strokeWidth, 10) / 2) {
      NSLog(@"mark1");
      return;
    }
    [self addPoint:point];
  }
  if (panGesture.state == UIGestureRecognizerStateEnded) {
    [self addPoint:point];
    if (_drawingCurve) {
      [self.delegate handWritingDrawView:self didDrawStroke:_drawingCurve];
    }
    [self clear];
  }
  if (panGesture.state == UIGestureRecognizerStateCancelled ||
      panGesture.state == UIGestureRecognizerStateFailed) {
    [self clear];
  }
}

- (void)clear {
  _lastPoint = CGPointZero;
  _lastPointPair = nil;
  _drawingCurve = nil;
  _pointPairs = [NSMutableArray array];
  _pointCount = 0;
  [self setNeedsDisplay];
}

- (MDPointPair *)pointPairWithLastPoint:(CGPoint)lastPoint currentPoint:(CGPoint)currentPoint {
  CGPoint centerPoint = CGPointMake((lastPoint.x + currentPoint.x) / 2, (lastPoint.y + currentPoint.y) / 2);
  return [MDPointPair pointPairWithStartPoint:centerPoint controlPoint:currentPoint];
}

- (void)addPoint:(CGPoint)point {
  _pointCount++;
  if (_pointCount == 1) {
    _lastPoint = point;
    return;
  }
  
  CGPoint currentPoint = point;
  MDPointPair *currentPointPair = _pointCount % 2 ?
  [MDPointPair pointPairWithStartPoint:point controlPoint:CGPointZero] :
  [MDPointPair pointPairWithStartPoint:_lastPoint controlPoint:point];
  
  if (_pointCount == 2) {
    _drawingCurve = [[MDBrokenLineCurve alloc] initWithPointPair:currentPointPair];
  } else if (_pointCount == 3) {
    _drawingCurve = [[MDBezierCurve alloc] initWithStartPointPair0:_lastPointPair pointPair1:currentPointPair];
  } else if (_pointCount == 4) {
    _drawingCurve = [[MDBezierCurve alloc] initWithStartPointPair0:_lastPointPair pointPair1:currentPointPair];
    ((MDBezierCurve *)_drawingCurve).isCubic = YES;
  } else if (_pointCount % 2 == 0) {
    [((MDBezierCurve *)_drawingCurve) addPointPair:currentPointPair];
  }
  
  _lastPoint = currentPoint;
  if (_pointCount % 2 == 0) {
    _lastPointPair = currentPointPair;
  }
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineCap(context, kCGLineCapRound);
  if (self.isDashed) {
    CGFloat dashPattern[2] = {10, 10 + self.strokeWidth};
    CGContextSetLineDash(context, 0, dashPattern, 2);
  }
  CGContextSetLineWidth(context, 2);
  if (self.strokeColor) {
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  }
  if (self.strokeWidth) {
    CGContextSetLineWidth(context, self.strokeWidth);
  }
  [_drawingCurve drawInCurrentContext];
}

@end
