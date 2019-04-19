//
//  Banner.m
//  ZBLayout
//
//  Created by dr.box on 2019/4/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import "Banner.h"
#import "BannerViewModel.h"

@interface Banner ()

@property (nonatomic, weak) UIImageView *imgView;

@end
@implementation Banner

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.flexDirection = YGFlexDirectionColumn;
            layout.padding = YGPointValue(10);
        }];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        self.imgView = imgView;
        [imgView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.aspectRatio = 3;
        }];
    }
    return self;
}

- (void)setViewModel:(__kindof ZBViewModel *)model{
    BannerViewModel *m = model;
    self.imgView.image = m.img;
}

@end
