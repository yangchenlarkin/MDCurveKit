//
//  MDCurveListView.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 17/4/15.
//  Copyright © 2017年 剑川道长. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCurve.h"
#import "MDCurveListViewCell.h"

@class MDCurveListView;

@protocol MDCurveListViewDelegate <NSObject>
@optional


@end

@protocol MDCurveListViewDataSource <NSObject>
@required
- (MDCurveListViewCell *)curveListView:(MDCurveListView *)listView cellForIndex:(NSInteger)index;
- (NSInteger)numberOfCellsInCurveListView:(MDCurveListView *)listView;
- (CGFloat)spaceBetweenCellsInCurveListView:(MDCurveListView *)listView;

@optional
- (CGFloat *)headSpaceInCurveListView:(MDCurveListView *)listView;
- (CGFloat *)tailSpaceInCurveListView:(MDCurveListView *)listView;

/**
 *  拖动的方向，默认（1， 0），该矢量长度决定了拖动速度缩放比例。比如，当返回（10，0）时，手指每在x方向上移动1px，offset将会增加10px。
 *  该协议会被curveListView:offsetForTouchPoint:beginTouchPoint:beginTouchOffset:协议所屏蔽。
 */
- (CGPoint)dragDirectionInCurveListView:(MDCurveListView *)listView;

/**
 *  自定义拖动方案，如果实现了该方法，将屏蔽dragDirectionInCurveListView:协议
 *  point：当前手指移动到的位置
 *  beginPoint：开始拖动时的位置
 *  beginOffset：开始拖动时，listView的offset值
 */
- (CGFloat)curveListView:(MDCurveListView *)listView
     offsetForTouchPoint:(CGPoint)point
         beginTouchPoint:(CGPoint)beginPoint
        beginTouchOffset:(CGFloat)beginOffset;

@end

@interface MDCurveListView : UIView

@property (nonatomic, weak) id<MDCurveListViewDelegate> delegate;
@property (nonatomic, weak) id<MDCurveListViewDataSource> dataSource;

@property (nonatomic, readonly) CGFloat contentOffset;
@property (nonatomic, readonly) CGFloat contentLength;
@property (nonatomic, strong) MDCurve *curve;

- (MDCurveListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end
