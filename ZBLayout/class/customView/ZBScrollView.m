//
//  ZBScrollView.m
//  ZBLayout
//
//  Created by dr.box on 2019/4/18.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBScrollView.h"

@interface ZBScrollView ()

@property (nonatomic, weak) UIScrollView *scroller;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *viewModels;
@property (nonatomic, strong) NSMutableArray *views;

@end
@implementation ZBScrollView

- (instancetype)initWithFrame:(CGRect)frame direction:(ZBScrollDirection)direction{
    self = [self initWithFrame:frame];
    if (self) {
        _direction = direction;
        [_contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            [layout setEnabled:YES];
            layout.flexDirection = direction==ZBHorizontal?YGFlexDirectionRow:YGFlexDirectionColumn;
        }];
    }
    return self;
}

+ (instancetype)newFrame:(CGRect)frame direction:(ZBScrollDirection)direction{
    return [[ZBScrollView alloc] initWithFrame:frame direction:direction];
}

+ (instancetype)newDirection:(ZBScrollDirection)direction{
    return [self newFrame:CGRectZero direction:direction];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScroller];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.scroller.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

- (void)safeAreaInsetsDidChange{
    if (@available(iOS 11.0, *)) {
        [super safeAreaInsetsDidChange];
        CGFloat bottom = self.safeAreaInsets.bottom;
        CGFloat top = self.safeAreaInsets.top;
        UIEdgeInsets safeInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        self.scroller.scrollIndicatorInsets = safeInset;
        self.scroller.contentInset = safeInset;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scroller.frame = self.bounds;
    CGFloat w = CGRectGetWidth(self.scroller.frame);
    CGFloat h = CGRectGetHeight(self.scroller.frame);
    CGSize areaSize;
    YGDimensionFlexibility flexibility;
    if (_direction == ZBHorizontal) {
        areaSize = CGSizeMake(YGUndefined, h);
        flexibility = YGDimensionFlexibilityFlexibleWidth;
    }else{
        areaSize = CGSizeMake(w, YGUndefined);
        flexibility = YGDimensionFlexibilityFlexibleHeight;
    }
    CGSize size = [self.contentView.yoga calculateLayoutWithSize:areaSize];
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.contentView.yoga ZB_applyLayoutPreservingOrigin:NO
                                     dimensionFlexibility:flexibility];
    CGSize contentSize;
    if (_direction == ZBHorizontal) {
        contentSize = CGSizeMake(size.width<w?w:size.width, size.height);
    }else{
        contentSize = CGSizeMake(size.width, size.height<h?h:size.height);
    }
    self.scroller.contentSize = contentSize;
}

- (void)reloadViewModels:(NSArray<ZBViewModel *> *)models{
    [self.viewModels removeAllObjects];
    [self.viewModels addObjectsFromArray:models];
    for (UIView *v in self.views) {
        [v removeFromSuperview];
    }
    [self.views removeAllObjects];
    [self layoutContentViews:nil];
}

- (void)loadViewModels:(NSArray<ZBViewModel *> *)models{
    [self.viewModels addObjectsFromArray:models];
    [self layoutContentViews:models];
}

- (void)reload{
    for (int i=0; i<self.views.count; i++) {
        UIView<ZBViewProtocol> *v = self.views[i];
        if (self.viewModels.count>i) {
            ZBViewModel *m = self.viewModels[i];
            [v setViewModel:m];
        }
    }
    [self setNeedsLayout];
}

- (ZBViewModel *)viewModelAtIndex:(NSUInteger)index{
    if (index<self.viewModels.count) {
        return self.viewModels[index];
    }
    return nil;
}

- (void)layoutContentViews:(NSArray<ZBViewModel *> *)models{
    for (ZBViewModel *m in models? : self.viewModels) {
        UIView<ZBViewProtocol> *view = nil;
        Class cls = [m.class viewClass];
        if ([cls conformsToProtocol:@protocol(ZBViewProtocol)]) {
            view = [[cls alloc] init];
            [self.contentView addSubview:view];
            [self.views addObject:view];
        }else{
            NSAssert(NO, @"ZBViewModel.viewClass not conformsToProtocol <ZBViewProtocol>!");
        }
        if (view) {
            [view setViewModel:m];
        }
    }
    [self setNeedsLayout];
}

- (void)initScroller{
    UIScrollView *scroller = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:scroller];
    self.scroller = scroller;
    UIView *contentView = [[UIView alloc] init];
    [scroller addSubview:contentView];
    self.contentView = contentView;
}

- (NSMutableArray *)viewModels{
    if (!_viewModels) {
        _viewModels = [[NSMutableArray alloc] init];
    }
    return _viewModels;
}
- (NSMutableArray *)views{
    if (!_views) {
        _views = [[NSMutableArray alloc] init];
    }
    return _views;
}

@end
