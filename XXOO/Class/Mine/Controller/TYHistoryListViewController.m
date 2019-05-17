//
//  TYHistoryListViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYHistoryListViewController.h"
#import "TYAVHistoryModel.h"
#import "TYHistoryListTableViewCell.h"
#import "TYAVDetailsViewController.h"

@interface TYHistoryListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TYHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"播放记录";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
     self.tableView.tableFooterView = [UIView new];
    
    TYWEAK_SELF;
    [TYRefershClass refreshWithHeader:self.tableView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getHistoryListRequestData];
    }];
}
- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getHistoryListRequestData];
}
///userHistory/api/getHistoryList
- (void)getHistoryListRequestData {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/userHistory/api/getHistoryList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success&&data) {
            NSArray *arr = [TYAVHistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
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
                    
                }else {
                    NSLog(@"加载空视图");
                }
                [weakSelf.tableView reloadData];
            }
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
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"listviewid";
    TYHistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TYHistoryListTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYAVHistoryModel *model = self.dataArr[indexPath.row];
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    vc.avID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
