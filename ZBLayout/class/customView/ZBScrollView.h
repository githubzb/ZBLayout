//
//  ZBScrollView.h
//  ZBLayout
//
//  Created by dr.box on 2019/4/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBViewProtocol.h"

typedef NS_ENUM(NSInteger, ZBScrollDirection) {
    //垂直方向滚动
    ZBVertical = 0,
    //水平方向滚动
    ZBHorizontal = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZBScrollView : UIView

@property (nonatomic, readonly, assign) ZBScrollDirection direction;
@property (nonatomic, readonly, weak) UIScrollView *scroller;

- (instancetype)initWithFrame:(CGRect)frame
                    direction:(ZBScrollDirection)direction;
+ (instancetype)newFrame:(CGRect)frame
               direction:(ZBScrollDirection)direction;
+ (instancetype)newDirection:(ZBScrollDirection)direction;

/**
 删除已有视图，重新加载新的视图

 @param models 视图模型
 */
- (void)reloadViewModels:(NSArray<ZBViewModel *> *)models;

/**
 在已有视图的基础上，追加新的视图

 @param models 视图模型
 */
- (void)loadViewModels:(NSArray<ZBViewModel *> *)models;

/**
 在已有的视图基础上刷新数据，并进行重新布局
 */
- (void)reload;

/**
 获取单个viewModel

 @param index   位置下标
 @return        视图模型
 */
- (__kindof ZBViewModel *)viewModelAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
