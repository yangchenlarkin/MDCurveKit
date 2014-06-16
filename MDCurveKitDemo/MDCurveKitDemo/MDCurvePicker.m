//
//  MDCurvePicker.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDCurvePicker.h"
#import "MDCurve.h"

@interface MDCurvePicker () <UIActionSheetDelegate> {
  MDCurvePickerBlock _block;
}

@property (nonatomic, strong) UIActionSheet *sheet;

@end

@implementation MDCurvePicker

+ (NSArray *)curves {
  static NSArray *array = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    array =
    @[[self curve0],
      [self curve1],
      [self curve2],
      [self curve3],
      [self curve4],
      [self curve5],
      [self curve6],
      [self curve7],
      [self curve8],
      [self curve9],
      [self curve10],
      [self curve11],
      ];
  });
  return array;
}

- (UIActionSheet *)sheet {
  return _sheet ?:
  (_sheet = [[UIActionSheet alloc] initWithTitle:@"选择曲线"
                                        delegate:self
                               cancelButtonTitle:@"cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:
             @"圆",
             @"正弦曲线",
             @"心型",
             @"螺旋线",
             @"椭圆螺旋线",
             @"8字",
             @"歪8字",
             @"奇怪的8字",
             @"直线",
             @"分段函数（长方形）",
             @"贝塞尔曲线（2次）",
             @"贝塞尔曲线（3次）", nil]);
}

- (id)initWithBlock:(MDCurvePickerBlock)block {
  if (self = [super init]) {
    _block = [block copy];
  }
  return self;
}

- (void)pickInViewController:(UIViewController *)viewController {
  [self.sheet showInView:viewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex < [self.class curves].count && _block) {
    _block([self.class curves][buttonIndex]);
  }
}

/**
 *  圆
 */
+ (MDCurve *)curve0 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction = ^(double t) {
    return CGPointMake(160 + 150 * cos(t * 2 * M_PI), 250 + 150 * sin(t * 2 * M_PI));
  };
  return curve;
}

/*
 *正弦曲线
 */
+ (MDCurve *)curve1 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(320 * t, 150 * sin(t * 2 * M_PI) + 260);
  };
  return curve;
}


/*
 *心型
 */
+ (MDCurve *)curve2 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(200 * sin(t * M_PI) * sin(t * 2 * M_PI) + 160,
                       -200 * sin(t * M_PI) * cos(t * 2 * M_PI) + 160);
  };
  return curve;
}


/**
 *  螺旋线
 */
+ (MDCurve *)curve3 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(180 * t * sin(t * 4 * M_PI) + 180,
                       180 * t * cos(t * 4 * M_PI) + 300);
  };
  return curve;
}


/**
 *  椭圆螺旋线
 */
+ (MDCurve *)curve4 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(100 * t * sin(t * 4 * M_PI) + 160,
                       200 * t * cos(t * 4 * M_PI) + 300);
  };
  return curve;
}


/**
 *  8字
 */
+ (MDCurve *)curve5 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(150 * sin(t * 4 * M_PI) + 160,
                       200 * cos(t * 2 * M_PI) + 300);
  };
  return curve;
}


/**
 *  歪8字
 */
+ (MDCurve *)curve6 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(150 * t * sin(t * 4 * M_PI) + 160,
                       200 * cos(t * 2 * M_PI) + 300);
  };
  return curve;
}


/**
 *  呵呵8字
 */
+ (MDCurve *)curve7 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(150 * t * sin(t * 4 * M_PI) + 160,
                       200 * t * cos(t * 2 * M_PI) + 300);
  };
  return curve;
}


/**
 *  直线
 */
+ (MDCurve *)curve8 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    return CGPointMake(300 * t + 10,
                       300 * t + 100);
  };
  return curve;
}


/**
 *  分段函数
 */

+ (MDCurve *)curve9 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFunction =  ^(double t) {
    CGFloat x = 10;
    CGFloat y = 100;
    CGFloat width = 300;
    CGFloat height = 400;
    if (t <= 0.25) {
      return CGPointMake(x, y + t * height / 0.25);
    }
    if (t <= 0.5) {
      return CGPointMake(x + (t - .25) * width / 0.25, y + height);
    }
    if (t <= 0.75) {
      return CGPointMake(x + width, y + height - (t - 0.5) * height / 0.25);
    }
    return CGPointMake(x + width - (t - 0.75) * width / 0.25, y);
  };
  return curve;
}

/**
 *  贝塞尔曲线（三次）
 */
+ (MDCurve *)curve10 {
  MDBezierCurve *curve = [[MDBezierCurve alloc] initWithStartPointPair0:pointPairWithCoordinate(0, 20, 320, 60)
                                                             pointPair1:pointPairWithCoordinate(100, 100, 0, 160)];
  [curve addPointPairs:@[pointPairWithCoordinate(300, 200, 200, 250),
                         pointPairWithCoordinate(30, 200, 20, 250),
                         pointPairWithCoordinate(130, 20, 220, 50),
                         pointPairWithCoordinate(220, 400, 20, 400),
                         pointPairWithCoordinate(30, 400, -220, 203)]];
  return curve;
}

/**
 *  贝塞尔曲线（三次）
 */
+ (MDCurve *)curve11 {
  MDBezierCurve *curve = [[MDBezierCurve alloc] initWithStartPointPair0:pointPairWithCoordinate(0, 20, 320, 60)
                                                             pointPair1:pointPairWithCoordinate(100, 100, 0, 160)];
  [curve addPointPairs:@[pointPairWithCoordinate(300, 200, 200, 250),
                         pointPairWithCoordinate(30, 200, 20, 250),
                         pointPairWithCoordinate(130, 20, 220, 50),
                         pointPairWithCoordinate(220, 400, 20, 400),
                         pointPairWithCoordinate(30, 400, -220, 203)]];
  curve.isCubic = YES;
  return curve;
}

@end
