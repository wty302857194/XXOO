//
//  TYGoddessDetailViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGoddessDetailViewController.h"
#import "TYGoddessHeaderView.h"
#import "TYHomeModel.h"
#import "TYHomeTableViewCell.h"
#import "TYAVDetailsViewController.h"

@interface TYGoddessDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TYHomeModel * homeModel;
@end

@implementation TYGoddessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self getActorByIdRequestData];
    
    TYWEAK_SELF;
    [TYRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getVideoListRequestData:weakSelf.title];
    }];
}
/*
 
 {
 avatar: "1",                         //封面
 birthAdress: "1",                    //出生地址
 birthDay: "1",                        //出生日期
 click: 1,                            //点击量
 createTime: "2019-04-20 17:13:07",    //发布时间
 cup: "1",                            //罩杯
 cupId: "1",                            //分类id
 describe: "1",                        //描述
 height: "1",                        //身高
 id: 1,                                //ID
 interest: "1",                        //兴趣
 measurement: "1",                    //三围
 modifyTime: null,                    //
 name: "1",                            //名字
 worksNum: 1                            //作品数量
 }
 
 */
//  /videoActor/api/getActorById
- (void)getActorByIdRequestData {
    NSDictionary * dic = @{
                           @"id":self.ID?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoActor/api/getActorById" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            weakSelf.title = data[@"name"]?:@"";
            [weakSelf addTableHeaderView:data];
            [weakSelf getVideoListRequestData:data[@"name"]?:@""];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//初始化接口
- (void)getVideoListRequestData:(NSString *)vActor {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"orderBy":@"",
                           @"vCode":@"",
                           @"vClass":@"",
                           @"vActor":vActor?:@"",
                           @"vLabel":@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getVideoList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success&&data) {
            weakSelf.homeModel = [TYHomeModel mj_objectWithKeyValues:data];
            NSArray *arr = [NSArray arrayWithArray:weakSelf.homeModel.data];
            
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
//收藏请求
- (void)shouCangRequestData:(TYHomeItemModel *)model {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":model.ID,
                           @"type":@"1"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/addCollection" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:msg inView:self.view];
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)addTableHeaderView:(NSDictionary *)dic {
    TYGoddessHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TYGoddessHeaderView" owner:nil options:nil] lastObject];
    view.dataDic = [NSDictionary nullDic:dic];
    self.tableView.tableHeaderView = view;
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
    return 245;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"TYHomeTableViewCell";
    TYHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TYHomeTableViewCell" owner:nil options:nil].lastObject;
    }
    if (self.dataArr&&self.dataArr.count>indexPath.row) {
        TYHomeItemModel *model = self.dataArr[indexPath.row];
        cell.itemModel = model;
        TYWEAK_SELF;
        cell.itemShouCangBlock = ^() {
            [weakSelf shouCangRequestData:model];
        };
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYHomeItemModel *model = self.dataArr[indexPath.row];
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    vc.avID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
