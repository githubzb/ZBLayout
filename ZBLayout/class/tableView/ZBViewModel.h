//
//  ZBViewModel.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBViewModel : NSObject

//对应视图的class
@property (class, readonly) Class viewClass;
//tableview自动计算,作为缓存size
@property (nonatomic, assign) CGSize size;

/**
 是否使用缓存size作为cell的高度
 */
@property (nonatomic, assign) BOOL useSizeCache;
//cell Selection background color.if nil SelectionStyle = none
@property (nonatomic, strong) UIColor *selectionColor;

/**
 视图模型的标签，用于快速查询
 */
@property (nonatomic, copy) NSString *tag;

@end

NS_ASSUME_NONNULL_END
