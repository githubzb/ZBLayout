//
//  ZBHeaderFooterDataSource.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/14.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBHeaderFooterDataSource : NSObject

/**
 向指定组中添加Header or Footer视图模型
 
 @param model   视图模型
 @param section 组index
 */
- (void)addModel:(__kindof ZBViewModel *)model atSection:(NSInteger)section;

/**
 删除一组中的Header or Footer视图模型

 @param section 组index
 */
- (void)removeAtSection:(NSInteger)section;

/**
 获取指定组下的Header or Footer视图模型

 @param section 组index
 @return        视图模型
 */
- (__kindof ZBViewModel *)modelAtSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
