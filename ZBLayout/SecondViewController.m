//
//  SecondViewController.m
//  ZBLayout
//
//  Created by dr.box on 2019/4/12.
//  Copyright © 2019 zb. All rights reserved.
//

#import "SecondViewController.h"
#import "ZBScrollView.h"
#import "BannerViewModel.h"

@interface SecondViewController ()

@property (nonatomic, weak) ZBScrollView *scrollView;

@end

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"---dealloc----SecondViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.flexDirection = YGFlexDirectionColumn;
    }];
    
    ZBScrollView *scrollView = [ZBScrollView newDirection:ZBVertical];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.width = YGPercentValue(100);
        layout.height = YGPointValue([UIScreen mainScreen].bounds.size.height);
        layout.padding = YGPointValue(20);
        layout.flexDirection = YGFlexDirectionColumn;
        layout.justifyContent = YGJustifyCenter;
        layout.alignItems = YGAlignCenter;
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<30; i++) {
        BannerViewModel *m = [[BannerViewModel alloc] init];
        [arr addObject:m];
    }
    [scrollView reloadViewModels:arr];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bbb" ofType:@"jpeg"];
        BannerViewModel *m = [self.scrollView viewModelAtIndex:2];
        m.img = [UIImage imageWithContentsOfFile:path];
        [self.scrollView reload];
        
    });
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.view.yoga ZB_applyLayoutPreservingOrigin:NO];
}

- (void)gobackpage{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
