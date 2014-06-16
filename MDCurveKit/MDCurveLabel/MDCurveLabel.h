//
//  MDCurveLabel.h
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 4/25/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCurve.h"

@interface MDCurveLabel : UIView

@property (nonatomic, strong) MDCurve *curve;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic, assign) double startOffset;

@end
