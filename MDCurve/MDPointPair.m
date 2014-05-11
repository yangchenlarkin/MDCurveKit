//
//  MDPointPair.m
//  MDCurveDemo
//
//  Created by 杨晨 on 1/2/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDPointPair.h"

@implementation MDPointPair

- (CGPoint)reverseControlPoint {
  return CGPointMake(2 * self.startPoint.x - self.controlPoint.x,
                     2 * self.startPoint.y - self.controlPoint.y);
}

+ (MDPointPair *)pointPairWithStartPoint:(CGPoint)startPoint controlPoint:(CGPoint)controlPoint {
  MDPointPair *pointPair = [[MDPointPair alloc] init];
  pointPair.startPoint = startPoint;
  pointPair.controlPoint = controlPoint;
  return pointPair;
}

@end

MDPointPair *pointPairWithPoint(CGPoint startPoint,
                                CGPoint controlPoint) {
  return [MDPointPair pointPairWithStartPoint:startPoint
                                 controlPoint:controlPoint];
}

MDPointPair *pointPairWithCoordinate(CGFloat startPointX,
                                     CGFloat startPointY,
                                     CGFloat controlPointX,
                                     CGFloat controlPointY) {
  return pointPairWithPoint(CGPointMake(startPointX, startPointY),
                            CGPointMake(controlPointX, controlPointY));
}
