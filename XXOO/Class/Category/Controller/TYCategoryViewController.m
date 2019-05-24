//
//  TYCategoryViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYCategoryViewController.h"
#import "TYAVCategoryViewController.h"
#import "TYGoddessViewController.h"
#import "TYVideoLableViewController.h"
#import "TYShengJiVIPViewController.h"


static NSInteger const scHeight = 40;
static NSInteger const jianGe = 0;//间隔距离
#define btnWidth  KSCREEN_WIDTH/3.f

@interface TYCategoryViewController ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray * titleArr;

@property (nonatomic, strong) UILabel * lineLab;
@property (nonatomic, strong) UIButton * currentBtn;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIScrollView *titleSC;
@property (nonatomic, strong) NSMutableDictionary *listVCQueue;

@end

@implementation TYCategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _listVCQueue = [NSMutableDictionary dictionaryWithCapacity:0];

    [self setUI];
    
    NSDictionary *dic = [USER_DEFAULTS objectForKey:USERMESSAGE];
    NSString *str = [NSString stringWithFormat:@"%@",dic[@"level"]];
    if ([str isEqualToString:@"1"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"shengjiVIPImage"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goVIP)];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.right.offset(0);
            make.width.height.offset(100);
        }];
    }
}
- (void)goVIP {
    TYShengJiVIPViewController *vc = [[TYShengJiVIPViewController alloc] init];
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)setUI {
    
    UIScrollView *topTitleSC = [[UIScrollView alloc] init];
    topTitleSC.showsHorizontalScrollIndicator = NO;
    topTitleSC.showsVerticalScrollIndicator = NO;
    [self.view addSubview:topTitleSC];
    self.titleSC = topTitleSC;
    [topTitleSC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.offset(scHeight);
    }];
    
    
    
    UIButton *selectBtn = nil;
    for (int i =0; i<self.titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithTitle:self.titleArr[i] titleColor:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(titleBtnClick:)];
        btn.frame = CGRectMake((jianGe+btnWidth)*i+jianGe, 0, btnWidth, scHeight-1);
        btn.tag = i+100;
        [topTitleSC addSubview:btn];
        
        
        if (i == 0) {
            _lineLab = [[UILabel alloc] initWithFrame:CGRectMake(jianGe, scHeight-1, btnWidth, 1)];
            _lineLab.backgroundColor = main_select_text_color;
            [topTitleSC addSubview:_lineLab];
        }
        
        selectBtn = btn;
    }
    
    topTitleSC.contentSize = CGSizeMake(selectBtn.right+jianGe, topTitleSC.height);
    
    self.scrollView.contentSize = CGSizeMake(self.titleArr.count*KSCREEN_WIDTH, self.scrollView.height);
    
    [self addListVCWithIndex:0];
}

- (void)titleBtnClick:(UIButton *)btn {
    if(btn == _currentBtn) return;
    
    [_currentBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
    
    _lineLab.center = CGPointMake(btn.center.x, _lineLab.center.y);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake((btn.tag-100)*KSCREEN_WIDTH, self.scrollView.contentOffset.y)  animated:NO];
    }];
    
    [self addListVCWithIndex:btn.tag-100];
    
    // 有数学公式得出的算法
    if((KSCREEN_WIDTH - btn.x) < 2*btn.width) {
        if((btn.x - (KSCREEN_WIDTH -btn.width)/2.f)<(self.titleSC.contentSize.width-KSCREEN_WIDTH)) {
            [UIView animateWithDuration:0.5 animations:^{
                self.titleSC.contentOffset = CGPointMake(btn.x - (KSCREEN_WIDTH -btn.width)/2.f, 0);
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.titleSC.contentOffset = CGPointMake(self.titleSC.contentSize.width - KSCREEN_WIDTH, 0);
            }];
        }
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.titleSC.contentOffset = CGPointMake(0, 0);
        }];
    }
    
    
    _currentBtn = btn;
}

#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        //        _scrollView.frame = CGRectMake(0, self.titleSC.bottom, KSCREEN_WIDTH, KSCREENH_HEIGHT-self.titleSC.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleSC.mas_bottom).offset(0);
            make.left.right.bottom.offset(0);
        }];
    }
    return  _scrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x+KSCREEN_WIDTH/2.f)/KSCREEN_WIDTH;
    UIButton *btn = (UIButton *)[self.titleSC viewWithTag:index+100];
    [self titleBtnClick:btn];
    
    [self addListVCWithIndex:(int)(scrollView.contentOffset.x/KSCREEN_WIDTH)];
}

#pragma mark - addVC

- (void)addListVCWithIndex:(NSInteger)index {
    
    if (index<0||index>=self.titleArr.count) {
        return;
    }
    //根据页数添加相对应的视图 并存入数组
    
    if (![_listVCQueue objectForKey:@(index)]) {
        
         UIViewController *contentVC = nil;
        if (index == 0) {
            contentVC = [TYAVCategoryViewController new];
        }else if (index == 1) {
            contentVC = [TYGoddessViewController new];
//            contentVC = [TYAVCategoryViewController new];
        }else if (index == 2) {
            contentVC = [TYVideoLableViewController new];
        }
        [self addChildViewController:contentVC];
        
        contentVC.view.frame = CGRectMake(KSCREEN_WIDTH*index, 0, self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:contentVC.view];
        
        [_listVCQueue setObject:contentVC forKey:@(index)];
    }
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"AV分类",@"视频分类",@"影片标签"];
    }
    return _titleArr;
}

@end
