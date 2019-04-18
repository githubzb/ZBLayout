//
//  ZBLayoutUtils.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YogaKit/YGLayout.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBLayoutUtils : NSObject

+ (BOOL)isValidPoint:(CGPoint)point;
+ (BOOL)isUndefinedOrAuto:(YGValue)value;
+ (CGFloat)floatValue:(YGValue)value ownerSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
