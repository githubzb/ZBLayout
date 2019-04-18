//
//  ZBLRoundedRect.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YogaKit/YGLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBLRadii : NSObject

@property (nonatomic, assign) CGFloat topLeftRadiusVal;
@property (nonatomic, assign) CGFloat topRightRadiusVal;
@property (nonatomic, assign) CGFloat bottomLeftRadiusVal;
@property (nonatomic, assign) CGFloat bottomRightRadiusVal;

- (BOOL)hasBorderRadius;
- (BOOL)isAllCircular;
- (CAShapeLayer *)circularLayer;

@end

@interface ZBLRoundedRect : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) ZBLRadii *radii;

- (instancetype)initWithRect:(CGRect)rect
                      radius:(YGValue)radius
                     topLeft:(YGValue)topLeft
                    topRight:(YGValue)topRight
                  bottomLeft:(YGValue)bottomLeft
                 bottomRight:(YGValue)bottomRight;

@end

NS_ASSUME_NONNULL_END
