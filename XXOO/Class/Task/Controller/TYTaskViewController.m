//
//  TYTaskViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTaskViewController.h"
#import "TYTaskTableViewCell.h"
#import "TYTaskModel.h"
#import "TYSaveCodeViewController.h"
#import "TYShengJiVIPViewController.h"

@interface TYTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeghtLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackViewLayout;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLab;//推荐
@property (weak, nonatomic) IBOutlet UILabel *integralLab;//积分
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray * dataArr;

@property (nonatomic, strong) MBProgressHUD * hud;
@end

@implementation TYTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.topBackViewLayout.constant = -xkStatusBarHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TYTaskTableViewCell"];
    
    [self getTaskListRequestData];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
    
    NSDictionary *dic = [USER_DEFAULTS objectForKey:USERMESSAGE];
    NSString *str = [NSString stringWithFormat:@"%@",dic[@"level"]];
    if ([str isEqualToString:@"1"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"shengjiVIPImage"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goVIP)];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.right.offset(0);
            make.width.height.offset(100);
        }];
    }
}
- (void)goVIP {
    TYShengJiVIPViewController *vc = [[TYShengJiVIPViewController alloc] init];
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - requestData
// /sysTask/api/getTaskList 初始化接口
- (void)getTaskListRequestData {
    
    [_hud showAnimated:YES];
    [TYNetWorkTool postRequest:@"/sysTask/api/getTaskList" parameters:@{@"id":[TYGlobal userId]} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self.hud hideAnimated:YES];
        if (success&&data) {
            self.dataArr = [TYTaskModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSLog(@"dataArr === %@",self.dataArr);
            self.integralLab.text = [NSString stringWithFormat:@"积分%@",data[@"score"]?:@""];
            self.recommendLab.text = [NSString stringWithFormat:@"已推荐%@人",data[@"spreadNum"]?:@""];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
        
    } failureBlock:^(NSString * _Nonnull description) {
        [self.hud hideAnimated:YES];
    }];
}
//  /user/api/signIn 签到接口
- (void)getSignInRequestData:(TYTaskTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TYTaskModel *model = self.dataArr[indexPath.row];
    
    [_hud showAnimated:YES];
    [TYNetWorkTool postRequest:@"/user/api/signIn" parameters:@{@"id":[TYGlobal userId],@"tid":model.ID} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        
        [self.hud hideAnimated:YES];
        if (success&&data) {
            [self getTaskListRequestData];
        }
        [MBProgressHUD promptMessage:msg inView:self.view];
        
    } failureBlock:^(NSString * _Nonnull description) {
        
        [self.hud hideAnimated:YES];
        
    }];
}
// /user/api/joinGroup   加群接口
- (void)joinGroupRequestData:(NSString *)tid {
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":tid?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/joinGroup" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            
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
    return _dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYTaskTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr&&self.dataArr.count>indexPath.row) {
        TYTaskModel *model = self.dataArr[indexPath.row];
        cell.taskModel = model;
        
        __block TYTaskTableViewCell *currentCell = cell;
        TYWEAK_SELF;
        cell.goPlanBlock = ^{
            if([model.ID isEqualToString:@"1"]) {//签到
                [weakSelf getSignInRequestData:currentCell];
            }else if ([model.ID isEqualToString:@"2"]) {//二维码
                TYSaveCodeViewController *vc = [[TYSaveCodeViewController alloc] init];
                vc.ID = model.ID;
                vc.saveSuccessBlock = ^{
                    [weakSelf getTaskListRequestData];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([model.ID isEqualToString:@"3"]) {//加群
                [TYGlobal openScheme:model.adUrl];
                // 掉加群接口
                [weakSelf joinGroupRequestData:model.ID];
                
            }else if ([model.ID isEqualToString:@"4"]) {//推广新用户
                TYSaveCodeViewController *vc = [[TYSaveCodeViewController alloc] init];
                vc.ID = model.ID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                [TYGlobal openScheme:model.adUrl];
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
