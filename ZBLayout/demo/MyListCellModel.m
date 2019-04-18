//
//  MyListCellModel.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import "MyListCellModel.h"
#import "ListCell.h"

@implementation MyListCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.selectionColor = [UIColor redColor];
    }
    return self;
}

+ (Class)viewClass{
    return ListCell.class;
}

@end
