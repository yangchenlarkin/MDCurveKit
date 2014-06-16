//
//  MDCurveDemoView.h
//  MDCurveDemo
//
//  Created by 杨晨 on 12/27/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCurve.h"

@interface MDCurveDemoView : UIView

@property (nonatomic, strong) MDCurve *curve;

- (void)setCurveFunction:(MDCurvePointFunction)function;

@end
