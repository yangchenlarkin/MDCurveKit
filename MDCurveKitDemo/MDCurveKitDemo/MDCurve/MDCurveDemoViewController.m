//
//  MDCurveDemoViewController.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/27/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDCurveDemoViewController.h"
#import "MDCurveDemoView.h"
#import "MDCurvePicker.h"

@interface MDCurveDemoViewController ()

@property (nonatomic, strong) MDCurveDemoView *demoView;

@end

@implementation MDCurveDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _demoView = [[MDCurveDemoView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
  _demoView.curve = [MDCurvePicker curves][0];
  [self.view addSubview:_demoView];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44.f)];
  UIView *view = _demoView;
  view.backgroundColor = [UIColor lightGrayColor];
  [scrollView addSubview:view];
  scrollView.contentSize = view.frame.size;
  [self.view addSubview:scrollView];
}

- (void)didPickCurve:(id)curve {
  _demoView.curve = curve;
}

@end
