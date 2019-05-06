//
//  TYMyCollectionViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYMyCollectionViewController.h"
#import "TYAVHistoryModel.h"
#import "TYMyCollectionCollectionViewCell.h"
#import "TYGoddessCollectionViewCell.h"
#import "TYAVDetailsViewController.h"
#import "TYGoddessDetailViewController.h"

#define av_collectionWidth (KSCREEN_WIDTH-20-30)/3.0f
#define collectionWidth (KSCREEN_WIDTH-20-45)/4.0f
@interface TYMyCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *avBtn;
@property (weak, nonatomic) IBOutlet UIButton *angelBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, strong) UIButton * selectBtn;
@end

@implementation TYMyCollectionViewController
- (IBAction)tabClick:(UIButton *)sender {
    if(_selectBtn == sender) return;
    
    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_selectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    self.lineLab.center = CGPointMake(sender.center.x, self.lineLab.centerY);
    
    if (sender == _avBtn) {
        self.type = @"1";
    }else {
        self.type = @"2";
    }
    [self headerRefreshRequest];
    
    _selectBtn = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的收藏";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.type = @"1";
    TYWEAK_SELF;
    [TYRefershClass refreshCollectionWithHeader:self.collectionView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [TYRefershClass refreshCollectionWithFooter:self.collectionView refreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isFresh = YES;
        [weakSelf getCollectionListRequestData];
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYMyCollectionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYMyCollectionCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYGoddessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYGoddessCollectionViewCell"];
}
- (void)headerRefreshRequest {
    [self.dataArr removeAllObjects];
    self.page = 1;
    self.isFresh = NO;
    [self getCollectionListRequestData];
}

- (void)getCollectionListRequestData {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"type":self.type,
                           @"pageNum":@(self.page),
                           @"limit":@"20"
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/userCollection/api/getCollectionList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success&&data) {
            NSArray *arr = [TYAVHistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
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
    if ([self.type isEqualToString:@"1"]) {
        TYMyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYMyCollectionCollectionViewCell" forIndexPath:indexPath];
        if (self.dataArr&&self.dataArr.count>indexPath.row) {
            TYAVHistoryModel *model = self.dataArr[indexPath.row];
            cell.collectionModel = model;
        }
        
        return cell;
    }
    TYGoddessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYGoddessCollectionViewCell" forIndexPath:indexPath];
    if (self.dataArr&&self.dataArr.count>indexPath.row) {
        TYAVHistoryModel *model = self.dataArr[indexPath.row];
        cell.goddessModel = model;
        cell.collectionBtn.hidden = YES;
        
    }
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type isEqualToString:@"1"]) {
        return CGSizeMake(av_collectionWidth, av_collectionWidth*(299/211.f));
        
    }
    return CGSizeMake(collectionWidth, collectionWidth*(213/150.f));
    
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
    if ([self.type isEqualToString:@"1"]) {
        TYAVHistoryModel *model = self.dataArr[indexPath.row];
        TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
        vc.avID = model.tid;
        [self.navigationController pushVC:vc animated:YES];
    }else {
        TYAVHistoryModel *model = self.dataArr[indexPath.row];

        TYGoddessDetailViewController *vc = [[TYGoddessDetailViewController alloc] init];
        vc.ID = model.tid;
        [self.navigationController pushVC:vc animated:YES];
    }
    
}

@end
