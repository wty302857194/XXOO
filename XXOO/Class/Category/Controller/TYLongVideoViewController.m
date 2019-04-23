//
//  TYLongVideoViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYLongVideoViewController.h"
#import "TYAVDetailsViewController.h"
#import "TYAVDetailContentCollectionViewCell.h"


#define collectionWidth (KSCREEN_WIDTH-20-15)/2.0f

@interface TYLongVideoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIView * topBackView;
//@property (nonatomic, strong) UIScrollView * middleSV;
//@property (nonatomic, strong) UIScrollView * bottomSV;
@property (nonatomic, copy) NSArray * zuiDuoArr;//最新
@property (nonatomic, copy) NSArray * sliceArr;//全部片种
@property (nonatomic, copy) NSArray * allArr;//全部
@end

@implementation TYLongVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topBackView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYAVDetailContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell"];
}
#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TYAVDetailContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYAVDetailContentCollectionViewCell" forIndexPath:indexPath];
    
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
    TYAVDetailsViewController *vc = [[TYAVDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
        [self.view addSubview:_topBackView];
        [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            else make.top.offset(0);
            make.left.right.offset(0);
            make.height.offset(110);
        }];
        UIButton *selectBtn = nil;
        for (int i =0; i<self.zuiDuoArr.count; i++) {
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",self.zuiDuoArr[i]] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(zuiduoClick:)];
            if (i == 0) {
                btn.borderColor = main_select_text_color;
                btn.borderWidth = 1;
            }
            btn.cornerRadius = 13;
            [_topBackView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                if (selectBtn) {
                    make.left.equalTo(selectBtn.mas_right).offset(10);
                }else {
                    make.left.offset(10);
                }
                make.height.offset(26);
            }];
            selectBtn = btn;
        }
        
        
        UIScrollView *middleSV = [[UIScrollView alloc] init];
        [_topBackView addSubview:middleSV];
        [middleSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBtn.mas_bottom).offset(5);
            make.left.right.offset(0);
            make.height.offset(26);
        }];
        
        UIButton *selectSliceBtn = nil;
        for (int i =0; i<self.sliceArr.count; i++) {
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",self.sliceArr[i]] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(zuiduoClick:)];
//            btn.borderColor = main_select_text_color;
//            btn.borderWidth = 1;
            btn.cornerRadius = 13;
            [middleSV addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                if (selectSliceBtn) {
                    make.left.equalTo(selectSliceBtn.mas_right).offset(10);
                }else {
                    make.left.offset(10);
                }
                make.height.offset(26);
            }];
            selectSliceBtn = btn;
        }
        [_topBackView layoutIfNeeded];
        
        middleSV.contentSize = CGSizeMake(selectSliceBtn.right+10, middleSV.height);
        
        
        UIScrollView *bottomSV = [[UIScrollView alloc] init];
        [_topBackView addSubview:bottomSV];
        [bottomSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleSV.mas_bottom).offset(5);
            make.left.right.offset(0);
            make.height.offset(26);
        }];
        
        UIButton *selectAllBtn = nil;
        for (int i =0; i<self.allArr.count; i++) {
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",self.allArr[i]] titleColor:i==0?main_select_text_color:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(zuiduoClick:)];
//            btn.borderColor = main_select_text_color;
//            btn.borderWidth = 1;
            btn.cornerRadius = 13;
            [bottomSV addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                if (selectAllBtn) {
                    make.left.equalTo(selectAllBtn.mas_right).offset(10);
                }else {
                    make.left.offset(10);
                }
                make.height.offset(26);
            }];
            selectAllBtn = btn;
        }
        [_topBackView layoutIfNeeded];
        
        bottomSV.contentSize = CGSizeMake(selectAllBtn.right+10, bottomSV.height);
    }
    return _topBackView;
}

- (NSArray *)zuiDuoArr {
    if (!_zuiDuoArr) {
        _zuiDuoArr = @[@"最多播放",@"最近更新"];
    }
    return _zuiDuoArr;
}
- (NSArray *)sliceArr {
    if (!_sliceArr) {
        _sliceArr = @[@"最多播放",@"最近更新",@"最近更新",@"最近更新",@"最近更新",@"最近更新",@"最近更新"];
    }
    return _sliceArr;
}
- (NSArray *)allArr {
    if (!_allArr) {
        _allArr = @[@"最多播放",@"最近更新",@"最近更新",@"最近更新",@"最近更新"];
    }
    return _allArr;
}
- (void)zuiduoClick:(UIButton *)btn {
    
}
@end
