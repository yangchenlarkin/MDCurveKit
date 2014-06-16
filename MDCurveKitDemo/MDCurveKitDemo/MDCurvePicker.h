//
//  MDCurvePicker.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDCurve;

typedef void (^MDCurvePickerBlock)(MDCurve *curve);

@interface MDCurvePicker : NSObject

- (id)initWithBlock:(MDCurvePickerBlock)block;

- (void)pickInViewController:(UIViewController *)viewController;

+ (NSArray *)curves;

@end
