//
//  HeaderFooterView.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/14.
//  Copyright © 2019 zb. All rights reserved.
//

#import "HeaderFooterView.h"
#import "MyHeaderFooterModel.h"

@implementation HeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.flexDirection = YGFlexDirectionRow;
            layout.flexWrap = YGWrapWrap;
        }];
    }
    return self;
}

- (void)setViewModel:(__kindof ZBViewModel *)model{
    MyHeaderFooterModel *m = model;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<m.count; i++) {
        UIView *v = [[UIView alloc] init];
        if (i%2==0) {
            v.backgroundColor = [UIColor yellowColor];
        }else{
            v.backgroundColor = [UIColor whiteColor];
        }
        [self addSubview:v];
        [v configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.width = YGPercentValue(25);
            layout.aspectRatio = 1;
//            layout.borderRadius = YGPointValue(5);
            layout.borderTopRightRadius = YGPercentValue(10);
            layout.borderBottomRightRadius = YGPercentValue(10);
        }];
    }
}

@end
