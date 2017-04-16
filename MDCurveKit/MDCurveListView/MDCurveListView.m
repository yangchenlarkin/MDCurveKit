//
//  MDCurveListView.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 17/4/15.
//  Copyright © 2017年 剑川道长. All rights reserved.
//

#import "MDCurveListView.h"

@interface MDCurveListView ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet<MDCurveListViewCell *> *> *reusableCells;
@property (nonatomic, strong) NSMutableArray <MDCurveListViewCell *> *visibleCells;
@property (nonatomic, assign) NSInteger visibleStartCellIndex;
@property (nonatomic, assign) NSInteger visibleEndCellIndex;

@property (nonatomic, assign) CGPoint beginTouchPoint;
@property (nonatomic, assign) CGFloat beginOffset;

@end

@implementation MDCurveListView

- (MDCurveListViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    MDCurveListViewCell *cell = self.reusableCells[identifier].anyObject;
    [self.reusableCells[identifier] removeObject:cell];
    return cell;
}

- (void)setDataSource:(id<MDCurveListViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self clear];
        [self reloadData];
    }
}

- (void)setCurve:(MDCurve *)curve {
    if (_curve != curve) {
        _curve = curve;
        [self clear];
        [self reloadData];
    }
}

#pragma mark - lazyLoad

- (NSMutableDictionary<NSString *,NSMutableSet<MDCurveListViewCell *> *> *)reusableCells {
    return _reusableCells ?: (_reusableCells = [NSMutableDictionary new]);
}

- (NSMutableArray<MDCurveListViewCell *> *)visibleCells {
    return _visibleCells ?: (_visibleCells = [NSMutableArray new]);
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.beginTouchPoint = [[touches anyObject] locationInView:self];
    self.beginOffset = self.contentOffset;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _contentOffset = [self offsetWithCurrentPoint:[[touches anyObject] locationInView:self] beginPoint:self.beginTouchPoint beginOffset:self.beginOffset];
    [self reloadData];
    
    for (NSString *key in [self.reusableCells allKeys]) {
        NSLog(@"%@: \t %ld", key, self.reusableCells.count);
    }
    NSLog(@"visible: %ld", self.visibleCells.count);
    NSLog(@"------");
}

#pragma mark - clear

- (void)clear {
    self.visibleEndCellIndex = -1;
    self.visibleStartCellIndex = -1;
    for (MDCurveListViewCell *cell in self.visibleCells) {
        [cell removeFromSuperview];
    }
    self.reusableCells = nil;
    self.visibleCells = nil;
}

#pragma mark - reloadData

- (void)removeVisibleCellsFromLocation:(NSUInteger)location length:(NSUInteger)length {
    for (NSUInteger i = location; i < length + location; i++) {
        MDCurveListViewCell *cell = self.visibleCells[i];
        [cell removeFromSuperview];
        [[self reusedSetForIdentifier:cell.reuseIdentifier] addObject:cell];
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(location, length)];
    [self.visibleCells removeObjectsAtIndexes:indexSet];
}

- (void)addCellsBehindWithCount:(NSUInteger)count {
    for (int i = 0; i < count; i++) {
        MDCurveListViewCell *cell = [self cell:self.visibleEndCellIndex + 1 + i];
        [self addSubview:cell];
        [self.visibleCells addObject:cell];
    }
}

- (void)addCellsInFrontWithCount:(NSUInteger)count {
    for (int i = 0; i < count; i++) {
        MDCurveListViewCell *cell = [self cell:self.visibleStartCellIndex - 1 - i];
        [self addSubview:cell];
        [self.visibleCells insertObject:cell atIndex:0];
    }
}

- (void)newVisibleCells {
    for (NSUInteger index = self.startCellIndex; index <= self.endCellIndex; index++) {
        MDCurveListViewCell *cell = [self cell:index];
        [self addSubview:cell];
        [self.visibleCells addObject:cell];
    }
}

- (void)removeVisibleCells {
    if (self.visibleEndCellIndex < self.startCellIndex || self.visibleStartCellIndex > self.endCellIndex) {
        [self removeVisibleCellsFromLocation:0 length:self.visibleCells.count];
        return;
    }
    
    if (self.visibleStartCellIndex < self.startCellIndex) {
        [self removeVisibleCellsFromLocation:0 length:self.startCellIndex - self.visibleStartCellIndex];
    }
    if (self.visibleEndCellIndex > self.endCellIndex) {
        [self removeVisibleCellsFromLocation:self.endCellIndex + 1 - self.visibleStartCellIndex length:self.visibleEndCellIndex - self.endCellIndex];
    }
}

