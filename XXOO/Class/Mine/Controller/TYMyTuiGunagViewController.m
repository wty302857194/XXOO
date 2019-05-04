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

@interface TYMyTuiGunagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TYTuiGuangView * tuiGuangView;
@property (nonatomic, strong) TYPaySelectView * paySelectView;
//@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSMutableArray *dataArr;
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
}
- (void)helpClick {
    
    TYHelpViewController *vc = [[TYHelpViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            weakSelf.tuiGuangView.dataDic = [NSDictionary nullDic:data];
            weakSelf.tableView.tableHeaderView = weakSelf.tuiGuangView;
            weakSelf.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingNone;
            [weakSelf spreadUserRequestData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//  /user/api/spreadUser
- (void)spreadUserRequestData {
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"levelAgent":self.levelAgent?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/user/api/spreadUser" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSArray *arr = [TYLevelAgentModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                [weakSelf.dataArr addObjectsFromArray:arr];
            }else {
                NSLog(@"加载空视图");
            }
            [weakSelf.tableView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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
        TYWEAK_SELF;
        _tuiGuangView.tiXianBlock = ^{
            weakSelf.paySelectView.hidden = NO;
        };
    }
    return _tuiGuangView;
}
- (TYPaySelectView *)paySelectView {
    if (!_paySelectView) {
        _paySelectView = [[[NSBundle mainBundle] loadNibNamed:@"TYPaySelectView" owner:nil options:nil] lastObject];
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
- (void)emptybBackView {
    
}
@end
