//
//  TYBaseViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYBaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    UIButton *_vipBtn;
}
@end

@implementation TYBaseViewController

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - -[%@ dealloc]", (int)__LINE__, NSStringFromClass([self class]));
#endif
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            tableView.emptyDataSetSource = self;
            tableView.emptyDataSetDelegate = self;
            tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        }else if ([view isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)view;
            collectionView.emptyDataSetSource = self;
            collectionView.emptyDataSetDelegate = self;
        }
    }
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _vipBtn = btn;
//    [btn setImage:[UIImage imageNamed:@"shengjiVIPImage"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(goVIP)];
//    [kWindow addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-kTabBarHeight);
//        make.right.offset(0);
//        make.width.height.offset(100);
//    }];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isHiddenBtn) name:KEY_NEED_SHENGJI_VIP object:nil];
    


}

//- (void)isHiddenBtn {
//    _vipBtn.hidden = YES;
//}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - 视图为空
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ming_shouCang_empty_img"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
// 向上偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -150;
}

@end
