//
//  ListCell.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ListCell.h"
#import "MyListCellModel.h"
#import "ZBBorderView.h"

@interface ListCell ()

@property (nonatomic, weak) ZBBorderView *contentView;
@property (nonatomic, weak) UILabel *lb;

@end
@implementation ListCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.marginLeft = YGPointValue(15);
            layout.marginRight = YGPointValue(15);
            layout.height = YGPointValue(100);
            layout.flexDirection = YGFlexDirectionColumn;
        }];
        ZBBorderView *v = [[ZBBorderView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        [self addSubview:v];
        [v configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.padding = YGPointValue(10);
            layout.flexDirection = YGFlexDirectionRow;
            layout.alignItems = YGAlignCenter;
            layout.justifyContent = YGJustifyCenter;
        }];
        self.contentView = v;

        ZBBorderView *bv = [[ZBBorderView alloc] init];
        bv.backgroundColor = [UIColor whiteColor];
        [v addSubview:bv];
        [bv configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.marginRight = YGPointValue(10);
            layout.borderColor = [UIColor blueColor];
            layout.borderWidth = 2;
            layout.borderStyle = ZBBorderStyleDotted;
            layout.borderRadius = YGPointValue(4);
            layout.width = YGPointValue(50);
            layout.height = YGPointValue(20);
        }];

        ZBBorderView *bv2 = [[ZBBorderView alloc] init];
        bv2.backgroundColor = [UIColor whiteColor];
        [v addSubview:bv2];
        [bv2 configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.marginRight = YGPointValue(10);
            layout.borderColor = [UIColor redColor];
            layout.borderWidth = 1;
            layout.borderStyle = ZBBorderStyleSolid;
            layout.borderRadius = YGPointValue(4);
            layout.width = YGPointValue(50);
            layout.height = YGPointValue(20);
        }];

        ZBBorderView *vv = [[ZBBorderView alloc] init];
        vv.backgroundColor = [UIColor whiteColor];
        [v addSubview:vv];
        [vv configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.flexDirection = YGFlexDirectionRow;
            layout.paddingLeft = YGPointValue(20);
            layout.paddingRight = YGPointValue(20);
            layout.borderRadius = YGPercentValue(50);
            layout.height = YGPointValue(50);
            layout.borderWidth = 2;
            layout.borderColor = [UIColor orangeColor];
        }];

        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = [UIColor orangeColor];
        lb.backgroundColor = [UIColor greenColor];
        lb.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [vv addSubview:lb];
        [lb configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.maxWidth = YGPointValue(100);
        }];
        self.lb = lb;
    }
    return self;
}

- (void)setViewModel:(__kindof ZBViewModel *)model{
    MyListCellModel *m = model;
    BOOL isChange = ![self.lb.text isEqualToString:m.text];
    self.lb.text = m.text;
    if (isChange) {
        [self.lb.yoga markDirty];
    }
}

@end
