//
//  ZBHeaderFooterDataSource.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/14.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBHeaderFooterDataSource.h"

@interface ZBHeaderFooterDataSource ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, ZBViewModel *> *source;

@end
@implementation ZBHeaderFooterDataSource

- (void)addModel:(__kindof ZBViewModel *)model atSection:(NSInteger)section{
    if (section<0 || model==nil) {
        return;
    }
    [self.source setObject:model forKey:@(section)];
}

- (void)removeAtSection:(NSInteger)section{
    [self.source removeObjectForKey:@(section)];
}

- (ZBViewModel *)modelAtSection:(NSInteger)section{
    return self.source[@(section)];
}

#pragma mark - private
- (NSMutableDictionary<NSNumber *,ZBViewModel *> *)source{
    if (!_source) {
        _source = [@{} mutableCopy];
    }
    return _source;
}

@end
