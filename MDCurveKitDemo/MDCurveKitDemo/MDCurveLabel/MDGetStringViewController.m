//
//  MDGetStringViewController.m
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 6/6/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDGetStringViewController.h"

@interface MDGetStringViewController ()

@property (nonatomic, strong) UISlider *startOffsetView;
@property (nonatomic, strong) UISwitch *useAttributeStringView;

@end

@implementation MDGetStringViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return
  section == 0 ? 1 :
  section == 1 ? 1 :
  3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return
  indexPath.section == 0 ? [self startOffsetCell] :
  indexPath.section == 1 ? [self useAttributeStringCell] :
  indexPath.section == 2 ? [self curveCellWithIndex:indexPath.row] :
  [UITableViewCell new];
}

- (UITableViewCell *)startOffsetCell {
  static NSString *identify = @"startOffsetCell";
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.textLabel.text = @"startOffset";
    cell.accessoryView = self.startOffsetView;
  }
  return cell;
}

- (UITableViewCell *)useAttributeStringCell {
  static NSString *identify = @"useAttributeStringCell";
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.accessoryView = self.useAttributeStringView;
  }
  return cell;
}

- (UITableViewCell *)curveCellWithIndex:(NSInteger)index {
  static NSString *identify = @"curveCell";
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    
  }
  return cell;
}

@end
