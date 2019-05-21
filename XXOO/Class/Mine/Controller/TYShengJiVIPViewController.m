//
//  TYShengJiVIPViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYShengJiVIPViewController.h"
#import "TYFanKuiTableViewController.h"
#import "TYPromotionVIPViewController.h"

@interface TYShengJiVIPViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation TYShengJiVIPViewController
- (IBAction)selectChoose:(UIButton *)sender {
    if (sender == _selectBtn) return;
    
    [sender setBackgroundImage:[UIImage imageNamed:@"mine_topBackImg"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_selectBtn setTitleColor:main_select_text_color forState:UIControlStateNormal];

    if (sender == _leftBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0)];

        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView setContentOffset:CGPointMake(KSCREEN_WIDTH, 0)];
            
        }];
    }
    _selectBtn = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"升级VIP会员";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_payType_img"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    _selectBtn = self.leftBtn;
    
    self.scrollView.contentSize = CGSizeMake(2.f*KSCREEN_WIDTH, self.scrollView.height);

    TYPromotionVIPViewController *PromotionVC = [TYPromotionVIPViewController new];
    [self addChildViewController:PromotionVC];
    PromotionVC.view.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
    [self.scrollView addSubview:PromotionVC.view];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mine" bundle:nil];
    TYFanKuiTableViewController *fanKuiVC = [storyboard instantiateViewControllerWithIdentifier:@"TYFanKuiTableViewController"];
    fanKuiVC.view.frame = CGRectMake(KSCREEN_WIDTH, 0, self.scrollView.width, self.scrollView.height);
    [self addChildViewController:fanKuiVC];
    [self.scrollView addSubview:fanKuiVC.view];
}
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x+KSCREEN_WIDTH/2.f)/KSCREEN_WIDTH;
    if (index == 0) {
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"mine_topBackImg"] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_rightBtn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    }else {
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"mine_topBackImg"] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_leftBtn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    }
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        [self.view sendSubviewToBack:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftBtn.mas_bottom).offset(0);
            make.left.right.bottom.offset(0);
        }];
    }
    return  _scrollView;
}
@end
