//
//  MyListCellModel.h
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyListCellModel : ZBViewModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
