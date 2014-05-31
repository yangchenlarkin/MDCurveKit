//
//  MDGetStringViewController.h
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 6/6/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDCurve;

typedef void(^MDDidGetInfo)(BOOL useAttribute, MDCurve *curve, CGFloat startOffset);

@interface MDGetStringViewController : UITableViewController

@property (nonatomic, copy) MDDidGetInfo didGetInfo;

@end
