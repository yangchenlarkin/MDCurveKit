//
//  MDCurveDemoRootViewController.m
//  MDCurveDemo
//
//  Created by 杨晨 on 1/11/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDCurveDemoRootViewController.h"
#import "MDBezierCurveDemoViewController.h"
#import "MDCurveDemoViewController.h"

@interface MDCurveDemoRootViewController () {
  MDBezierCurveDemoViewController *_bezierController;
  MDCurveDemoViewController *_curveController;
  
  UIButton *_button;
  UILabel *_label;
}

@end

@implementation MDCurveDemoRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.f, 44.f)];
  [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
  [_button setTitle:@"tap" forState:UIControlStateNormal];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
  
  _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150.f, 44.f)];
  _label.backgroundColor = [UIColor clearColor];
  _label.text = @"MDCurve";
  _label.textAlignment = NSTextAlignmentCenter;
  [self.navigationItem setTitleView:_label];
  
  _curveController = [[MDCurveDemoViewController alloc] init];
  _bezierController = [[MDBezierCurveDemoViewController alloc] init];
  
  [self addChildViewController:_curveController];
  [self addChildViewController:_bezierController];
  
  [self.view addSubview:_curveController.view];
}

- (void)click {
  [self transitionFromViewController:_button.selected ? _bezierController : _curveController
                    toViewController:_button.selected ? _curveController : _bezierController
                            duration:1
                             options:_button.selected ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                          animations:NULL
                          completion:NULL];
  _button.selected = !_button.selected;
  _label.text = _button.selected ? @"MDBezierCurve" : @"MDCurve";
}

@end
