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

#define collectionWidth (KSCREEN_WIDTH-26 -18)/2.0f

@interface TYSearchDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *longAVBtn;
@property (weak, nonatomic) IBOutlet UIButton *shortBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (nonatomic, strong) UIButton * selectBtn;
//@property (nonatomic, strong) TYHomeItemModel * itemModel;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, assign) BOOL isFresh;//是否加载
@end

@implementation TYSearchDetailViewController
- (IBAction)tabTouch:(UIButton *)sender {
    if (sender == _selectBtn) return;
    
    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_selectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    self.lineLab.center = CGPointMake(sender.center.x, self.lineLab.centerY);
    
    if (sender == _longAVBtn) {
        
    }else {
        
    }
    
    _selectBtn = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"搜索结果";
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYSearchDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYSearchDetailCollectionViewCell"];

}
- (void)searchResultRequestData {
    NSDictionary * dic = @{
                           @"keyWord":self.keyWord?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/video/api/getSearchVideo" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success&&data) {
            NSArray *arr = [TYHomeItemModel mj_objectArrayWithKeyValuesArray:data];
            
            if (arr&&arr.count>0) {
                weakSelf.dataArr = [NSMutableArray arrayWithArray:arr];
            }else {
                NSLog(@"加载空视图");
            }
            [weakSelf.collectionView reloadData];
            
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
    cell.backgroundColor = [UIColor redColor];
    return cell;

}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionWidth, collectionWidth*(540/328.f));
    
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

@end
