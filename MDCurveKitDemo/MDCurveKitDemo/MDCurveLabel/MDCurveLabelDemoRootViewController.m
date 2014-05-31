//
//  MDCurveLabelDemoRootViewController.m
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 4/25/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDCurveLabelDemoRootViewController.h"
#import "MDCurveLabel.h"
#import <CoreText/CoreText.h>

@implementation MDCurveLabelDemoRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  MDCurveLabel *label = [[MDCurveLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  label.curve = [self curve];
  label.attributedString = [self string];
  label.startOffset = 0.03;
  label.backgroundColor = [UIColor yellowColor];
  
  [self.view addSubview:label];
}

#pragma mark - curve

- (MDCurve *)curve {
  return [self curve1];
}

#pragma mark - NSAttributedString

- (NSAttributedString *)string {
  NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"testing a very very very very very very very very very very very very very very very very very very very very very long word"];
  
  //颜色
  [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:[UIColor redColor]
                      range:NSMakeRange(0, 15)];
  [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:[UIColor brownColor]
                      range:NSMakeRange(15, 15)];
  [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:[UIColor blueColor]
                      range:NSMakeRange(30, 15)];
  [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:[UIColor greenColor]
                      range:NSMakeRange(45, 15)];
  [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:[UIColor grayColor]
                      range:NSMakeRange(60, 15)];
  
  //字体
  [attriString addAttribute:(NSString *)kCTFontAttributeName
                      value:[UIFont systemFontOfSize:19]
                      range:NSMakeRange(0, 20)];
  [attriString addAttribute:(NSString *)kCTFontAttributeName
                      value:[UIFont systemFontOfSize:12]
                      range:NSMakeRange(20, 20)];
  [attriString addAttribute:(NSString *)kCTFontAttributeName
                      value:[UIFont boldSystemFontOfSize:16]
                      range:NSMakeRange(40, 20)];
  return attriString;
}

#pragma mark - 曲线

//心形，其他曲线请参考MDCurve:https://github.com/yangchenlarkin/MDCurve
- (MDCurve *)curve0 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFuction = ^(double t) {
    return CGPointMake(200 * sin(t * M_PI) * sin(t * 2 * M_PI) + 160,
                       -200 * sin(t * M_PI) * cos(t * 2 * M_PI) + 160);
  };
  return curve;
}

//圆形，其他曲线请参考MDCurve:https://github.com/yangchenlarkin/MDCurve

- (MDCurve *)curve1 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFuction = ^(double t) {
    return CGPointMake(160 + 150 * cos(t * 2 * M_PI), 160 + 150 * sin(t * 2 * M_PI));
  };
  return curve;
}

//正弦曲线，其他曲线请参考MDCurve:https://github.com/yangchenlarkin/MDCurve

- (MDCurve *)curve2 {
  MDCurve *curve = [[MDCurve alloc] init];
  curve.curveFuction = ^(double t) {
    return CGPointMake(320 * t, 150 * sin(t * 2 * M_PI) + 260);
  };
  return curve;
}

@end
