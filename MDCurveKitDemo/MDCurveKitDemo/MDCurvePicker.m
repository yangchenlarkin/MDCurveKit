//
//  MDCurvePicker.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDCurvePicker.h"

@interface MDCurvePicker () <UIActionSheetDelegate> {
  UIActionSheet *_sheet;
  UIViewController *_viewController;
  MDCurvePickerBlock _block;
}

@end

@implementation MDCurvePicker

- (id)initWithBlock:(MDCurvePickerBlock)block
     viewController:(UIViewController *)viewController {
  if (self = [super init]) {
    _sheet = [[UIActionSheet alloc] initWithTitle:nil
                                         delegate:self
                                cancelButtonTitle:@"cancel"
                           destructiveButtonTitle:@"1"
                                otherButtonTitles:@"2", nil];
    _viewController = viewController;
    _block = [block copy];
  }
  return self;
}

- (void)pick {
  [_sheet showInView:_viewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (_block) {
    _block(nil, nil);
  }
}

@end
