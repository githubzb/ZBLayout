//
//  ZBViewProtocol.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+zbyoga.h"
#import "YGLayout+ZBLayout.h"
#import "ZBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZBViewProtocol <NSObject>

@required

/**
 设置view的视图模型

 @param model 视图模型
 */
- (void)setViewModel:(__kindof ZBViewModel *)model;

@end

NS_ASSUME_NONNULL_END
