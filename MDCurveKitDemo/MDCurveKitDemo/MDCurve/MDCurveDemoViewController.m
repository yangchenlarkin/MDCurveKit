//
//  MDCurveDemoViewController.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/27/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDCurveDemoViewController.h"
#import "MDDemoView.h"

@interface MDCurveDemoViewController () <UIActionSheetDelegate> {
  MDDemoView *_demoView;
}

@end

@implementation MDCurveDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _demoView = [[MDDemoView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
  [self f0];
  [self.view addSubview:_demoView];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44.f)];
  UIView *view = _demoView;
  view.backgroundColor = [UIColor lightGrayColor];
  [scrollView addSubview:view];
  scrollView.contentSize = view.frame.size;
  [self.view addSubview:scrollView];
  
  UIButton *_button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44.f, 320.f, 44.f)];
  [_button setTitle:@"选择曲线" forState:UIControlStateNormal];
  [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_button addTarget:self action:@selector(chooseCurve) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_button];
}

- (void)chooseCurve {
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择曲线"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:
                          @"圆",
                          @"正弦曲线",
                          @"心型",
                          @"螺旋线",
                          @"椭圆螺旋线",
                          @"8字",
                          @"歪8字",
                          @"呵呵8字",
                          @"直线",
                          @"分段函数（长方形）",
                          nil];
  [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  SEL selector = NSSelectorFromString([NSString stringWithFormat:@"f%ld", (long)buttonIndex]);
  IMP imp = [self methodForSelector:selector];
  void (*func)(id, SEL) = (void *)imp;
  func(self, selector);
}

/**
 *  圆
 */
- (void)f0 {
  [_demoView setCurveFunction:^(double t) {
    return CGPointMake(160 + 150 * cos(t * 2 * M_PI), 250 + 150 * sin(t * 2 * M_PI));
  }];
}

/*
 *正弦曲线
 */
- (void)f1 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(320 * t, 150 * sin(t * 2 * M_PI) + 260);
  }];
}

/*
 *心型
 */
- (void)f2 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(200 * sin(t * M_PI) * sin(t * 2 * M_PI) + 160,
                       -200 * sin(t * M_PI) * cos(t * 2 * M_PI) + 160);
  }];
}

/**
 *  螺旋线
 */
- (void)f3 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(180 * t * sin(t * 4 * M_PI) + 180,
                       180 * t * cos(t * 4 * M_PI) + 300);
  }];
}

/**
 *  椭圆螺旋线
 */
- (void)f4 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(100 * t * sin(t * 4 * M_PI) + 160,
                       200 * t * cos(t * 4 * M_PI) + 300);
  }];
}

/**
 *  8字
 */
- (void)f5 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(150 * sin(t * 4 * M_PI) + 160,
                       200 * cos(t * 2 * M_PI) + 300);
  }];
}

/**
 *  歪8字
 */
- (void)f6 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(150 * t * sin(t * 4 * M_PI) + 160,
                       200 * cos(t * 2 * M_PI) + 300);
  }];
}

/**
 *  呵呵8字
 */
- (void)f7 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(150 * t * sin(t * 4 * M_PI) + 160,
                       200 * t * cos(t * 2 * M_PI) + 300);
  }];
}

/**
 *  直线
 */
- (void)f8 {
  [_demoView setCurveFunction: ^(double t) {
    return CGPointMake(300 * t + 10,
                       300 * t + 100);
  }];
}

/**
 *  分段函数
 *  PS:好复杂，画个长方形都这么烦
 */

- (void)f9 {
  [_demoView setCurveFunction: ^(double t) {
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
  }];
}

@end
