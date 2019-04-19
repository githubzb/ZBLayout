//
//  BannerViewModel.m
//  ZBLayout
//
//  Created by dr.box on 2019/4/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import "BannerViewModel.h"
#import "Banner.h"

@implementation BannerViewModel

+ (Class)viewClass{
    return Banner.class;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"jpg"];
        _img = [UIImage imageWithContentsOfFile:path];
    }
    return self;
}

@end
