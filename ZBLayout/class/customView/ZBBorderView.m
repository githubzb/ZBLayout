//
//  ZBBorderView.m
//  ZBLayout
//
//  Created by dr.box on 2019/4/17.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBBorderView.h"
#import "ZBLRoundedRect.h"
#import "UIBezierPath+ZBLayout.h"
#import "YGLayout+ZBLayout.h"
#import <YogaKit/UIView+Yoga.h>

@implementation ZBBorderView

- (void)setFrame:(CGRect)frame{
    CGSize size = self.frame.size;
    BOOL isChange = !CGSizeEqualToSize(size, frame.size);
    [super setFrame:frame];
    if (isChange && [self needDrawBorder]) {
        if ([self isSameBorder]) {
            self.layer.borderColor = [self zb_topColor].CGColor;
            self.layer.borderWidth = [self zb_topW];
        }else{
            self.layer.borderColor = nil;
            self.layer.borderWidth = 0;
            [self setNeedsDisplay];
        }
    }
}

- (BOOL)needDrawBorder{
    CGFloat horizontallyBorder = [self zb_leftW]+[self zb_rightW];
    CGFloat verticalBorder = [self zb_topW]+[self zb_bottomW];
    CGFloat w = CGRectGetWidth(self.frame)-horizontallyBorder;
    CGFloat h = CGRectGetHeight(self.frame)-verticalBorder;
    BOOL noZero = !CGSizeEqualToSize(CGSizeMake(w, h), CGSizeZero);
    return (horizontallyBorder>0||verticalBorder>0)&&noZero;
}

- (BOOL)isSameBorder{
    BOOL sameWidth = [self zb_topW]==[self zb_rightW]&&[self zb_rightW]==[self zb_bottomW]&&[self zb_bottomW]==[self zb_leftW];
    BOOL sameColor = CGColorEqualToColor([self zb_topColor].CGColor, [self zb_rightColor].CGColor)&&
    CGColorEqualToColor([self zb_rightColor].CGColor, [self zb_bottomColor].CGColor) &&
    CGColorEqualToColor([self zb_bottomColor].CGColor, [self zb_leftColor].CGColor);
    BOOL isSolid = [self zb_topStyle]==ZBBorderStyleSolid &&
    [self zb_rightStyle]==ZBBorderStyleSolid &&
    [self zb_bottomStyle]==ZBBorderStyleSolid &&
    [self zb_leftStyle]==ZBBorderStyleSolid;
    return sameWidth && sameColor && isSolid;
}

- (CGFloat)zb_topW{
    CGFloat w = 0;
    if (!YGFloatIsUndefined(self.yoga.borderWidth) && self.yoga.borderWidth>0) {
        w = self.yoga.borderWidth;
    }
    if (!YGFloatIsUndefined(self.yoga.borderTopWidth) && self.yoga.borderTopWidth>0) {
        w = self.yoga.borderTopWidth;
    }
    return w;
}
- (CGFloat)zb_rightW{
    CGFloat w = 0;
    if (!YGFloatIsUndefined(self.yoga.borderWidth) && self.yoga.borderWidth>0) {
        w = self.yoga.borderWidth;
    }
    if (!YGFloatIsUndefined(self.yoga.borderRightWidth) && self.yoga.borderRightWidth>0) {
        w = self.yoga.borderRightWidth;
    }
    if (!YGFloatIsUndefined(self.yoga.borderEndWidth) && self.yoga.borderEndWidth>0) {
        w = self.yoga.borderEndWidth;
    }
    return w;
}
- (CGFloat)zb_bottomW{
    CGFloat w = 0;
    if (!YGFloatIsUndefined(self.yoga.borderWidth) && self.yoga.borderWidth>0) {
        w = self.yoga.borderWidth;
    }
    if (!YGFloatIsUndefined(self.yoga.borderBottomWidth) && self.yoga.borderBottomWidth>0) {
        w = self.yoga.borderBottomWidth;
    }
    return w;
}
- (CGFloat)zb_leftW{
    CGFloat w = 0;
    if (!YGFloatIsUndefined(self.yoga.borderWidth) && self.yoga.borderWidth>0) {
        w = self.yoga.borderWidth;
    }
    if (!YGFloatIsUndefined(self.yoga.borderLeftWidth) && self.yoga.borderLeftWidth>0) {
        w = self.yoga.borderLeftWidth;
    }
    if (!YGFloatIsUndefined(self.yoga.borderStartWidth) && self.yoga.borderStartWidth>0) {
        w = self.yoga.borderStartWidth;
    }
    return w;
}

