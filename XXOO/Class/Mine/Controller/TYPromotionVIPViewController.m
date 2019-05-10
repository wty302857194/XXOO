//
//  TYPromotionVIPViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYPromotionVIPViewController.h"
#import "TYPromotionVIPTableViewCell.h"
#import "TYPromotionVIPView.h"
#import "TYPromotionVIPModel.h"
#import "TYPromotionVIPFooterView.h"
#import "TYMyPaySelectView.h"
#import "RequestIPAddress.h"

@interface TYPromotionVIPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TYMyPaySelectView * payView;
@property (nonatomic, strong) TYPromotionVIPModel * currentModel;
@end

@implementation TYPromotionVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"升级VIP会员";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_payType_img"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];

    [self addTableViewHeaderView];
    [self addTableFooterView];
    [self getMemberInfoRequestData:@"1"];
}
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTableViewHeaderView {
    TYPromotionVIPView *promotionVIPView = [[[NSBundle mainBundle] loadNibNamed:@"TYPromotionVIPView" owner:nil options:nil] lastObject];
    TYWEAK_SELF;
    promotionVIPView.promotionVIPBlock = ^(NSString * _Nonnull type) {
        [weakSelf getMemberInfoRequestData:type];
    };
    self.tableView.tableHeaderView = promotionVIPView;
    self.tableView.tableHeaderView.autoresizingMask = UIViewAutoresizingNone;

}
- (void)addTableFooterView {
    TYPromotionVIPFooterView *promotionVIPView = [[[NSBundle mainBundle] loadNibNamed:@"TYPromotionVIPFooterView" owner:nil options:nil] lastObject];

    self.tableView.tableFooterView = promotionVIPView;
    self.tableView.tableFooterView.autoresizingMask = UIViewAutoresizingNone;
}
//  /sysMember/api/getMemberInfo
- (void)getMemberInfoRequestData:(NSString *)type {
    
    NSDictionary * dic = @{
                           @"type":type?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/sysMember/api/getMemberInfo" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSArray *arr = [TYPromotionVIPModel mj_objectArrayWithKeyValuesArray:data];
            if (arr&&arr.count>0) {
                weakSelf.dataArr = [NSMutableArray arrayWithArray:arr];

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
    return 70;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"listviewid";
    TYPromotionVIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TYPromotionVIPTableViewCell" owner:nil options:nil] lastObject];
    }
    TYPromotionVIPModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    TYWEAK_SELF;
    cell.paySelectBlock = ^{
        weakSelf.currentModel = model;
        weakSelf.payView.hidden = NO;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
- (TYMyPaySelectView *)payView {
    if (!_payView) {
        _payView = [[[NSBundle mainBundle] loadNibNamed:@"TYMyPaySelectView" owner:nil options:nil] lastObject];
        TYWEAK_SELF;
        _payView.selectBlock = ^(NSInteger index) {
            [weakSelf rechargeRMBRequestData:index==1?@"100036":@"100032"];
        };
        [self.view addSubview:_payView];
        // 同时也要设置tableView的顶部约束
        [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return _payView;
}
- (void)rechargeRMBRequestData:(NSString *)way {
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"rid":self.currentModel.ID,
                           @"money":self.currentModel.money,
                           @"way":way,
                           @"ip":[RequestIPAddress getIPAddress:YES]
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/userRecharge/api/rechargeRMB" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (success&&data) {
            [TYGlobal openScheme:data];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
@end
