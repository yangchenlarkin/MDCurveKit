//
//  MDBrokenLineCurve.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDCurve.h"

@class MDPoint;

@interface MDBrokenLineCurve : MDCurve

- (CGPathRef)CGPath NS_RETURNS_INNER_POINTER;

- (id)initWithStartPointPair:(MDPointPair *)pointPair;

- (void)addPoint:(MDPoint *)point;
- (void)addPoints:(NSArray *)points;

- (void)drawInContext:(CGContextRef)context;
- (void)drawInCurrentContext;

@end
