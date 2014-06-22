//
//  MDPoint.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDPoint : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

+ (MDPoint *)pointWithPoint:(CGPoint)point;

@end
