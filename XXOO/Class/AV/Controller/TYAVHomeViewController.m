//
//  TYAVHomeViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVHomeViewController.h"
#import "TYEntertainmentCollectionViewCell.h"
#import "TYHomeTableViewCell.h"
#import "TYAVDetailsViewController.h"
#import "PYSearch.h"
#import "TYSearchViewController.h"
#import "TYBaseNavigationController.h"
#import "TYHomeModel.h"
#import "TYLongVideoViewController.h"
#import "SDCycleScrollView.h"
#import "TYHomeADListModel.h"

#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f

@interface TYAVHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate> {
    UILabel *_header_lab;
    UIImageView *_header_imgView;
}

@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView * headerView;

@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TYHomeModel * homeModel;
@property (nonatomic, strong) UILabel *header_lab;
@property (nonatomic, strong) UIImageView *header_imgView;
@property (nonatomic, strong) NSDictionary * adDic;
@property (nonatomic, copy) NSArray * adArr;
@property (nonatomic, strong) SDCycleScrollView *advertView;

@end

@implementation TYAVHomeViewController

//筛选
- (IBAction)selectBtnClick:(UIButton *)sender {
    TYLongVideoViewController *vc = [[TYLongVideoViewController alloc] init];
    vc.title = @"全部高清影片";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBackView addTarget:self action:@selector(goSearch)];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    TYWEAK_SELF;
    [TYRefershClass refreshWithHeader:self.tableView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getVideoListRequestData];
    }];
    
    
}

- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getVideoListRequestData];
    [self getAVADRequestData];
}
// 首页广告
- (void)getAVADRequestData {
    NSDictionary * dic = @{
                           
                           @"vClass":self.vClass?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/sysAd/api/getHomeAdList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSArray *arr = [TYHomeADListModel mj_objectArrayWithKeyValuesArray:data];
            if (arr&&arr.count>0) {
                self.adArr = arr;
                [self addTableViewHeaderView];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//初始化接口
- (void)getVideoListRequestData {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"orderBy":@"",
                           @"vCode":@"",
                           @"vClass":self.vClass?:@"",
                           @"vActor":@"",
                           @"vLabel":@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getVideoList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
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
//                    self.tableView.tableHeaderView = [UIView new];
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
- (void)goSearch {
    TYSearchViewController *vc = [[TYSearchViewController alloc] init];
    
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
    
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
        __block TYHomeTableViewCell *blockCell = cell;

        cell.itemShouCangBlock = ^() {
            if ([model.cstate isEqualToString:@"0"]) {
                [weakSelf shouCangRequestData:model ContentCell:blockCell];
            }else {
                [weakSelf cancelShouCangRequestData:model ContentCell:blockCell];
            }
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
- (void)addTableViewHeaderView{
    NSInteger height = 245;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, height)];
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:self.advertView];
    
}
#pragma mark - 轮播图
- (SDCycleScrollView *)advertView {
    // 把图片下载地址数组logoUrlArray 给SDCycleScrollView
    NSMutableArray *logoUrlArray = [[NSMutableArray alloc]initWithCapacity:0];
    if ([self.adArr count] > 0) {
        for (NSInteger i = 0; i < [self.adArr count]; i++) {
            TYHomeADListModel *binnerModel = (TYHomeADListModel *)self.adArr[i];
            [logoUrlArray addObject:[NSURL URLWithString:binnerModel.picUrl]];
        }
    }
    if (!_advertView) {
        NSInteger height = 245;
        _advertView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(13, 10, KSCREEN_WIDTH-26, height-10-20) delegate:self placeholderImage:PLACEHOLEDERIMAGE];
        _advertView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _advertView.currentPageDotColor = [UIColor whiteColor];
    }
    if (logoUrlArray.count<2) {
        _advertView.autoScroll = NO;
    } else {
        _advertView.autoScrollTimeInterval = 4.0f;
    }
    _advertView.imageURLStringsGroup = logoUrlArray;
    
    return _advertView;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TYHomeADListModel *binnerModel = (TYHomeADListModel *)self.adArr[index];
    [TYGlobal openScheme:binnerModel.linkUrl?:@""];
}
//收藏请求
- (void)shouCangRequestData:(TYHomeItemModel *)model ContentCell:(TYHomeTableViewCell *)cell {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":model.ID,
                           @"type":@"1"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/addCollection" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            //            [self headerRefreshRequest];
            [cell.saveBtn setImage:[UIImage imageNamed:@"shoucang_image"] forState:UIControlStateNormal];
            model.cstate = @"1";
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//收藏请求
- (void)cancelShouCangRequestData:(TYHomeItemModel *)model ContentCell:(TYHomeTableViewCell *)cell {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"tid":model.ID
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/delete" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            //            [self headerRefreshRequest];
            [cell.saveBtn setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
            model.cstate = @"0";
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

@end
