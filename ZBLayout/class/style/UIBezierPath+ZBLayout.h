//
//  UIBezierPath+ZBLayout.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (ZBLayout)


/**
 用于绘制圆角

 @param rect 绘制区域
 @param topLeftRadius       左上圆角半径
 @param topRightRadius      右上圆角半径
 @param bottomLeftRadius    左下圆角半径
 @param bottomRightRadius   右下圆角半径
 @return                    UIBezierPath
 */
+ (instancetype)zblayout_pathWithRoundedRect:(CGRect)rect
                                     topLeft:(CGFloat)topLeftRadius
                                    topRight:(CGFloat)topRightRadius
                                  bottomLeft:(CGFloat)bottomLeftRadius
                                 bottomRight:(CGFloat)bottomRightRadius;

@end

NS_ASSUME_NONNULL_END
