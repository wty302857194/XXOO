//
//  TYSearchDetailViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSearchDetailViewController.h"
#import "TYSearchDetailCollectionViewCell.h"
#import "TYAVDetailsViewController.h"
#import "TYHomeModel.h"

#define collectionWidth (KSCREEN_WIDTH-20 -15)/2.0f

@interface TYSearchDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet UIButton *longAVBtn;
//@property (weak, nonatomic) IBOutlet UIButton *shortBtn;
//@property (weak, nonatomic) IBOutlet UILabel *lineLab;
//@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) TYHomeModel * homeModel;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@end

@implementation TYSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"搜索结果";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYSearchDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYSearchDetailCollectionViewCell"];
    
    //    [self headerRefreshRequest];
    
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithHeader:self.collectionView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshCollectionWithFooter:self.collectionView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        
        if (self.vLabel&&self.vLabel.length>0) {
            [self labelSearchRequestData];
        }else {
            [self searchResultRequestData];
        }
    }];
}
- (void)headerRefreshRequest{
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    if (self.vLabel&&self.vLabel.length>0) {
        [self labelSearchRequestData];
    }else {
        [self searchResultRequestData];
    }
}
- (void)labelSearchRequestData {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"orderBy":@"",
                           @"vCode":@"",
                           @"vClass":@"",
                           @"vActor":@"",
                           @"vLabel":self.vLabel?:@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getVideoList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success&&data) {
            weakSelf.homeModel = [TYHomeModel mj_objectWithKeyValues:data];
            NSArray *arr = [NSArray arrayWithArray:weakSelf.homeModel.data];
            
            if (weakSelf.isFresh) {
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    [weakSelf.collectionView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                [weakSelf.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    
                }else {
                    NSLog(@"加载空视图");
                }
                [weakSelf.collectionView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)searchResultRequestData {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"keyWord":self.keyWord?:@"",
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getSearchVideo" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (success&&data) {
            NSArray *arr = [TYHomeItemModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            if (weakSelf.isFresh) {
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    [weakSelf.collectionView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else {
                [weakSelf.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    
                }else {
                    NSLog(@"加载空视图");
                }
                [weakSelf.collectionView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYSearchDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYSearchDetailCollectionViewCell" forIndexPath:indexPath];
    if (self.dataArr&&self.dataArr.count>indexPath.row) {
        TYHomeItemModel *model = self.dataArr[indexPath.row];
        cell.itemModel = model;
        
        TYWEAK_SELF;
        cell.itemShouCangBlock = ^() {
            if ([model.cstate isEqualToString:@"0"]) {
                [weakSelf shouCangRequestData:model];
            }else {
                [weakSelf cancelShouCangRequestData:model];
            }
        };
    }
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionWidth, collectionWidth*(170/211.f));
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 13, 10, 13);
    
} //每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TYHomeItemModel *model = self.dataArr[indexPath.row];
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    vc.avID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
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
        if (success&&data) {
            [self headerRefreshRequest];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//收藏请求
- (void)cancelShouCangRequestData:(TYHomeItemModel *)model {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"tid":model.ID,
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/delete" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            [self headerRefreshRequest];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
@end
