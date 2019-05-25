//
//  TYAVCategoryDetailViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/17.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVCategoryDetailViewController.h"
#import "TYHomeModel.h"
#import "TYAVDetailContentCollectionViewCell.h"
#import "TYAVDetailsViewController.h"

#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f
@interface TYAVCategoryDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *newsBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString * orderBy;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) TYHomeModel * homeModel;
@end

@implementation TYAVCategoryDetailViewController
- (IBAction)tabClick:(UIButton *)sender {
    if(_selectBtn == sender) return;
    
    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_selectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    self.lineLab.center = CGPointMake(sender.center.x, self.lineLab.centerY);
    
    if (sender == _newsBtn) {
        self.orderBy = @"1";
    }else {
        self.orderBy = @"2";
    }
    [self headerRefreshRequest];
    
    _selectBtn = sender;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.vClass;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.orderBy = @"1";
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithHeader:self.collectionView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshCollectionWithFooter:self.collectionView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getCollectionListRequestData];
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell"];
}

- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getCollectionListRequestData];
}

- (void)getCollectionListRequestData {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"orderBy":self.orderBy?:@"",
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
//                    self.collectionView.tableHeaderView = [UIView new];
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
    
    TYAVDetailContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell" forIndexPath:indexPath];
    TYHomeItemModel *model = self.dataArr[indexPath.row];
    cell.itemModel = model;
    __block TYAVDetailContentCollectionViewCell *blockCell = cell;
    TYWEAK_SELF;
    cell.itemShouCangBlock = ^() {
        if ([model.cstate isEqualToString:@"0"]) {
            [weakSelf shouCangRequestData:model ContentCell:blockCell];
        }else {
            [weakSelf cancelShouCangRequestData:model ContentCell:blockCell];
        }
    };
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(collectionWidth, collectionWidth*(160/211.f));

}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
    
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
- (void)shouCangRequestData:(TYHomeItemModel *)model ContentCell:(TYAVDetailContentCollectionViewCell *)cell {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":model.ID,
                           @"type":@"1"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/addCollection" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
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
- (void)cancelShouCangRequestData:(TYHomeItemModel *)model ContentCell:(TYAVDetailContentCollectionViewCell *)cell {
    NSDictionary * dic = @{
                           @"uid":[TYGlobal userId],
                           @"tid":model.ID
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TYNetWorkTool postRequest:@"/userCollection/api/delete" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
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
