//
//  UIBezierPath+ZBLayout.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import "UIBezierPath+ZBLayout.h"
#import "ZBLayoutUtils.h"

@implementation UIBezierPath (ZBLayout)

// Approximation of control point positions on a bezier to simulate a quarter of a circle.
// This is 1-kappa, where kappa = 4 * (sqrt(2) - 1) / 3
static const float kzblayoutCircleControlPoint = 0.447715;

+ (instancetype)zblayout_pathWithRoundedRect:(CGRect)rect
                                     topLeft:(CGFloat)topLeftRadius
                                    topRight:(CGFloat)topRightRadius
                                  bottomLeft:(CGFloat)bottomLeftRadius
                                 bottomRight:(CGFloat)bottomRightRadius{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if(isnan(topLeftRadius) || isnan(topRightRadius) || isnan(bottomLeftRadius) || isnan(bottomRightRadius)) {
        return path;
    }
    if (![ZBLayoutUtils isValidPoint:rect.origin] || isnan(rect.size.height) || isnan(rect.size.width)) {
        return path;
    }
    CGPoint topLeftPoint = CGPointMake(rect.origin.x + topLeftRadius, rect.origin.y);
    if (![ZBLayoutUtils isValidPoint:topLeftPoint]) {
        return path;
    }
    [path moveToPoint:topLeftPoint];
    
    // +------------------+
    //  \\      top     //
    //   \\+----------+//
    CGPoint topRightPoint = CGPointMake(CGRectGetMaxX(rect) - topRightRadius, rect.origin.y);
    if (![ZBLayoutUtils isValidPoint:topRightPoint]) {
        return path;
    }
    [path addLineToPoint:topRightPoint];
    if (topRightRadius > 0) {
        [path addCurveToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y + topRightRadius)
                controlPoint1:CGPointMake(CGRectGetMaxX(rect) - topRightRadius * kzblayoutCircleControlPoint, rect.origin.y)
                controlPoint2:CGPointMake(CGRectGetMaxX(rect), rect.origin.y + topRightRadius * kzblayoutCircleControlPoint)];
    }
    
    // +------------------+
    //  \\     top      //|
    //   \\+----------+// |
    //                |   |
    //                |rig|
    //                |ht |
    //                |   |
    //                 \\ |
    //                  \\|
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - bottomRightRadius)];
    if (bottomRightRadius > 0) {
        [path addCurveToPoint:CGPointMake(CGRectGetMaxX(rect) - bottomRightRadius, CGRectGetMaxY(rect))
                controlPoint1:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - bottomRightRadius * kzblayoutCircleControlPoint)
                controlPoint2:CGPointMake(CGRectGetMaxX(rect) - bottomRightRadius * kzblayoutCircleControlPoint, CGRectGetMaxY(rect))];
    }
    
    // +------------------+
    //  \\     top      //|
    //   \\+----------+// |
    //                |   |
    //                |rig|
    //                |ht |
    //                |   |
    //   //+----------+\\ |
    //  //    bottom    \\|
    // +------------------+
    [path addLineToPoint:CGPointMake(rect.origin.x + bottomLeftRadius, CGRectGetMaxY(rect))];
    if (bottomLeftRadius > 0) {
        [path addCurveToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect) - bottomLeftRadius)
                controlPoint1:CGPointMake(rect.origin.x + bottomLeftRadius * kzblayoutCircleControlPoint, CGRectGetMaxY(rect))
                controlPoint2:CGPointMake(rect.origin.x, CGRectGetMaxY(rect) - bottomLeftRadius * kzblayoutCircleControlPoint)];
    }
    
    // +------------------+
    // |\\     top      //|
    // | \\+----------+// |
    // |   |          |   |
    // |lef|          |rig|
    // |t  |          |ht |
    // |   |          |   |
    // | //+----------+\\ |
    // |//    bottom    \\|
    // +------------------+
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + topLeftRadius)];
    if (topLeftRadius > 0) {
        [path addCurveToPoint:CGPointMake(rect.origin.x + topLeftRadius, rect.origin.y)
                controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + topLeftRadius * kzblayoutCircleControlPoint)
                controlPoint2:CGPointMake(rect.origin.x + topLeftRadius * kzblayoutCircleControlPoint, rect.origin.y)];
    }
    
    
    return path;
}

@end
