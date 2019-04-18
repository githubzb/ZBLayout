//
//  UIView+zbyoga.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YogaKit/UIView+Yoga.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZBLayoutFinishBlock)(__kindof UIView *v);//yoga布局完成回调

@interface UIView (zbyoga)

@property (nonatomic, readwrite, nullable) ZBLayoutFinishBlock layoutFinish;

@end

NS_ASSUME_NONNULL_END
