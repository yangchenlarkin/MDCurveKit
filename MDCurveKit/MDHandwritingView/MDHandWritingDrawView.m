//
//  MDHandWritingDrawView.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDHandWritingDrawView.h"
#import "MDCurves.h"

@interface MDHandWritingDrawView () {
  CGPoint _lastPoint;
  MDPointPair *_lastPointPair;
  MDBezierCurve *_drawingBezierCurve;
}

@end

@implementation MDHandWritingDrawView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:gesture];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
  CGPoint point = [panGesture locationInView:self];
  if (panGesture.state == UIGestureRecognizerStateBegan) {
    _lastPoint = point;
  }
  if (panGesture.state == UIGestureRecognizerStateChanged) {
    [self addPoint:point];
  }
  if (panGesture.state == UIGestureRecognizerStateEnded) {
    [self addPoint:point];
    if (_drawingBezierCurve) {
      [self.delegate handWritingDrawView:self didDrawStroke:_drawingBezierCurve];
    } else {
      
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
  _drawingBezierCurve = nil;
  [self setNeedsDisplay];
}

- (MDPointPair *)pointPairWithLastPoint:(CGPoint)lastPoint currentPoint:(CGPoint)currentPoint {
  CGPoint centerPoint = CGPointMake((lastPoint.x + currentPoint.x) / 2, (lastPoint.y + currentPoint.y) / 2);
  return [MDPointPair pointPairWithStartPoint:centerPoint controlPoint:currentPoint];
}

- (void)addPoint:(CGPoint)point {
  MDPointPair *currentPointPair = [self pointPairWithLastPoint:_lastPoint currentPoint:point];
  if (_lastPointPair) {
    if (!_drawingBezierCurve) {
      _drawingBezierCurve = [[MDBezierCurve alloc] initWithStartPointPair0:_lastPointPair pointPair1:currentPointPair];
    } else {
      [_drawingBezierCurve addPointPair:currentPointPair];
    }
  }
  _lastPoint = point;
  _lastPointPair = currentPointPair;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineCap(context, kCGLineCapRound);
  if (self.isDashed) {
    CGFloat dashPattern[2] = {10, 10};
    CGContextSetLineDash(context, 0, dashPattern, 2);
  }
  CGContextSetLineWidth(context, 2);
  if (self.strokeColor) {
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  }
  if (self.strokeWidth) {
    CGContextSetLineWidth(context, self.strokeWidth);
  }
  [_drawingBezierCurve drawInCurrentContext];
}

@end
