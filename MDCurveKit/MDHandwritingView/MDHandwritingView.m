//
//  MDHandwritingView.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDHandwritingView.h"
#import "MDCurves.h"
#import "MDHandWritingDrawView.h"

@interface MDHandwritingView () <MDHandWritingDrawViewDelegate>

@property (nonatomic, readonly) NSMutableArray *allStrokes;
@property (nonatomic, assign) NSUInteger showStrokeCount;
@property (nonatomic, strong) MDHandWritingDrawView *drawView;

@end

@implementation MDHandwritingView

@synthesize allStrokes = _allStrokes;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.drawView = [[MDHandWritingDrawView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:self.drawView];
    self.drawView.delegate = self;
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  self.drawView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setStrokeColor:(UIColor *)strokeColor {
  _strokeColor = strokeColor;
  self.drawView.strokeColor = strokeColor;
  [self setNeedsDisplay];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
  _strokeWidth = strokeWidth;
  self.drawView.strokeWidth = strokeWidth;
  [self setNeedsDisplay];
}

- (BOOL)isDrawingWithDashed {
  return self.drawView.isDashed;
}

- (void)setDrawingWithDashed:(BOOL)drawingWithDashed {
  self.drawView.dashed = drawingWithDashed;
}

- (NSMutableArray *)allStrokes {
  return _allStrokes ?: (_allStrokes = [NSMutableArray array]);
}

- (NSArray *)strokes {
  return [self.allStrokes subarrayWithRange:NSMakeRange(0, self.showStrokeCount)];
}

- (void)removeStrokes:(NSArray *)objects {
  _allStrokes = self.strokes.mutableCopy;
  [self.allStrokes removeObjectsInArray:objects];
  self.showStrokeCount = self.allStrokes.count;
  [self setNeedsDisplay];
}

- (void)addStrokes:(NSArray *)objects {
  _allStrokes = self.strokes.mutableCopy;
  [self.allStrokes addObjectsFromArray:objects];
  self.showStrokeCount = self.allStrokes.count;
  [self setNeedsDisplay];
}

- (void)undo {
  if (self.showStrokeCount > 0) {
    self.showStrokeCount--;
    [self setNeedsDisplay];
  }
}

- (void)redo {
  if (self.showStrokeCount < self.allStrokes.count) {
    self.showStrokeCount++;
    [self setNeedsDisplay];
  }
}

- (void)handWritingDrawView:(MDHandWritingDrawView *)drawView didDrawStroke:(MDCurve *)curve {
  [self addStrokes:@[curve]];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineCap(context, kCGLineCapRound);
  if (self.strokeColor) {
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
  }
  if (self.strokeWidth) {
    CGContextSetLineWidth(context, self.strokeWidth);
  }
  for (MDCurve *curve in self.strokes) {
    [curve drawInCurrentContextWithStep:100];
  }
}

@end
