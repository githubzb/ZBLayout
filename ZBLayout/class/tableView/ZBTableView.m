//
//  ZBTableView.m
//  ZBLayout
//
//  Created by dr.box on 2019/3/13.
//  Copyright © 2019 zb. All rights reserved.
//

#import "ZBTableView.h"
#import <YogaKit/YGLayout+Private.h>

#define boxHeaderTag 1829
#define boxFooterTag 1128
#define defaultHeaderTag 1980
#define zbContentViewTag 1573

//计算视图高度
#define ReturnViewHeight if (m && [[m.class viewClass] conformsToProtocol:@protocol(ZBViewProtocol)]) { \
if (m.useSizeCache) { \
    return m.size.height; \
} \
Class cls = [m.class viewClass]; \
UIView<ZBViewProtocol> *view = [[cls alloc] init]; \
[view setViewModel:m]; \
UIView *boxView = [[UIView alloc] init]; \
[boxView addSubview:view]; \
[boxView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) { \
    [layout setEnabled:YES]; \
    layout.flexDirection = YGFlexDirectionColumn; \
}]; \
CGFloat w = CGRectGetWidth(tableView.frame); \
CGSize size = [boxView.yoga calculateLayoutWithSize:CGSizeMake(w, YGUndefined)]; \
m.size = size; \
m.useSizeCache = YES; \
return size.height; \
}

//初始化Header or Footer视图
#define installHeaderOrFooter if (m && [[m.class viewClass] conformsToProtocol:@protocol(ZBViewProtocol)]) { \
NSString *identifier = NSStringFromClass([m.class viewClass]); \
UITableViewHeaderFooterView *headerFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier]; \
UIView<ZBViewProtocol> *view = [headerFooter.contentView viewWithTag:zbContentViewTag]; \
if (!view) { \
    Class cls = [m.class viewClass]; \
    view = [[cls alloc] init]; \
    view.tag = zbContentViewTag; \
    [headerFooter.contentView addSubview:view]; \
    [headerFooter.contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) { \
        [layout setEnabled:YES]; \
        layout.flexDirection = YGFlexDirectionColumn; \
    }]; \
} \
[view setViewModel:m]; \
CGFloat w = CGRectGetWidth(tableView.frame); \
CGFloat h = [self tableView:tableView heightForHeaderInSection:section]; \
headerFooter.contentView.frame = CGRectMake(0, 0, w, h); \
[headerFooter.contentView.yoga ZB_applyLayoutPreservingOrigin:NO]; \
headerFooter.contentView.backgroundColor = view.backgroundColor; \
return headerFooter; \
}


@interface ZBTableView ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableView *tableView;

/**
 cell数据源
 */
@property (nonatomic, strong) ZBDataSource *source;

/**
 Header数据源
 */
@property (nonatomic, strong) ZBHeaderFooterDataSource *headerSource;

/**
 Header数据源
 */
@property (nonatomic, strong) ZBHeaderFooterDataSource *footerSource;

@end
@implementation ZBTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        ZBDataSource *source = [[ZBDataSource alloc] init];
        self.source = source;
        ZBHeaderFooterDataSource *headerSource = [[ZBHeaderFooterDataSource alloc] init];
        self.headerSource = headerSource;
        ZBHeaderFooterDataSource *footerSource = [[ZBHeaderFooterDataSource alloc] init];
        self.footerSource = footerSource;
        [self installTableWithStyle:UITableViewStylePlain];
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        ZBDataSource *source = [[ZBDataSource alloc] init];
        self.source = source;
        ZBHeaderFooterDataSource *headerSource = [[ZBHeaderFooterDataSource alloc] init];
        self.headerSource = headerSource;
        ZBHeaderFooterDataSource *footerSource = [[ZBHeaderFooterDataSource alloc] init];
        self.footerSource = footerSource;
        [self installTableWithStyle:UITableViewStylePlain];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (instancetype)initWithDataSource:(ZBDataSource *)source
                             style:(UITableViewStyle)style{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        if (source) {        
            self.source = source;
        }
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.tableView.backgroundColor = backgroundColor;
    if (self.tableView.tableHeaderView.tag != boxHeaderTag &&
        self.tableView.tableHeaderView.tag != defaultHeaderTag) {
        self.tableView.tableHeaderView.backgroundColor = backgroundColor;
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    if (self.tableView.tableHeaderView.tag==boxHeaderTag) {
        //重新布局
        UIView *subView = [[self.tableView.tableHeaderView subviews] firstObject];
        [subView removeFromSuperview];
        [self setHeaderView:subView];
    }
    if (self.tableView.tableFooterView.tag==boxFooterTag) {
        //重新布局
        UIView *subView = [[self.tableView.tableFooterView subviews] firstObject];
        [subView removeFromSuperview];
        [self setFooterView:subView];
    }
}

- (void)safeAreaInsetsDidChange{
    if (@available(iOS 11.0, *)) {
        [super safeAreaInsetsDidChange];
        CGFloat bottom = self.safeAreaInsets.bottom;
        CGFloat top = self.safeAreaInsets.top;
        UIEdgeInsets safeInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        self.tableView.scrollIndicatorInsets = safeInset;
        self.tableView.contentInset = safeInset;
    }
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    //确保当前视图在window中显示了在加载数据
    if (!self.tableView.dataSource) {
        self.tableView.dataSource = self;
    }
    if (!self.tableView.delegate) {
        self.tableView.delegate = self;
    }
    //此处兼容xib初始化的情况
    self.tableView.separatorStyle = self.separatorStyle;
    self.tableView.separatorStyle = self.separatorStyle;
    self.tableView.separatorColor = self.separatorColor;
    self.tableView.separatorEffect = self.separatorEffect;
    self.tableView.separatorInset = self.separatorInset;
}

- (void)setStyle:(UITableViewStyle)style{
    [self.tableView removeFromSuperview];
    [self installTableWithStyle:style];
    self.tableView.frame = self.bounds;
}
- (void)setHeaderView:(UIView *)view{
    if (!view.yoga.isEnabled) {
        //兼容非yogakit布局
        self.tableView.tableHeaderView = view;
        return;
    }
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0)];
    boxView.tag = boxHeaderTag;
    boxView.clipsToBounds = YES;
    [boxView addSubview:view];
    [boxView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.flexDirection = YGFlexDirectionColumn;
    }];
    [boxView.yoga ZB_applyLayoutPreservingOrigin:NO
                            dimensionFlexibility:YGDimensionFlexibilityFlexibleHeight];
    self.tableView.tableHeaderView = boxView;
}
- (void)setFooterView:(UIView *)view{
    if (!view.yoga.isEnabled) {
        //兼容非yogakit布局
        self.tableView.tableFooterView = view;
        return;
    }
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0)];
    boxView.tag = boxFooterTag;
    boxView.clipsToBounds = YES;
    [boxView addSubview:view];
    [boxView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        [layout setEnabled:YES];
        layout.flexDirection = YGFlexDirectionColumn;
    }];
    [boxView.yoga ZB_applyLayoutPreservingOrigin:NO
                            dimensionFlexibility:YGDimensionFlexibilityFlexibleHeight];
    self.tableView.tableFooterView = boxView;
}

