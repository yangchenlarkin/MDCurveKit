//
//  MDHandwritingViewDemoViewController.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/22/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDHandwritingViewDemoViewController.h"
#import "MDHandwritingView.h"
#import "NEOColorPickerViewController.h"

@interface MDHandwritingViewDemoViewController () <NEOColorPickerViewControllerDelegate> {
  MDHandwritingView *_view;
}

@end

@implementation MDHandwritingViewDemoViewController

- (void)loadHandwritingView {
  _view = [[MDHandwritingView alloc] initWithFrame:CGRectMake(0, 64.f, 320, 320)];
  _view.backgroundColor = [UIColor yellowColor];
  _view.drawingWithDashed = YES;
  [self.view addSubview:_view];
}

- (void)loadSettingView {
  UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 320+64, 160, 44)];
  [button1 setTitle:@"undo" forState:UIControlStateNormal];
  [button1 addTarget:_view action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
  button1.backgroundColor = [UIColor greenColor];
  [self.view addSubview:button1];
  
  UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(160, 320+64, 160, 44)];
  [button2 setTitle:@"redo" forState:UIControlStateNormal];
  [button2 addTarget:_view action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
  button2.backgroundColor = [UIColor greenColor];
  [self.view addSubview:button2];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"pickColor" style:UIBarButtonItemStyleDone target:self action:@selector(colorPicker)];
  
  UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 320 + 64 + 44, 320, 44)];
  slider.minimumValue = 1;
  slider.maximumValue = 10;
  [slider addTarget:self action:@selector(strokeWidthChanged:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:slider];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadHandwritingView];
  [self loadSettingView];
}

- (void)colorPicker {
  NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
  controller.delegate = self;
  controller.selectedColor = _view.strokeColor;
  controller.title = @"Example";
	UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
  
  [self presentViewController:navVC animated:YES completion:nil];
}



- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
  _view.strokeColor = color;
  [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)strokeWidthChanged:(UISlider *)slider {
  _view.strokeWidth = slider.value;
}

@end
