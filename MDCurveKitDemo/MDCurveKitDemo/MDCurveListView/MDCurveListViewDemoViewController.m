//
//  MDCurveListViewDemoViewController.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 17/4/16.
//  Copyright © 2017年 剑川道长. All rights reserved.
//

#import "MDCurveListViewDemoViewController.h"
#import "MDCurveListView.h"
#import "MDCurvePicker.h"

@interface MDCurveListViewDemoViewController () <MDCurveListViewDataSource, MDCurveListViewDelegate>

@property (nonatomic, strong) MDCurveListView *curveListView;

@end

@implementation MDCurveListViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curveListView = [[MDCurveListView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 88.f - 88.f)];
    self.curveListView.backgroundColor = [UIColor cyanColor];
    self.curveListView.center = CGPointMake(self.view.frame.size.width / 2.f, self.view.frame.size.height / 2.f);
    CGFloat scale = self.view.frame.size.width / 320.f;
    self.curveListView.transform = CGAffineTransformMakeScale(scale, scale);
    self.curveListView.delegate = self;
    self.curveListView.dataSource = self;
    self.curveListView.curve = [MDCurvePicker curves][0];
    [self.view addSubview:self.curveListView];
    
}

- (MDCurveListViewCell *)curveListView:(MDCurveListView *)listView cellForIndex:(NSInteger)index {
    NSString *identifier = index % 2 ? @"1" : @"0";
    MDCurveListViewCell *cell = [self.curveListView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MDCurveListViewCell alloc] initWithIdentifier:identifier];
        CGFloat width = 20;
        cell.frame = CGRectMake(0, 0, width, width);
        cell.backgroundColor = index % 2 ? [UIColor brownColor] : [UIColor blueColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [cell addSubview:label];
        label.tag = 1;
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    UILabel *label = [cell viewWithTag:1];
    label.text = [@(index) stringValue];
    return cell;
}

- (NSInteger)numberOfCellsInCurveListView:(MDCurveListView *)listView {
    return 100;
}

- (CGFloat)spaceBetweenCellsInCurveListView:(MDCurveListView *)listView {
    return 25;
}

- (void)didPickCurve:(MDCurve *)curve {
    [super didPickCurve:curve];
    self.curveListView.curve = curve;
    [self.curveListView reloadData];
}


@end
