//
//  MDBezierCurve.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDCurve.h"

@interface MDBezierCurve : MDCurve

@property (nonatomic, assign) BOOL isCubic;

- (CGPathRef)CGPath NS_RETURNS_INNER_POINTER;

- (id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1;

- (void)addPointPair:(MDPointPair *)pointPair;
- (void)addPointPairs:(NSArray *)pointPairs;

- (void)drawInContext:(CGContextRef)context;
- (void)drawInCurrentContext;

@end
