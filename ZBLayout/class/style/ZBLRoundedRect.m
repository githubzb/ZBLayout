//
//  ZBLRoundedRect.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBLRoundedRect.h"
#import "ZBLayoutUtils.h"
#import "UIBezierPath+ZBLayout.h"

@interface ZBLRadii ()

@property (nonatomic, assign) YGValue radius;
@property (nonatomic, assign) YGValue topLeftRadius;
@property (nonatomic, assign) YGValue topRightRadius;
@property (nonatomic, assign) YGValue bottomLeftRadius;
@property (nonatomic, assign) YGValue bottomRightRadius;
@property (nonatomic, assign) CGRect rect;

@end
@implementation ZBLRadii

- (instancetype)initWithRadius:(YGValue)radius
                       topLeft:(YGValue)topLeft
                      topRight:(YGValue)topRight
                    bottomLeft:(YGValue)bottomLeft
                   bottomRight:(YGValue)bottomRight
                          rect:(CGRect)rect{
    self = [super init];
    if (self) {
        _radius = radius;
        _topLeftRadius = topLeft;
        _topRightRadius = topRight;
        _bottomLeftRadius = bottomLeft;
        _bottomRightRadius = bottomRight;
        _rect = rect;
    }
    return self;
}

- (BOOL)hasBorderRadius{
    return ![ZBLayoutUtils isUndefinedOrAuto:_radius] ||
    (![ZBLayoutUtils isUndefinedOrAuto:_topLeftRadius] ||
     ![ZBLayoutUtils isUndefinedOrAuto:_topRightRadius] ||
     ![ZBLayoutUtils isUndefinedOrAuto:_bottomLeftRadius] ||
     ![ZBLayoutUtils isUndefinedOrAuto:_bottomRightRadius]);
}

- (BOOL)isAllCircular{
    if ([self hasBorderRadius]) {
        return _topLeftRadiusVal==_topRightRadiusVal &&
        _topRightRadiusVal==_bottomRightRadiusVal &&
        _bottomRightRadiusVal==_bottomLeftRadiusVal &&
        _bottomLeftRadiusVal==_topLeftRadiusVal;
    }
    return NO;
}

- (CAShapeLayer *)circularLayer{
    UIBezierPath *path = [UIBezierPath zblayout_pathWithRoundedRect:_rect
                                                            topLeft:_topLeftRadiusVal
                                                           topRight:_topRightRadiusVal
                                                         bottomLeft:_bottomLeftRadiusVal
                                                        bottomRight:_bottomRightRadiusVal];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = _rect;
    return layer;
}

- (void)calculateWithOwnerSize:(CGSize)size{
    CGFloat ownerSize = MIN(size.width, size.height);
    if (![ZBLayoutUtils isUndefinedOrAuto:_radius]) {
        _topLeftRadiusVal = [ZBLayoutUtils floatValue:_radius ownerSize:ownerSize];
        _topRightRadiusVal = [ZBLayoutUtils floatValue:_radius ownerSize:ownerSize];
        _bottomLeftRadiusVal = [ZBLayoutUtils floatValue:_radius ownerSize:ownerSize];
        _bottomRightRadiusVal = [ZBLayoutUtils floatValue:_radius ownerSize:ownerSize];
    }
    if (![ZBLayoutUtils isUndefinedOrAuto:_topLeftRadius]) {
        _topLeftRadiusVal = [ZBLayoutUtils floatValue:_topLeftRadius ownerSize:ownerSize];
    }
    if (![ZBLayoutUtils isUndefinedOrAuto:_topRightRadius]) {
        _topRightRadiusVal = [ZBLayoutUtils floatValue:_topRightRadius ownerSize:ownerSize];
    }
    if (![ZBLayoutUtils isUndefinedOrAuto:_bottomLeftRadius]) {
        _bottomLeftRadiusVal = [ZBLayoutUtils floatValue:_bottomLeftRadius ownerSize:ownerSize];
    }
    if (![ZBLayoutUtils isUndefinedOrAuto:_bottomRightRadius]) {
        _bottomRightRadiusVal = [ZBLayoutUtils floatValue:_bottomRightRadius ownerSize:ownerSize];
    }
}

- (void)scale:(float)factor{
    if (factor == 1) {
        return;
    }
    _topLeftRadiusVal *= factor;
    _topRightRadiusVal *= factor;
    _bottomLeftRadiusVal *= factor;
    _bottomRightRadiusVal *= factor;
}

@end

@implementation ZBLRoundedRect

- (instancetype)initWithRect:(CGRect)rect
                      radius:(YGValue)radius
                     topLeft:(YGValue)topLeft
                    topRight:(YGValue)topRight
                  bottomLeft:(YGValue)bottomLeft
                 bottomRight:(YGValue)bottomRight{
    self = [super init];
    if (self) {
        _rect = rect;
        _radii = [[ZBLRadii alloc] initWithRadius:radius
                                          topLeft:topLeft
                                         topRight:topRight
                                       bottomLeft:bottomLeft
                                      bottomRight:bottomRight
                                             rect:rect];
        [_radii calculateWithOwnerSize:rect.size];
        [_radii scale:[self radiiConstraintScaleFactor]];
    }
    return self;
}

- (float)radiiConstraintScaleFactor
{
    // Constrain corner radii using CSS3 rules:
    // http://www.w3.org/TR/css3-background/#the-border-radius
    float factor = 1;
    CGFloat radiiSum;
    
    // top
    radiiSum = _radii.topLeftRadiusVal + _radii.topRightRadiusVal;
    if (radiiSum > _rect.size.width) {
        factor = MIN(_rect.size.width / radiiSum, factor);
    }
    
    // bottom
    radiiSum = _radii.bottomLeftRadiusVal + _radii.bottomRightRadiusVal;
    if (radiiSum > _rect.size.width) {
        factor = MIN(_rect.size.width / radiiSum, factor);
    }
    
    // left
    radiiSum = _radii.topLeftRadiusVal + _radii.bottomLeftRadiusVal;
    if (radiiSum > _rect.size.height) {
        factor = MIN(_rect.size.height / radiiSum, factor);
    }
    
    // right
    radiiSum = _radii.topRightRadiusVal + _radii.bottomRightRadiusVal;
    if (radiiSum > _rect.size.height) {
        factor = MIN(_rect.size.height / radiiSum, factor);
    }
    NSAssert(factor <= 1, @"Wrong factor for radii constraint scale");
    return factor;
}

@end
