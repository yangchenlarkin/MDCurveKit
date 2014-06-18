//
//  MDCurveLabelDemoViewController.m
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 4/25/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDCurveLabelDemoViewController.h"
#import "MDCurveDemoLabel.h"
#import <CoreText/CoreText.h>
#import "MDCurvePicker.h"

@interface MDCurveLabelDemoViewController ()

@property (nonatomic, strong) MDCurveDemoLabel *label;

@end

@implementation MDCurveLabelDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _label = [[MDCurveDemoLabel alloc] initWithFrame:CGRectMake(0, 0.f, 320, 600.f)];
  _label.curve = [MDCurvePicker curves][0];
  _label.text = @"NSString with some very very very very very very very very very very very very very very very long word";
  _label.font = [UIFont boldSystemFontOfSize:16];
  _label.textColor = [UIColor redColor];
  _label.backgroundColor = [UIColor yellowColor];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 88.f)];
  UIView *view = _label;
  [scrollView addSubview:view];
  scrollView.contentSize = view.frame.size;
  [self.view addSubview:scrollView];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"tapMe" style:UIBarButtonItemStyleDone target:self action:@selector(settings)];
  
  [self addSettingButtons];
}

- (void)addSettingButtons {
  UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300.f, 33.f)];
  slider.center = CGPointMake(160, self.view.frame.size.height - 66.f);
  [slider addTarget:self action:@selector(startOffsetDidChange:) forControlEvents:UIControlEventValueChanged];
  slider.maximumValue = 1.f;
  slider.minimumValue = 0.f;
  [self.view addSubview:slider];
}

- (void)startOffsetDidChange:(UISlider *)sender {
  _label.startOffset = sender.value;
}

- (void)settings {
  _label.attributedString = _label.attributedString ? nil : [self string];
}

- (void)didPickCurve:(MDCurve *)curve {
  _label.curve = curve;
}

#pragma mark - NSAttributedString

- (NSAttributedString *)string {
  NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"NSMutableAttributedString with some very very very very very very very very very very very very very very very very very very very very very long word"];
  
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

@end
