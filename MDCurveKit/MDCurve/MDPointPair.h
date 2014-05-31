//
//  MDPointPair.h
//  MDCurveDemo
//
//  Created by 杨晨 on 1/2/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDPointPair : NSObject

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint controlPoint;

- (CGPoint)reverseControlPoint;

+ (MDPointPair *)pointPairWithStartPoint:(CGPoint)startPoint controlPoint:(CGPoint)controlPoint;

@end

MDPointPair *pointPairWithPoint(CGPoint startPoint,
                                CGPoint controlPoint);

MDPointPair *pointPairWithCoordinate(CGFloat startPointX,
                                     CGFloat startPointY,
                                     CGFloat controlPointX,
                                     CGFloat controlPointY);