- (ZBBorderStyle)zb_topStyle{
    ZBBorderStyle style = ZBBorderStyleSolid;
    if (self.yoga.borderStyle != ZBBorderStyleNone) {
        style = self.yoga.borderStyle;
    }
    if (self.yoga.borderTopStyle != ZBBorderStyleNone) {
        style = self.yoga.borderTopStyle;
    }
    return style;
}
- (ZBBorderStyle)zb_rightStyle{
    ZBBorderStyle style = ZBBorderStyleSolid;
    if (self.yoga.borderStyle != ZBBorderStyleNone) {
        style = self.yoga.borderStyle;
    }
    if (self.yoga.borderRightStyle != ZBBorderStyleNone) {
        style = self.yoga.borderRightStyle;
    }
    if (self.yoga.borderEndStyle != ZBBorderStyleNone) {
        style = self.yoga.borderEndStyle;
    }
    return style;
}
- (ZBBorderStyle)zb_bottomStyle{
    ZBBorderStyle style = ZBBorderStyleSolid;
    if (self.yoga.borderStyle != ZBBorderStyleNone) {
        style = self.yoga.borderStyle;
    }
    if (self.yoga.borderBottomStyle != ZBBorderStyleNone) {
        style = self.yoga.borderBottomStyle;
    }
    return style;
}
- (ZBBorderStyle)zb_leftStyle{
    ZBBorderStyle style = ZBBorderStyleSolid;
    if (self.yoga.borderStyle != ZBBorderStyleNone) {
        style = self.yoga.borderStyle;
    }
    if (self.yoga.borderLeftStyle != ZBBorderStyleNone) {
        style = self.yoga.borderLeftStyle;
    }
    if (self.yoga.borderStartStyle != ZBBorderStyleNone) {
        style = self.yoga.borderStartStyle;
    }
    return style;
}

