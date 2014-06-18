//
//  MDCurve.h
//  MDCurveDemo
//
//  Created by 杨晨 on 12/26/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPointPair.h"

typedef CGPoint(^MDCurvePointFunction)(double v);
typedef double(^MDcurveFunction)(double x);

@interface MDCurve : NSObject

@property (nonatomic, copy) MDCurvePointFunction curveFunction;
@property (nonatomic, readonly) BOOL isBezierCurve;

- (double)length;
- (CGPoint)pointWithUniformParameter:(double)v;
/**
 *  在v位置处的对t求倒数（dx/dt, dy/dt）
 *
 *  @param v uniformParameter
 *
 *  @return prime
 */
- (CGPoint)primePointWithUniformParameter:(double)v;
- (void)drawInContext:(CGContextRef)context step:(int)step;
- (void)drawInCurrentContextWithStep:(int)step;

@end


@interface MDBezierCurve : MDCurve

@property (nonatomic, assign) BOOL isCubic;
@property (nonatomic, readonly) CGPathRef CGPath;

- (id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1;

- (void)addPointPair:(MDPointPair *)pointPair;
- (void)addPointPairs:(NSArray *)pointPairs;

- (void)drawInContext:(CGContextRef)context;
- (void)drawInCurrentContext;

@end
