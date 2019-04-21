//
//  TYMyTuiGunagViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYMyTuiGunagViewController.h"
#import "TYTuiGuangView.h"

@interface TYMyTuiGunagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TYTuiGuangView * tuiGuangView;
@end

@implementation TYMyTuiGunagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的推广佣金";
    self.edgesForExtendedLayout =  UIRectEdgeAll;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.tableView.tableHeaderView = self.tuiGuangView;
    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingNone;
    
    
    UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mine_help_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)];
    helpItem.imageInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    
    UIBarButtonItem *fileItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mine_file_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(fileClick)];
    fileItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.navigationItem.rightBarButtonItems = @[fileItem,helpItem];
}
- (void)helpClick {
    
}
- (void)fileClick {
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 导航栏不透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 5;//_dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"listviewid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        float totalOffset = 333 + fabsf(offsetY);
        
        float f = totalOffset / 333.f;
        self.tuiGuangView.tuiGuangBackImg.frame = CGRectMake(-KSCREEN_WIDTH * (f - 1) * 0.5, offsetY, KSCREEN_WIDTH * f, totalOffset);
        [self.tuiGuangView.tuiGuangBackImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(offsetY);
        }];
    }
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        // 同时也要设置tableView的顶部约束
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0,*)) {
                make.top.equalTo(self.view.mas_top);
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            } else {
                make.edges.equalTo(self.view);
            }
            
        }];
        
        
    }
    return _tableView;
}
- (TYTuiGuangView *)tuiGuangView {
    if (!_tuiGuangView) {
        _tuiGuangView = [[[NSBundle mainBundle] loadNibNamed:@"TYTuiGuangView" owner:nil options:nil] lastObject];
    }
    return _tuiGuangView;
}

- (void)emptybBackView {
    
}
@end
