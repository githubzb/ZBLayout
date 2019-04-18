//
//  YGLayout+ZBLayout.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/14.
//  Copyright © 2019 zb. All rights reserved.
//

#import <YogaKit/YGLayout.h>

typedef NS_ENUM(NSInteger, ZBBorderStyle) {
    ZBBorderStyleNone = 0,
    ZBBorderStyleDotted,
    ZBBorderStyleDashed,
    ZBBorderStyleSolid
};

NS_ASSUME_NONNULL_BEGIN

@interface YGLayout (ZBLayout)

@property (nonatomic, readwrite, assign) YGValue borderRadius;
@property (nonatomic, readwrite, assign) YGValue borderTopLeftRadius;
@property (nonatomic, readwrite, assign) YGValue borderTopRightRadius;
@property (nonatomic, readwrite, assign) YGValue borderBottomLeftRadius;
@property (nonatomic, readwrite, assign) YGValue borderBottomRightRadius;

@property (nonatomic, readwrite, assign) ZBBorderStyle borderTopStyle;
@property (nonatomic, readwrite, assign) ZBBorderStyle borderRightStyle;
@property (nonatomic, readwrite, assign) ZBBorderStyle borderBottomStyle;
@property (nonatomic, readwrite, assign) ZBBorderStyle borderLeftStyle;
@property (nonatomic, readwrite, assign) ZBBorderStyle borderStartStyle;
@property (nonatomic, readwrite, assign) ZBBorderStyle borderEndStyle;
@property (nonatomic, readwrite, assign) ZBBorderStyle borderStyle;

@property (nonatomic, readwrite, copy) UIColor *borderTopColor;
@property (nonatomic, readwrite, copy) UIColor *borderRightColor;
@property (nonatomic, readwrite, copy) UIColor *borderBottomColor;
@property (nonatomic, readwrite, copy) UIColor *borderLeftColor;
@property (nonatomic, readwrite, copy) UIColor *borderStartColor;
@property (nonatomic, readwrite, copy) UIColor *borderEndColor;
@property (nonatomic, readwrite, copy) UIColor *borderColor;


/**
 采用此方法布局，可以实现边框和圆角效果

 @param preserveOrigin 是否保留原始坐标x,y
 */
- (void)ZB_applyLayoutPreservingOrigin:(BOOL)preserveOrigin;

/**
 采用此方法布局，可以实现边框和圆角效果

 @param preserveOrigin          是否保留原始坐标x,y
 @param dimensionFlexibility    自适应高或宽
 */
- (void)ZB_applyLayoutPreservingOrigin:(BOOL)preserveOrigin
                  dimensionFlexibility:(YGDimensionFlexibility)dimensionFlexibility;


@end

NS_ASSUME_NONNULL_END
