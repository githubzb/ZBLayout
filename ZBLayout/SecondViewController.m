//
//  SecondViewController.m
//  ZBLayout
//
//  Created by dr.box on 2019/4/12.
//  Copyright © 2019 zb. All rights reserved.
//

#import "SecondViewController.h"
#import "ZBViewProtocol.h"


@interface SecondViewController ()

@property (nonatomic, weak) UIView *myView;

@end

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"---dealloc----SecondViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    self.myView = view;
    [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.width = YGPointValue(200);
        layout.height = YGPointValue(150);
        layout.borderRadius = YGPercentValue(50);
    }];
    [view setLayoutFinish:^(__kindof UIView * _Nonnull v) {
        v.backgroundColor = [UIColor greenColor];
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [btn addTarget:self
            action:@selector(gobackpage)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.width = YGPercentValue(50);
        layout.height = YGPointValue(40);
        layout.marginTop = YGPointValue(20);
    }];
    
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.justifyContent = YGJustifyCenter;
        layout.alignItems = YGAlignCenter;
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"jpg"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:imgView];
    [imgView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.width = YGPointValue(200);
        layout.aspectRatio = 3;
        layout.marginTop = YGPointValue(10);
        layout.borderRadius = YGPointValue(10);
    }];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.view.yoga ZB_applyLayoutPreservingOrigin:NO];
}

- (void)gobackpage{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
