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

@interface TYTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeghtLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackViewLayout;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *recommendLab;//推荐
@property (weak, nonatomic) IBOutlet UILabel *integralLab;//积分
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray * dataArr;

@end

@implementation TYTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.topBackViewLayout.constant = -xkStatusBarHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TYTaskTableViewCell"];
    
    [self getTaskListRequestData];
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
// /sysTask/api/getTaskList
- (void)getTaskListRequestData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/sysTask/api/getTaskList" parameters:@{@"id":[TYGlobal userId]} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//  /user/api/signIn
- (void)getSignInRequestData:(TYTaskTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TYTaskModel *model = self.dataArr[indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/signIn" parameters:@{@"id":[TYGlobal userId],@"tid":model.ID} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            cell.planBtn.enabled = NO;
//            cell.planBtn.backgroundColor = []
        }
        [MBProgressHUD promptMessage:msg inView:self.view];
        
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
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if ([model.ID isEqualToString:@"3"]) {//加群
                
            }else if ([model.ID isEqualToString:@"4"]) {
                
            }else {
                
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
