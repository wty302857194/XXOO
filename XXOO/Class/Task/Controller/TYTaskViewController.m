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
    self.topBackViewLayout.constant = -kStatusBarHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYTaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TYTaskTableViewCell"];
    
    [self getTaskListRequestData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - requestData
// /sysTask/api/getTaskList

- (void)getTaskListRequestData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"sysTask/api/getTaskList" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.dataArr = [TYTaskModel mj_objectArrayWithKeyValuesArray:data];
            NSLog(@"dataArr === %@",self.dataArr);
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