- (id<ZBViewProtocol>)headerViewForSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [self.tableView headerViewForSection:section];
    if (header && [[header.contentView viewWithTag:zbContentViewTag] conformsToProtocol:@protocol(ZBViewProtocol)]) {
        return [header.contentView viewWithTag:zbContentViewTag];
    }
    return nil;
}

- (id<ZBViewProtocol>)footerViewForSection:(NSInteger)section{
    UITableViewHeaderFooterView *footer = [self.tableView footerViewForSection:section];
    if (footer && [[footer.contentView viewWithTag:zbContentViewTag] conformsToProtocol:@protocol(ZBViewProtocol)]) {
        return [footer.contentView viewWithTag:zbContentViewTag];
    }
    return nil;
}

- (void)registerCellViewClass:(Class)cls{
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass(cls)];
}

- (void)registerHeaderFooterViewClass:(Class)cls{
    [self.tableView registerClass:[UITableViewHeaderFooterView class]
forHeaderFooterViewReuseIdentifier:NSStringFromClass(cls)];
}

- (void)reloadData{
    [self.tableView reloadData];
}

#pragma mark - private
//初始化tableview
- (void)installTableWithStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:style];
    tableView.separatorStyle = _separatorStyle;
    tableView.separatorColor = _separatorColor;
    tableView.separatorEffect = _separatorEffect;
    tableView.separatorInset = _separatorInset;
    if (style == UITableViewStyleGrouped) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        header.backgroundColor = self.backgroundColor;
        header.tag = defaultHeaderTag;
        tableView.tableHeaderView = header;//这里是为了去掉系统默认的header高度
    }
    tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
    }
    [self addSubview:tableView];
    self.tableView = tableView;
}
- (void)didTapView{
    [self endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![touch.view conformsToProtocol:@protocol(UIKeyInput)] &&
        ![touch.view isKindOfClass:[UIControl class]] &&
        self.tapTableEndEditing) {
        [self didTapView];
    }
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.source.sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source rowCountAtSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBViewModel *m = [self.source modelAtIndexPath:indexPath];
    NSString *identifier = NSStringFromClass([m.class viewClass]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    UIView<ZBViewProtocol> *view = [cell.contentView viewWithTag:zbContentViewTag];
    if (!view) {
        Class cls = [m.class viewClass];
        if ([cls conformsToProtocol:@protocol(ZBViewProtocol)]) {
            view = [[cls alloc] init];
            view.tag = zbContentViewTag;
            [cell.contentView addSubview:view];
            [cell.contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
                [layout setEnabled:YES];
                layout.flexDirection = YGFlexDirectionColumn;
            }];
        }
    }
    if (view) {
        [view setViewModel:m];
        [cell.contentView.yoga ZB_applyLayoutPreservingOrigin:NO];
        cell.contentView.backgroundColor = view.backgroundColor;
    }
    if (m.selectionColor) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        UIView *v = [[UIView alloc] initWithFrame:cell.frame];
        v.backgroundColor = m.selectionColor;
        cell.selectedBackgroundView = v;
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.delegate tableView:self canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectCellModel:)]) {
        ZBViewModel *m = [self.source modelAtIndexPath:indexPath];
        [self.delegate tableView:self didSelectCellModel:m];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBViewModel *m = [self.source modelAtIndexPath:indexPath];
    ReturnViewHeight
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    ZBViewModel *m = [self.headerSource modelAtSection:section];
    ReturnViewHeight
    return tableView.style == UITableViewStyleGrouped?0.001:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    ZBViewModel *m = [self.footerSource modelAtSection:section];
    ReturnViewHeight
    return tableView.style == UITableViewStyleGrouped?0.001:0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZBViewModel *m = [self.headerSource modelAtSection:section];
    installHeaderOrFooter
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ZBViewModel *m = [self.footerSource modelAtSection:section];
    installHeaderOrFooter
    return nil;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        return [self.delegate tableView:self editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate tableView:self
              commitEditingStyle:editingStyle
               forRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.delegate scrollViewDidZoom:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.delegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.delegate scrollViewDidScrollToTop:scrollView];
    }
}
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
        if (@available(iOS 11.0, *)) {
            [self.delegate scrollViewDidChangeAdjustedContentInset:scrollView];
        } else {
            // Fallback on earlier versions
        }
    }
}

@end