- (void)addVisibleCells {
    if (self.endCellIndex < self.visibleStartCellIndex || self.startCellIndex > self.visibleEndCellIndex) {
        [self newVisibleCells];
        return;
    }
    
    if (self.startCellIndex < self.visibleStartCellIndex) {
        [self addCellsInFrontWithCount:self.visibleStartCellIndex - self.startCellIndex];
    }
    if (self.endCellIndex > self.visibleEndCellIndex) {
        [self addCellsBehindWithCount:self.endCellIndex - self.visibleEndCellIndex];
    }
}

- (void)refreshPosition {
    for (NSInteger index = self.visibleStartCellIndex; index <= self.visibleEndCellIndex; index++) {
        MDCurveListViewCell *cell = self.visibleCells[index - self.visibleStartCellIndex];
        CGFloat v = [self cellOffsetOfIndex:index] / self.curve.length;
        cell.center = [self.curve pointWithUniformParameter:v];
    }
}

- (void)reloadData {
    if (!self.dataSource || !self.curve) {
        return;
    }
    if (self.visibleStartCellIndex != self.startCellIndex || self.visibleEndCellIndex != self.endCellIndex) {
        [self removeVisibleCells];
        [self addVisibleCells];
    }
    self.visibleStartCellIndex = self.startCellIndex;
    self.visibleEndCellIndex = self.endCellIndex;
    [self refreshPosition];
}

#pragma mark - 便捷函数

- (NSMutableSet <MDCurveListViewCell *> *)reusedSetForIdentifier:(NSString *)identifier {
    return self.reusableCells[identifier] ?: (self.reusableCells[identifier] = [NSMutableSet new]);
}

- (NSInteger)startCellIndex {
    CGFloat fIndex = (self.contentOffset - self.headSpace) / self.cellSpace;
    if (fIndex < 0) {
        return 0;
    }
    return fIndex + 1;
}

- (NSInteger)endCellIndex {
    CGFloat fIndex = (self.contentOffset - self.headSpace + self.curve.length) / self.cellSpace;
    if (fIndex > self.cellNumber - 1) {
        return self.cellNumber - 1;
    }
    return fIndex;
}

- (CGFloat)cellOffsetOfIndex:(NSInteger)index {
    return self.headSpace + index * self.cellSpace - self.contentOffset;
}

#pragma mark - 便捷函数

- (MDCurveListViewCell *)cell:(NSInteger)index {
    return [self.dataSource curveListView:self cellForIndex:index];
}

- (CGFloat)cellNumber {
    return [self.dataSource numberOfCellsInCurveListView:self];
}

- (CGFloat)cellSpace {
    return [self.dataSource spaceBetweenCellsInCurveListView:self];
}

- (CGFloat)headSpace {
    if ([self.dataSource respondsToSelector:@selector(headSpaceInCurveListView:)]) {
        [self.dataSource headSpaceInCurveListView:self];
    }
    return 0;
}

- (CGFloat)tailSpace {
    if ([self.dataSource respondsToSelector:@selector(tailSpaceInCurveListView:)]) {
        [self.dataSource tailSpaceInCurveListView:self];
    }
    return 0;
}

- (CGFloat)offsetWithCurrentPoint:(CGPoint)point
                       beginPoint:(CGPoint)beginPoint
                      beginOffset:(CGFloat)beginOffset {
    if ([self.dataSource respondsToSelector:@selector(curveListView:offsetForTouchPoint:beginTouchPoint:beginTouchOffset:)]) {
        return [self.dataSource curveListView:self
                        offsetForTouchPoint:point
                            beginTouchPoint:beginPoint
                           beginTouchOffset:beginOffset];
    }
    
    CGPoint d =
    [self.dataSource respondsToSelector:@selector(dragDirectionInCurveListView:)] ?
    [self.dataSource dragDirectionInCurveListView:self] :
    CGPointMake(1, 0);
    
    CGPoint deltPoint = CGPointMake(point.x - beginPoint.x, point.y - beginPoint.y);
    
    CGFloat deltOffset = d.x * deltPoint.x + d.y * deltPoint.y;
    return beginOffset + deltOffset;
}

@end
