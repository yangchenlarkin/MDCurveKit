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

- (UISlider *)startOffsetView {
  if (!_startOffsetView) {
    _startOffsetView = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200.f, 33.f)];
    _startOffsetView.maximumValue = 1.f;
    _startOffsetView.minimumValue = 0.f;
  }
  return _startOffsetView;
}

- (UISwitch *)useAttributeStringView {
  return _useAttributeStringView ?: (_useAttributeStringView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60.f, 33.f)]);
}

- (CGFloat)startOffset {
  return self.startOffsetView.value;
}

- (BOOL)useAttribute {
  return self.useAttributeStringView.isOn;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"confirm" style:UIBarButtonItemStyleDone target:self action:@selector(confirm)];
}

- (void)confirm {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
  if (self.didGetInfo) {
    self.didGetInfo();
  }
}

- (id)initWithUseAttribute:(BOOL)useAttribute
               startOffset:(CGFloat)startOffet {
  if (self = [super init]) {
    
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return
  indexPath.row == 0 ? [self startOffsetCell] :
  indexPath.row == 1 ? [self useAttributeStringCell] :
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
    cell.textLabel.text = @"useAttribute";
    cell.accessoryView = self.useAttributeStringView;
  }
  return cell;
}

@end
