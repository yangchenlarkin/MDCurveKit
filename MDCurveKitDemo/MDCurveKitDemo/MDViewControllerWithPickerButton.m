//
//  MDViewControllerWithPickerButton.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDViewControllerWithPickerButton.h"
#import "MDCurvePicker.h"

@interface MDViewControllerWithPickerButton ()

@property (nonatomic, strong) MDCurvePicker *picker;

@end

@implementation MDViewControllerWithPickerButton

- (MDCurvePicker *)picker {
  __weak MDViewControllerWithPickerButton *weakSelf = self;
  return _picker ?: (_picker = [[MDCurvePicker alloc] initWithBlock:
                                ^(MDCurve *curve) {
                                  [weakSelf didPickCurve:curve];
                                }]);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIButton *_button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44.f, 320.f, 44.f)];
  [_button setTitle:@"选择曲线" forState:UIControlStateNormal];
  [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_button addTarget:self action:@selector(pickCurve) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_button];
}

- (void)pickCurve {
  [self.picker pickInViewController:self];
}

- (void)didPickCurve:(MDCurve *)curve {
  
}

@end
