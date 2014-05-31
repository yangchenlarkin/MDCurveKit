//
//  MDBezierCurveDemoViewController.m
//  MDCurveDemo
//
//  Created by 杨晨 on 1/3/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDBezierCurveDemoViewController.h"
#import "MDCurve.h"
#import "MDDemoView.h"
#import "mach/mach_time.h"

@interface MDBezierCurveDemoViewController () <UIActionSheetDelegate> {
  MDDemoView *_demoView;
  UIButton *_button;
}

@end

@implementation MDBezierCurveDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self demoView];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44.f)];
  UIView *view = _demoView;
  view.backgroundColor = [UIColor lightGrayColor];
  [scrollView addSubview:view];
  scrollView.contentSize = view.frame.size;
  scrollView.contentInset = UIEdgeInsetsMake(64.f, 0, 0, 0);
  [self.view addSubview:scrollView];
  
  _button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44.f, 320.f, 44.f)];
  [_button setTitle:@"二阶" forState:UIControlStateNormal];
  [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_button addTarget:self action:@selector(chooseCurve) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_button];
}

- (void)demoView {
  MDDemoView *demoView = [[MDDemoView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
  
  MDBezierCurve *curve = [[MDBezierCurve alloc] initWithStartPointPair0:pointPairWithCoordinate(0, 20, 320, 60)
                                                             pointPair1:pointPairWithCoordinate(100, 100, 0, 160)];
  curve.isCubic = NO;
  uint64_t start = mach_absolute_time();
  [curve addPointPairs:@[pointPairWithCoordinate(300, 200, 200, 250),
                         pointPairWithCoordinate(30, 200, 20, 250),
                         pointPairWithCoordinate(130, 20, 220, 50),
                         pointPairWithCoordinate(220, 400, 20, 400),
                         pointPairWithCoordinate(30, 400, -220, 203)]];
  uint64_t end = mach_absolute_time();
  uint64_t elapsed = end - start;
  
  mach_timebase_info_data_t info;
  if (mach_timebase_info (&info) != KERN_SUCCESS) {
    printf ("mach_timebase_info failed\n");
  }
  
  uint64_t nanosecs = elapsed * info.numer / info.denom;
  uint64_t millisecs = nanosecs / 1000000;
  NSLog(@"cache用时：%llu", millisecs);
  demoView.curve = curve;
  _demoView = demoView;
}

- (void)chooseCurve {
  MDBezierCurve *bezierCurve = (MDBezierCurve *)_demoView.curve;
  bezierCurve.isCubic = !bezierCurve.isCubic;
  [_button setTitle:bezierCurve.isCubic ? @"三阶" : @"二阶" forState:UIControlStateNormal];
  [_demoView setNeedsDisplay];
}

@end
