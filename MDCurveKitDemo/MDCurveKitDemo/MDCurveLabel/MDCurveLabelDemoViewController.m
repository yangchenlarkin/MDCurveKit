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
#import "MDGetStringViewController.h"

@interface MDCurveLabelDemoViewController ()

@property (nonatomic, strong) MDCurveDemoLabel *label;
@property (nonatomic, strong) MDGetStringViewController *getStringViewController;

@end

@implementation MDCurveLabelDemoViewController

- (MDGetStringViewController *)getStringViewController {
  if (!_getStringViewController) {
    _getStringViewController = [[MDGetStringViewController alloc] init];
    __weak MDCurveLabelDemoViewController *weakSelf = self;
    _getStringViewController.didGetInfo = ^() {
      weakSelf.label.attributedString = weakSelf.getStringViewController.useAttribute ? [weakSelf string] : nil;
      weakSelf.label.startOffset = weakSelf.getStringViewController.startOffset;
    };
  }
  return _getStringViewController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _label = [[MDCurveDemoLabel alloc] initWithFrame:CGRectMake(0, 0.f, 320, 600.f)];
  _label.curve = [MDCurvePicker curves][0];
  _label.attributedString = [self string];
  _label.text = @"NSString with some very very very very very very very very very very very very very very very long word";
  _label.font = [UIFont boldSystemFontOfSize:16];
  _label.textColor = [UIColor redColor];
  _label.backgroundColor = [UIColor yellowColor];
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44.f)];
  UIView *view = _label;
  [scrollView addSubview:view];
  scrollView.contentSize = view.frame.size;
  [self.view addSubview:scrollView];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"settings" style:UIBarButtonItemStyleDone target:self action:@selector(settings)];
}

- (void)settings {
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.getStringViewController];
  [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
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
