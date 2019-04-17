//
//  TYGoddessViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGoddessViewController.h"
#import "TYAVDetailsViewController.h"
#import "TYGoddessCollectionViewCell.h"


#define collectionWidth (KSCREEN_WIDTH-50)/4.0f

@interface TYGoddessViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIView * topbBackView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (nonatomic, strong) UIButton * selectBtn1;//第一行选中的btn
@property (nonatomic, strong) UIButton * selectBtn2;//第二行选中的btn
@end

@implementation TYGoddessViewController
- (IBAction)topBtnClick:(UIButton *)sender {
    if (_selectBtn1 == sender) return;
    
    sender.borderWidth = 1;
    sender.cornerRadius = 13;
    sender.borderColor = main_select_text_color;
    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
    _selectBtn1.borderWidth = 0;
    [_selectBtn1 setTitleColor:main_light_text_color forState:UIControlStateNormal];
    
    switch (sender.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        default:
            break;
    }
    
    _selectBtn1 = sender;
}
- (IBAction)zhaoBeiClick:(UIButton *)sender {
    if (_selectBtn2 == sender) return;

    sender.cornerRadius = 13;
    sender.borderWidth = 1;
    sender.borderColor = main_select_text_color;
    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
     _selectBtn2.borderWidth = 0;
    [_selectBtn2 setTitleColor:main_light_text_color forState:UIControlStateNormal];
    
    switch (sender.tag) {
        case 1000:
        {
            
        }
            break;
        case 1001:
        {
            
        }
            break;
        case 1002:
        {
            
        }
            break;
        case 1003:
        {
            
        }
            break;
        case 1004:
        {
            
        }
            break;
        case 1005:
        {
            
        }
            break;
        case 1006:
        {
            
        }
            break;
        case 1007:
        {
            
        }
            break;
        default:
            break;
    }
    
    _selectBtn2 = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectBtn1 = _moreBtn;
    _selectBtn2 = _allBtn;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TYGoddessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYGoddessCollectionViewCell"];
}


#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TYGoddessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYGoddessCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionWidth, collectionWidth*(278/144.f));
    
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
@end
