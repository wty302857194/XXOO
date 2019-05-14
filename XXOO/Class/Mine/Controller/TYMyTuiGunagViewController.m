//
//  TYMyTuiGunagViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYMyTuiGunagViewController.h"
#import "TYTuiGuangTableViewCell.h"
#import "TYTuiGuangView.h"
#import "TYHelpViewController.h"
#import "TYPaySelectView.h"
#import "TYLevelAgentModel.h"
#import "TYTuiGuangEmptyView.h"
#import "TYSaveCodeViewController.h"
#import "TYTuiGuangHistoryViewController.h"

@interface TYMyTuiGunagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TYTuiGuangView * tuiGuangView;
@property (nonatomic, strong) TYPaySelectView * paySelectView;
@property (nonatomic, strong) TYTuiGuangEmptyView * tuiGuangEmptyView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载

@property (nonatomic, copy) NSString * levelAgent;//代理级别（2代理 3用户）
@end

@implementation TYMyTuiGunagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的推广佣金";
    self.edgesForExtendedLayout =  UIRectEdgeAll;
    self.levelAgent = @"3";
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self spreadRequestData];
    
    UIBarButtonItem *helpItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mine_help_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)];
    helpItem.imageInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    
    UIBarButtonItem *fileItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mine_file_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(fileClick)];
    fileItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.navigationItem.rightBarButtonItems = @[fileItem,helpItem];
    
    TYWEAK_SELF;
    [TYRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf spreadUserRequestData];
    }];
    
    [TYRefershClass refreshWithHeader:self.tableView refreshingBlock:^{
        weakSelf.page = 1;
        weakSelf.isFresh = NO;
        [weakSelf spreadRequestData];
    }];
}
- (void)helpClick {
    
    TYHelpViewController *vc = [[TYHelpViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)fileClick {
    TYTuiGuangHistoryViewController *vc = [[TYTuiGuangHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage jianBianImage] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
}
//  /user/api/spread
- (void)spreadRequestData {
    /*
     {
     todayRechargeMoney: null,             //今日充值金额
     spreadNum: 0,                         //累计推广人数
     todaySpreadMoney: null,               //今日推广金额
     todaySpreadNum: 0,                    //今日推广人数
     spreadMoney: 0,                       //累计推广佣金
     withdrawMoney: 0,                    //可提现金额
     rechargeMoney: 0                      //累计充值金额
     }
     */
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId]
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/spread" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            weakSelf.tuiGuangView.dataDic = [NSDictionary dictionaryWithDictionary:data];
            
            
            [weakSelf spreadUserRequestData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
}
//  /user/api/spreadUser
- (void)spreadUserRequestData {
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"levelAgent":self.levelAgent?:@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/spreadUser" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_footer endRefreshing];

        if (success&&data) {
            NSArray *arr = [TYLevelAgentModel mj_objectArrayWithKeyValuesArray:data];

            if (weakSelf.isFresh) {
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    [weakSelf.tableView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                [weakSelf.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    weakSelf.tableView.tableFooterView = [UIView new];
                }else {
                    NSLog(@"加载空视图");
                    weakSelf.tableView.tableFooterView = self.tuiGuangEmptyView;
                }
                [weakSelf.tableView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
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
    TYTuiGuangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TYTuiGuangTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArr.count>indexPath.row) {
        TYLevelAgentModel *model = self.dataArr[indexPath.row];
        [cell getMessage:model indexPath:indexPath];
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
        _tableView.backgroundColor = hexColor(f0eef5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tuiGuangView;
        _tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingNone;
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
        TYWEAK_SELF;
        _tuiGuangView.tiXianBlock = ^{
            weakSelf.paySelectView.currentMoney = [NSString stringWithFormat:@"%@",weakSelf.tuiGuangView.dataDic[@"withdrawMoney"]];
            weakSelf.paySelectView.hidden = NO;

        };
        _tuiGuangView.levelAgentBlock = ^(NSInteger index) {
            if (index == 1) {
                weakSelf.levelAgent = @"3";
            }else {
                weakSelf.levelAgent = @"2";
            }
            [weakSelf spreadUserRequestData];
        };
    }
    return _tuiGuangView;
}
- (TYPaySelectView *)paySelectView {
    if (!_paySelectView) {
        _paySelectView = [[[NSBundle mainBundle] loadNibNamed:@"TYPaySelectView" owner:nil options:nil] lastObject];
        TYWEAK_SELF;
        _paySelectView.tiXianBlock = ^{
            [weakSelf spreadRequestData];
        };
        [self.view addSubview:_paySelectView];
        
        [_paySelectView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return _paySelectView;
}
//tuiGuangEmptyView
- (TYTuiGuangEmptyView *)tuiGuangEmptyView {
    if (!_tuiGuangEmptyView) {
        _tuiGuangEmptyView = [[[NSBundle mainBundle] loadNibNamed:@"TYTuiGuangEmptyView" owner:nil options:nil] lastObject];
        TYWEAK_SELF;
        _tuiGuangEmptyView.tuiGuangBlcok = ^{
            TYSaveCodeViewController *vc = [[TYSaveCodeViewController alloc] init];
            vc.ID = @"2";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _tuiGuangEmptyView;
}
- (void)emptybBackView {
    
}
@end
