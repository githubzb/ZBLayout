//
//  ZBLayoutUtils.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBLayoutUtils.h"

@implementation ZBLayoutUtils

+ (BOOL)isValidPoint:(CGPoint)point{
    return !(isnan(point.x)) && !(isnan(point.y));
}
+ (BOOL)isUndefinedOrAuto:(YGValue)value{
    return value.unit==YGUnitUndefined||value.unit==YGUnitAuto;
}
+ (CGFloat)floatValue:(YGValue)value ownerSize:(CGFloat)size{
    switch (value.unit) {
        case YGUnitUndefined:
        case YGUnitAuto:
        case YGUnitPoint:
            return value.value;
        case YGUnitPercent:
            return value.value * size * 0.01;
    }
    return 0;
}

@end
