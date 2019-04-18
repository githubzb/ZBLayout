//
//  YGLayout+ZBLayout.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/14.
//  Copyright © 2019 zb. All rights reserved.
//

#import "YGLayout+ZBLayout.h"
#import "UIView+zbyoga.h"
#import <YogaKit/YGLayout+Private.h>
#import <objc/runtime.h>
#import "ZBLRoundedRect.h"

#define ZB_PROPERTY_YGVALUE(lowercased_name, capitalized_name)      \
- (YGValue)lowercased_name                                          \
{                                                                   \
NSValue *val = objc_getAssociatedObject(self, @selector(lowercased_name)); \
if (val) {                                                          \
    YGValue ygval;                                                  \
    [val getValue:&ygval];                                          \
    return ygval;                                                   \
}                                                                   \
return YGValueUndefined;                                            \
}                                                                   \
- (void)set##capitalized_name:(YGValue)lowercased_name                 \
{                                                                   \
NSValue *val = [NSValue value:&lowercased_name withObjCType:@encode(YGValue)]; \
objc_setAssociatedObject(self, @selector(lowercased_name), val, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
}

#define ZB_PROPERTY_STYLE(lowercased_name, capitalized_name)      \
- (ZBBorderStyle)lowercased_name                                          \
{                                                                   \
NSNumber *n = objc_getAssociatedObject(self, @selector(lowercased_name));\
if (n) {                                                                \
    return (ZBBorderStyle)n.integerValue;                               \
}                                                                       \
return ZBBorderStyleNone;                                              \
}                                                                   \
- (void)set##capitalized_name:(ZBBorderStyle)lowercased_name                 \
{                                                                   \
objc_setAssociatedObject(self, @selector(lowercased_name), @(lowercased_name), OBJC_ASSOCIATION_COPY_NONATOMIC); \
}

#define ZB_PROPERTY_COLOR(lowercased_name, capitalized_name)      \
- (UIColor *)lowercased_name                                          \
{                                                                   \
UIColor *color = objc_getAssociatedObject(self, @selector(lowercased_name));\
if (color) {                                                        \
    return color;                                                   \
}                                                                   \
return nil;                                        \
}                                                                   \
- (void)set##capitalized_name:(UIColor *)lowercased_name                 \
{                                                                   \
objc_setAssociatedObject(self, @selector(lowercased_name), lowercased_name, OBJC_ASSOCIATION_COPY_NONATOMIC); \
}

@implementation YGLayout (ZBLayout)

ZB_PROPERTY_YGVALUE(borderRadius, BorderRadius)
ZB_PROPERTY_YGVALUE(borderTopLeftRadius, BorderTopLeftRadius)
ZB_PROPERTY_YGVALUE(borderTopRightRadius, BorderTopRightRadius)
ZB_PROPERTY_YGVALUE(borderBottomLeftRadius, BorderBottomLeftRadius)
ZB_PROPERTY_YGVALUE(borderBottomRightRadius, BorderBottomRightRadius)

ZB_PROPERTY_STYLE(borderTopStyle, BorderTopStyle)
ZB_PROPERTY_STYLE(borderRightStyle, BorderRightStyle)
ZB_PROPERTY_STYLE(borderBottomStyle, BorderBottomStyle)
ZB_PROPERTY_STYLE(borderLeftStyle, BorderLeftStyle)
ZB_PROPERTY_STYLE(borderEndStyle, BorderEndStyle)
ZB_PROPERTY_STYLE(borderStartStyle, BorderStartStyle)
ZB_PROPERTY_STYLE(borderStyle, BorderStyle)

ZB_PROPERTY_COLOR(borderTopColor, BorderTopColor)
ZB_PROPERTY_COLOR(borderRightColor, BorderRightColor)
ZB_PROPERTY_COLOR(borderBottomColor, BorderBottomColor)
ZB_PROPERTY_COLOR(borderLeftColor, BorderLeftColor)
ZB_PROPERTY_COLOR(borderEndColor, BorderEndColor)
ZB_PROPERTY_COLOR(borderStartColor, BorderStartColor)
ZB_PROPERTY_COLOR(borderColor, BorderColor)



- (void)ZB_applyLayoutPreservingOrigin:(BOOL)preserveOrigin{
    UIView *view = [self currView];
    [self calculateLayoutWithSize:view.bounds.size];
    ZBApplyLayoutToViewHierarchy(view, preserveOrigin);
}

- (void)ZB_applyLayoutPreservingOrigin:(BOOL)preserveOrigin
                  dimensionFlexibility:(YGDimensionFlexibility)dimensionFlexibility{
    UIView *view = [self currView];
    CGSize size = view.bounds.size;
    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleWidth) {
        size.width = YGUndefined;
    }
    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleHeight) {
        size.height = YGUndefined;
    }
    [self calculateLayoutWithSize:size];
    ZBApplyLayoutToViewHierarchy(view, preserveOrigin);
}

#pragma mark - private
- (UIView *)currView{
    return (__bridge UIView *)YGNodeGetContext(self.node);
}
static CGFloat ZBRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    
    return roundf(value * scale) / scale;
}

static void ZBApplyLayoutToViewHierarchy(UIView *view, BOOL preserveOrigin)
{
    NSCAssert([NSThread isMainThread], @"Framesetting should only be done on the main thread.");
    
    const YGLayout *yoga = view.yoga;
    
    if (!yoga.isIncludedInLayout) {
        return;
    }
    
    YGNodeRef node = yoga.node;
    const CGPoint topLeft = {
        YGNodeLayoutGetLeft(node),
        YGNodeLayoutGetTop(node),
    };
    
    const CGPoint bottomRight = {
        topLeft.x + YGNodeLayoutGetWidth(node),
        topLeft.y + YGNodeLayoutGetHeight(node),
    };
    
    const CGPoint origin = preserveOrigin ? view.frame.origin : CGPointZero;
    CGSize originalSize = view.frame.size;
    view.frame = (CGRect) {
        .origin = {
            .x = ZBRoundPixelValue(topLeft.x + origin.x),
            .y = ZBRoundPixelValue(topLeft.y + origin.y),
        },
        .size = {
            .width = ZBRoundPixelValue(bottomRight.x) - ZBRoundPixelValue(topLeft.x),
            .height = ZBRoundPixelValue(bottomRight.y) - ZBRoundPixelValue(topLeft.y),
        },
    };
    CGSize currSize = view.frame.size;
    //绘制圆角
    ZBLRoundedRect *round = [[ZBLRoundedRect alloc] initWithRect:view.bounds
                                                          radius:yoga.borderRadius
                                                         topLeft:yoga.borderTopLeftRadius
                                                        topRight:yoga.borderTopRightRadius
                                                      bottomLeft:yoga.borderBottomLeftRadius
                                                     bottomRight:yoga.borderBottomRightRadius];
    if ([round.radii hasBorderRadius]) {
        if ([round.radii isAllCircular]) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = round.radii.topLeftRadiusVal;
        }else{
            if ((!view.layer.mask || !CGSizeEqualToSize(originalSize, currSize))) {
                view.layer.mask = [round.radii circularLayer];
            }
        }
    }
    if (view.layoutFinish) {
        view.layoutFinish(view);
    }
    if (!yoga.isLeaf) {
        for (NSUInteger i=0; i<view.subviews.count; i++) {
            ZBApplyLayoutToViewHierarchy(view.subviews[i], NO);
        }
    }
}

@end
