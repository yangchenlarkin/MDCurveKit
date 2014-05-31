//
//  MDHomeViewController.m
//  MDCurveKitDemo
//
//  Created by 杨晨 on 6/16/14.
//  Copyright (c) 2014 剑川道长. All rights reserved.
//

#import "MDHomeViewController.h"

@interface MDHomeViewController () {
  NSArray *_dataSource;
}

@end

@implementation MDHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _dataSource = @[@"MDCurveDemo",
                @"MDCurveLabelDemo"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  cell.textLabel.text = _dataSource[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  Class theClass = NSClassFromString([_dataSource[indexPath.row] stringByAppendingString:@"RootViewController"]);
  UIViewController *viewController = [[theClass alloc] init];
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
