//
//  MDCurveListViewCell.h
//  MDCurveKitDemo
//
//  Created by 杨晨 on 17/4/15.
//  Copyright © 2017年 剑川道长. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCurveListViewCell : UIView

@property (nonatomic, readonly) NSString *reuseIdentifier;

- (id)initWithIdentifier:(NSString *)identifier;

@end
