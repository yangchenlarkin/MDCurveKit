//
//  MDHandwritingView.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHandwritingView : UIView

/**
 *  type: MDCurve;
 */
@property (nonatomic, readonly) NSArray *strokes;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;

@property (nonatomic, assign, getter = isDrawingWithDashed) BOOL drawingWithDashed;


//四种操作：增、删、撤销最后一笔、重画取消掉的最后一笔

/**
 *  增加笔画
 *
 *  @param objects strokes
 */
- (void)addStrokes:(NSArray *)strokes;

/**
 *  删除笔画
 *
 *  @param strokes strokes
 */
- (void)removeStrokes:(NSArray *)strokes;

/**
 *  撤销最后一笔，可重复撤销，撤销之后可以按原来的顺序重画，但是如果执行过addStrokes或者removeStrokes方法之后，之前取消掉的笔画将不再能够重画
 */
- (void)undo;

/**
 *  只有当上一次操作是undo的时候，才可以重画
 */
- (void)redo;

@end
