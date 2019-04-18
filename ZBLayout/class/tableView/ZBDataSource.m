//
//  ZBDataSource.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBDataSource.h"
#import <UIKit/NSIndexPath+UIKitAdditions.h>

#define GetCurrRows NSMutableArray *rows = nil;\
if (section<self.sectionCount) { \
rows = self.source[section]; \
}else{ \
    for (int i=(int)(section-self.sectionCount); i>=0; i--) { \
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1]; \
        [self.source addObject:arr]; \
        if (i==0) { \
            rows = arr; \
        } \
    } \
}

@interface ZBDataSource()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<ZBViewModel *> *> *source;

@end
@implementation ZBDataSource

- (NSUInteger)sectionCount{
    return self.source.count;
}
- (NSUInteger)rowCountAtSection:(NSInteger)section{
    return self.source[section].count;
}
- (void)addModel:(ZBViewModel *)model atSection:(NSInteger)section{
    if (section<0 || model==nil) {
        return;
    }
    GetCurrRows
    [rows addObject:model];
}
- (void)insertModel:(ZBViewModel *)model
         atRowIndex:(NSInteger)row
          atSection:(NSInteger)section{
    if (row<0 || section<0 || model==nil) {
        return;
    }
    GetCurrRows
    if (row<rows.count) {
        [rows insertObject:model atIndex:row];
    }else{
        [rows addObject:model];
    }
}
- (void)addModels:(NSArray<ZBViewModel *> *)models
        atSection:(NSInteger)section{
    if (section<0 || models.count==0) {
        return;
    }
    GetCurrRows
    [rows addObjectsFromArray:models];
}
- (void)removeAtRowIndex:(NSInteger)row atSection:(NSInteger)section{
    if (section<0 || row<0 || section>=self.sectionCount) {
        return;
    }
    NSMutableArray *rows = self.source[section];
    if (row<rows.count) {
        [rows removeObjectAtIndex:row];
    }
}
- (void)removeAtSection:(NSInteger)section{
    if (section<0 || section>=self.sectionCount) {
        return;
    }
    NSMutableArray *rows = self.source[section];
    [rows removeAllObjects];
}
- (void)removeAll{
    [self.source removeAllObjects];
}

- (void)updateModel:(ZBViewModel *)model atRowIndex:(NSInteger)row atSection:(NSInteger)section{
    if (row<0 || section<0 || section>=self.sectionCount || model==nil) {
        return;
    }
    NSMutableArray *rows = self.source[section];
    if (row<rows.count) {
        [rows replaceObjectAtIndex:row withObject:model];
    }
}

- (void)updateModels:(NSArray<ZBViewModel *> *)models atSection:(NSInteger)section{
    if (section<0 || section>=self.sectionCount || models.count==0) {
        return;
    }
    NSMutableArray *rows = [models mutableCopy];
    [self.source replaceObjectAtIndex:section withObject:rows];
}

- (ZBViewModel *)modelAtRow:(NSInteger)row atSection:(NSInteger)section{
    if (section<0 || row<0 || section>=self.sectionCount) {
        return nil;
    }
    NSMutableArray *rows = self.source[section];
    if (row<rows.count) {
        return rows[row];
    }
    return nil;
}
- (ZBViewModel *)modelAtIndexPath:(NSIndexPath *)path{
    return [self modelAtRow:path.row atSection:path.section];
}

- (NSArray<ZBViewModel *> *)modelsAtSection:(NSInteger)section{
    if (section<0 || section>=self.sectionCount) {
        return nil;
    }
    NSMutableArray *rows = self.source[section];
    return [NSArray arrayWithArray:rows];
}

- (ZBViewModel *)modelWithTag:(NSString *)tag atSection:(NSInteger)section{
    NSArray *arr = [self modelsWithTag:tag atSection:section];
    return [arr lastObject];
}

- (NSArray<ZBViewModel *> *)modelsWithTag:(NSString *)tag atSection:(NSInteger)section{
    if (section<0 || section>=self.sectionCount) {
        return nil;
    }
    NSMutableArray *rows = self.source[section];
    return [self fetchModels:rows withTag:tag];
}

#pragma mark - private
- (NSMutableArray<NSMutableArray<ZBViewModel *> *> *)source{
    if (!_source) {
        _source = [@[] mutableCopy];
    }
    return _source;
}
- (NSArray *)fetchModels:(NSArray *)models withTag:(NSString *)tag{
    if (models.count==0) {
        return nil;
    }
    NSPredicate *pre = nil;
    if (tag) {
        pre = [NSPredicate predicateWithFormat:@"tag==%@", [tag description]];
    }else{
        pre = [NSPredicate predicateWithFormat:@"tag==NIL"];
    }
    return [models filteredArrayUsingPredicate:pre];
}

@end
