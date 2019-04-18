//
//  UIView+zbyoga.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import "UIView+zbyoga.h"
#import <YogaKit/YGLayout+Private.h>
#import <objc/runtime.h>

@implementation UIView (zbyoga)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(removeFromSuperview)
                 withMethod:@selector(zb_removeFromSupperView)];
    });
}

+ (BOOL)swizzleMethod:(SEL)originalSelector
          withMethod:(SEL)swizzledSelector{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

- (void)setLayoutFinish:(ZBLayoutFinishBlock)layoutFinish{
    if (layoutFinish) {
        NSArray *arr = [NSArray arrayWithObject:layoutFinish];
        objc_setAssociatedObject(self, @selector(layoutFinish), arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (ZBLayoutFinishBlock)layoutFinish{
    NSArray *arr = objc_getAssociatedObject(self, @selector(layoutFinish));
    if (arr.count>0) {
        return arr.firstObject;
    }
    return nil;
}

#pragma mark - swizzleMethod
- (void)zb_removeFromSupperView{
    if (self.superview && self.superview.isYogaEnabled) {
        YGNodeRemoveAllChildren(self.superview.yoga.node);
    }
    [self zb_removeFromSupperView];
}

@end
