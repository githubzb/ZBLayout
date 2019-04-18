//
//  ZBTableView.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBViewProtocol.h"
#import "ZBDataSource.h"
#import "ZBHeaderFooterDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@class ZBTableView;
@protocol ZBTableViewDelegate <UIScrollViewDelegate>

@optional
- (void)tableView:(ZBTableView *)tableView didSelectCellModel:(__kindof ZBViewModel *)model;
- (BOOL)tableView:(ZBTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(ZBTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ZBTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZBTableView : UIView

@property (nonatomic, weak) id<ZBTableViewDelegate> delegate;
/**
 cell数据源
 */
@property (nonatomic, readonly) ZBDataSource *source;

/**
 Header数据源
 */
@property (nonatomic, readonly) ZBHeaderFooterDataSource *headerSource;

/**
 Header数据源
 */
@property (nonatomic, readonly) ZBHeaderFooterDataSource *footerSource;

/**
 点击tablview（除了UIKeyInput、UIControl之外的）视图时，结束编辑状态
 */
@property (nonatomic, assign) BOOL tapTableEndEditing;

/**
 设置tableviewcell的separator
 */
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, strong, nullable) UIColor *separatorColor;
@property (nonatomic, copy, nullable) UIVisualEffect *separatorEffect;
@property (nonatomic) UIEdgeInsets separatorInset;

- (instancetype)initWithDataSource:(ZBDataSource *)source
                             style:(UITableViewStyle)style;

/**
 根据样式重新初始化tableview

 @param style tableView样式
 */
- (void)setStyle:(UITableViewStyle)style;

/**
 设置tableView的headerView

 @param view 视图
 */
- (void)setHeaderView:(UIView *)view;

/**
 设置tableView的footerView

 @param view 视图
 */
- (void)setFooterView:(UIView *)view;

/**
 获取指定组下的headerView

 @param section 组index
 @return        viewModel对应的视图
 */
- (id<ZBViewProtocol>)headerViewForSection:(NSInteger)section;

/**
 获取指定组下的footerView
 
 @param section 组index
 @return        viewModel对应的视图
 */
- (id<ZBViewProtocol>)footerViewForSection:(NSInteger)section;

/**
 注册cell视图class

 @param cls view类
 */
- (void)registerCellViewClass:(Class)cls;

/**
 注册header and footer视图class

 @param cls view类
 */
- (void)registerHeaderFooterViewClass:(Class)cls;
/**
 根据当前的source，刷新cell
 */
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
