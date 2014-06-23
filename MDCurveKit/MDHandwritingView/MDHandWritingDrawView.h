//
//  MDHandWritingDrawView.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDHandWritingDrawViewDelegate;
@class MDCurve;
@class MDHandwritingView;

@interface MDHandWritingDrawView : UIView

@property (nonatomic, weak) id<MDHandWritingDrawViewDelegate> delegate;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign, getter = isDashed) BOOL dashed;

@end

@protocol MDHandWritingDrawViewDelegate <NSObject>

- (void)handWritingDrawView:(MDHandWritingDrawView *)drawView didDrawStroke:(MDCurve *)bezierCurve;

@end
