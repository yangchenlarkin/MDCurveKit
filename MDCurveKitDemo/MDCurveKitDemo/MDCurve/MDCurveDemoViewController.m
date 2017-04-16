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
    _demoView = [[MDCurveDemoView alloc] initWithFrame:CGRectMake(0, 88.f, 320, self.view.frame.size.height - 88.f - 88.f)];
    _demoView.center = CGPointMake(self.view.frame.size.width / 2.f, self.view.frame.size.height / 2.f);
    CGFloat scale = self.view.frame.size.width / 320.f;
    _demoView.transform = CGAffineTransformMakeScale(scale, scale);
    _demoView.backgroundColor = [UIColor lightGrayColor];
    _demoView.curve = [MDCurvePicker curves][0];
    [self.view addSubview:_demoView];
}

- (void)didPickCurve:(id)curve {
    [super didPickCurve:curve];
    _demoView.curve = curve;
}

@end
