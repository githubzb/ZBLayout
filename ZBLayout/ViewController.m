//
//  ViewController.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/12.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#import "ZBTableView.h"

#import "MyListCellModel.h"
#import "MyHeaderFooterModel.h"

@interface ViewController ()<ZBTableViewDelegate>

@property (nonatomic, weak) ZBTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZBDataSource *source = [[ZBDataSource alloc] init];
    for (int i=0; i<500; i++) {
        MyListCellModel *m = [[MyListCellModel alloc] init];
        if (i%2==0) {
            m.text = @"分享给好友";
        }else{
            m.text = @"分享给好友";
        }
        m.index = i;
        [source addModel:m atSection:0];
    }

    ZBTableView *tableView = [[ZBTableView alloc] initWithDataSource:source
                                                               style:UITableViewStyleGrouped];
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView registerCellViewClass:MyListCellModel.viewClass];
    [self.tableView registerHeaderFooterViewClass:MyHeaderFooterModel.viewClass];

    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 100)];
    headerView.backgroundColor = [UIColor greenColor];
    [self.tableView setHeaderView:headerView];

    MyHeaderFooterModel *header = [[MyHeaderFooterModel alloc] init];
    header.count = 5;
    [self.tableView.headerSource addModel:header atSection:0];
    MyHeaderFooterModel *footer = [[MyHeaderFooterModel alloc] init];
    footer.count = 3;
    [self.tableView.footerSource addModel:footer atSection:0];
    
    [self.tableView reloadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)tableView:(ZBTableView *)tableView didSelectCellModel:(__kindof ZBViewModel *)model{
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
