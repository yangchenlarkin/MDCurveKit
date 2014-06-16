//
//  MDGetStringViewController.h
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 6/6/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MDDidGetInfo)();

@interface MDGetStringViewController : UITableViewController

@property (nonatomic, copy) MDDidGetInfo didGetInfo;
@property (nonatomic, readonly) CGFloat startOffset;
@property (nonatomic, readonly) BOOL useAttribute;

@end