- (UIColor *)zb_topColor{
    UIColor *color = [UIColor whiteColor];
    if (self.yoga.borderColor) {
        color = self.yoga.borderColor;
    }
    if (self.yoga.borderTopColor) {
        color = self.yoga.borderTopColor;
    }
    return color;
}
- (UIColor *)zb_rightColor{
    UIColor *color = [UIColor whiteColor];
    if (self.yoga.borderColor) {
        color = self.yoga.borderColor;
    }
    if (self.yoga.borderRightColor) {
        color = self.yoga.borderRightColor;
    }
    if (self.yoga.borderEndColor) {
        color = self.yoga.borderEndColor;
    }
    return color;
}
- (UIColor *)zb_bottomColor{
    UIColor *color = [UIColor whiteColor];
    if (self.yoga.borderColor) {
        color = self.yoga.borderColor;
    }
    if (self.yoga.borderBottomColor) {
        color = self.yoga.borderBottomColor;
    }
    return color;
}
- (UIColor *)zb_leftColor{
    UIColor *color = [UIColor whiteColor];
    if (self.yoga.borderColor) {
        color = self.yoga.borderColor;
    }
    if (self.yoga.borderLeftColor) {
        color = self.yoga.borderLeftColor;
    }
    if (self.yoga.borderStartColor) {
        color = self.yoga.borderStartColor;
    }
    return color;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (![self needDrawBorder] || [self isSameBorder]) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    CGSize size = self.frame.size;
    ZBLRoundedRect *borderRect = [[ZBLRoundedRect alloc] initWithRect:bounds
                                                               radius:self.yoga.borderRadius
                                                              topLeft:self.yoga.borderTopLeftRadius
                                                             topRight:self.yoga.borderTopRightRadius
                                                           bottomLeft:self.yoga.borderBottomLeftRadius
                                                          bottomRight:self.yoga.borderBottomRightRadius];
    // here is computed radii, do not use original style
    ZBLRadii *radii = borderRect.radii;
    CGFloat topLeft = radii.topLeftRadiusVal, topRight = radii.topRightRadiusVal, bottomLeft = radii.bottomLeftRadiusVal, bottomRight = radii.bottomRightRadiusVal;
    CGContextSetAlpha(context, 1);
    // fill background color
    if (self.backgroundColor && CGColorGetAlpha(self.backgroundColor.CGColor) > 0) {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        UIBezierPath *bezierPath = [UIBezierPath zblayout_pathWithRoundedRect:bounds
                                                                      topLeft:topLeft
                                                                     topRight:topRight
                                                                   bottomLeft:bottomLeft
                                                                  bottomRight:bottomRight];
        [bezierPath fill];
    }
    CGFloat topWidth = [self zb_topW], rightWidth = [self zb_rightW], bottomWidth = [self zb_bottomW], leftWidth = [self zb_leftW];
    ZBBorderStyle topStyle = [self zb_topStyle], rightStyle = [self zb_rightStyle], bottomStyle = [self zb_bottomStyle], leftStyle = [self zb_leftStyle];
    UIColor *topColor = [self zb_topColor], *rightColor = [self zb_rightColor], *bottomColor = [self zb_bottomColor], *leftColor = [self zb_leftColor];
    // Top
    if (topWidth > 0) {
        if(topStyle == ZBBorderStyleDashed || topStyle == ZBBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (topStyle == ZBBorderStyleDashed ? 3 : 1) * topWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, topWidth);
        CGContextSetStrokeColorWithColor(context, topColor.CGColor);
        CGContextAddArc(context, size.width-topRight, topRight, topRight-topWidth/2, -M_PI_4+(rightWidth>0?0:M_PI_4), -M_PI_2, 1);
        CGContextMoveToPoint(context, size.width-topRight, topWidth/2);
        CGContextAddLineToPoint(context, topLeft, topWidth/2);
        CGContextAddArc(context, topLeft, topLeft, topLeft-topWidth/2, -M_PI_2, -M_PI_2-M_PI_4-(leftWidth>0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    // Left
    if (leftWidth > 0) {
        if(leftStyle == ZBBorderStyleDashed || leftStyle == ZBBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (leftStyle == ZBBorderStyleDashed ? 3 : 1) * leftWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, leftWidth);
        CGContextSetStrokeColorWithColor(context, leftColor.CGColor);
        CGContextAddArc(context, topLeft, topLeft, topLeft-leftWidth/2, -M_PI, -M_PI_2-M_PI_4+(topWidth > 0?0:M_PI_4), 0);
        CGContextMoveToPoint(context, leftWidth/2, topLeft);
        CGContextAddLineToPoint(context, leftWidth/2, size.height-bottomLeft);
        CGContextAddArc(context, bottomLeft, size.height-bottomLeft, bottomLeft-leftWidth/2, M_PI, M_PI-M_PI_4-(bottomWidth>0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    // Bottom
    if (bottomWidth > 0) {
        if(bottomStyle == ZBBorderStyleDashed || bottomStyle == ZBBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (bottomStyle == ZBBorderStyleDashed ? 3 : 1) * bottomStyle;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, bottomWidth);
        CGContextSetStrokeColorWithColor(context, bottomColor.CGColor);
        CGContextAddArc(context, bottomLeft, size.height-bottomLeft, bottomLeft-bottomWidth/2, M_PI-M_PI_4+(leftWidth>0?0:M_PI_4), M_PI_2, 1);
        CGContextMoveToPoint(context, bottomLeft, size.height-bottomWidth/2);
        CGContextAddLineToPoint(context, size.width-bottomRight, size.height-bottomWidth/2);
        CGContextAddArc(context, size.width-bottomRight, size.height-bottomRight, bottomRight-bottomWidth/2, M_PI_2, M_PI_4-(rightWidth > 0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    // Right
    if (rightWidth > 0) {
        if(rightStyle == ZBBorderStyleDashed || rightStyle == ZBBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (rightStyle == ZBBorderStyleDashed ? 3 : 1) * rightWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, rightWidth);
        CGContextSetStrokeColorWithColor(context, rightColor.CGColor);
        CGContextAddArc(context, size.width-bottomRight, size.height-bottomRight, bottomRight-rightWidth/2, M_PI_4+(bottomWidth>0?0:M_PI_4), 0, 1);
        CGContextMoveToPoint(context, size.width-rightWidth/2, size.height-bottomRight);
        CGContextAddLineToPoint(context, size.width-rightWidth/2, topRight);
        CGContextAddArc(context, size.width-topRight, topRight, topRight-rightWidth/2, 0, -M_PI_4-(topWidth > 0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    CGContextStrokePath(context);
}

@end
