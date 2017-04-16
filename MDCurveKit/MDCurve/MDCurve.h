//
//  MDCurve.h
//  MDCurveDemo
//
//  Created by 杨晨 on 12/26/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPointPair.h"

typedef CGPoint(^MDCurvePointFunction)(double t);
typedef double(^MDCurveFunction)(double x);

@interface MDCurve : NSObject
/**
 *  曲线方程(x = x(t), y = y(t))，0 <= t <= 1
 */
@property (nonatomic, copy) MDCurvePointFunction curveFunction;
/**
 *  该曲线是否为贝塞尔曲线
 */
@property (nonatomic, readonly) BOOL isBezierCurve;

/**
 *  v=0点和v=1点间的曲线长度
 *  @param v uniformParameter
 *  @return length
 */
- (double)length;
/**
 *  在v位置处的坐标(x, y)，0 <= v <= 1
 *  @param v uniformParameter
 *  @return point
 */
- (CGPoint)pointWithUniformParameter:(double)v;
/**
 *  在v位置处的对t求导数（dx/dt, dy/dt），0 <= v <= 1
 *  @param v uniformParameter
 *  @return prime
 */
- (CGPoint)primePointWithUniformParameter:(double)v;
/**
 *  在v位置处的曲线单位法向量
 *  @param v uniformParameter
 *  @return prime
 */
- (CGPoint)unitNormalVectorWithUniformParameter:(double)v;
- (void)drawInContext:(CGContextRef)context step:(int)step;
- (void)drawInCurrentContextWithStep:(int)step;

@end


@interface MDBezierCurve : MDCurve

/**
 *  是否为三阶贝塞尔曲线,默认为NO，NO为二阶
 */
@property (nonatomic, assign) BOOL isCubic;
/**
 *  将贝塞尔曲线转化为CGPath
 */
@property (nonatomic, readonly) CGPathRef CGPath;

/**
 *  初始化函数，一条贝塞尔曲线至少需要两组点对
 */
- (id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1;

- (void)addPointPair:(MDPointPair *)pointPair;
- (void)addPointPairs:(NSArray *)pointPairs;

- (void)drawInContext:(CGContextRef)context;
- (void)drawInCurrentContext;

@end
