//
//  ZBDataSource.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBDataSource : NSObject

/**
 组数
 */
@property (nonatomic, readonly) NSUInteger sectionCount;

/**
 获取每组中的数据条数

 @param section 组index
 @return        row count
 */
- (NSUInteger)rowCountAtSection:(NSInteger)section;

/**
 向指定组中添加视图模型

 @param model   视图模型
 @param section 组index
 */
- (void)addModel:(ZBViewModel *)model atSection:(NSInteger)section;

/**
 向指定组中指定位置插入一条视图模型

 @param model   视图模型
 @param row     插入下标（如果大于总条数，则会插入到最后一条位置）
 @param section 组index
 */
- (void)insertModel:(ZBViewModel *)model
         atRowIndex:(NSInteger)row
          atSection:(NSInteger)section;

/**
 向指定组中添加视图模型数组

 @param models  视图模型数组
 @param section 组index
 */
- (void)addModels:(NSArray<ZBViewModel *> *)models
        atSection:(NSInteger)section;

/**
 删除指定组中指定位置的视图模型

 @param row     row index
 @param section 组 index
 */
- (void)removeAtRowIndex:(NSInteger)row atSection:(NSInteger)section;

/**
 删除一组视图模型（注意：该组还会保留）

 @param section 组index
 */
- (void)removeAtSection:(NSInteger)section;

/**
 删除所有组数据（注意：不会保留组）
 */
- (void)removeAll;

/**
 更新指定组下的指定位置的视图模型

 @param model   更新后的视图模型
 @param row     行index
 @param section 组index
 */
- (void)updateModel:(ZBViewModel *)model atRowIndex:(NSInteger)row atSection:(NSInteger)section;

/**
 更新某一组视图模型

 @param models  最新的视图模型数组
 @param section 组index
 */
- (void)updateModels:(NSArray<ZBViewModel *> *)models atSection:(NSInteger)section;

/**
 获取视图模型

 @param row     row index
 @param section 组index
 @return        视图模型
 */
- (__kindof ZBViewModel *)modelAtRow:(NSInteger)row atSection:(NSInteger)section;
- (__kindof ZBViewModel *)modelAtIndexPath:(NSIndexPath *)path;

/**
 获取某组下的全部视图模型

 @param section 组index
 @return        视图模型数组
 */
- (NSArray<__kindof ZBViewModel *> *)modelsAtSection:(NSInteger)section;

/**
 获取某组中指定tag的视图模型
 
 @param tag         视图标签(如果tag存在重复，则会返回最后一个model)
 @param section     sectionIndex
 @return            视图模型
 */
- (__kindof ZBViewModel *)modelWithTag:(NSString *)tag atSection:(NSInteger)section;

/**
 获取某组中指定tag的视图模型数组
 
 @param tag         视图标签
 @param section     sectionIndex
 @return            视图模型数组
 */
- (NSArray<__kindof ZBViewModel *> *)modelsWithTag:(NSString *)tag atSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
