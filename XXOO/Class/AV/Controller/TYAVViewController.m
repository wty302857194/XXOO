//
//  TYAVViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVViewController.h"
#import "TYAVHomeViewController.h"
#import "TYAVLableModel.h"
#import "TYHomeModel.h"
#import "TYGongGaoView.h"
#import "TYShengJiView.h"

static NSInteger const scHeight = 40;
static NSInteger const jianGe = 10;//间隔距离
static NSInteger const btnWidth = 90;

@interface TYAVViewController ()<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray * titleArr;

@property (nonatomic, strong) UILabel * lineLab;
@property (nonatomic, strong) UIButton * currentBtn;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIScrollView *titleSC;
@property (nonatomic, strong) NSMutableDictionary *listVCQueue;
@property (nonatomic, strong) TYGongGaoView * gongGaoView;
@property (nonatomic, strong) TYShengJiView * shengJiView;


@end

@implementation TYAVViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _listVCQueue = [NSMutableDictionary dictionaryWithCapacity:0];
    [self getAVRequestData];
    [self getNoticesListRequestData];
    [self getVersionByTypeRequestData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - requestData
// 顶部标签的请求
- (void)getAVRequestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/videoCategroy/api/videoClassHome" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            self.titleArr = [TYAVLableModel mj_objectArrayWithKeyValuesArray:data];
            
            [self setUI];
            
//            TYAVLableModel *model =  self.titleArr[0];
//            TYAVHomeViewController *currentVC = (TYAVHomeViewController *)self.listVCQueue[@(0)];
//            [currentVC headerRefreshRequest:model.name];

        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}
//  /sysNotices/api/getNoticesList  公告
- (void)getNoticesListRequestData {
    [TYNetWorkTool postRequest:@"/sysNotices/api/getNoticesList" parameters:@{} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success&&data) {
            self.gongGaoView.contentLab.text = [NSString stringWithFormat:@"%@",data];
            self.gongGaoView.hidden = NO;
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        
    }];
}
//  /sysVersion/api/getVersionByType  系统-版本更新

/*
 {
 "content": "全新版本app下载安装",            //版本说明
 "createTime": "2019-05-20 10:18:53",       //
 "deviceCode": "1.1",                       //版本号
 "deviceType": 1,                           //系统 1安卓 2IOS
 "id": 1,                                   //id
 "url": " ",                                //下载地址
 "versionName": "1.10"                      //版本名称
 }
 */
- (void)getVersionByTypeRequestData {
    NSString *versionStr = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [TYNetWorkTool postRequest:@"/sysVersion/api/getVersionByType" parameters:@{@"type":@"2"} successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success&&data) {
            if ([versionStr isEqualToString:data[@"deviceCode"]]) {
                return ;
            }else {
//                self.shengJiView.contentLab.text = [NSString stringWithFormat:@"%@",data];
//                [TYGlobal openScheme:data[@"url"]?:@""];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        
    }];
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
         TYAVLableModel *model =  self.titleArr[i];
        UIButton *btn = [UIButton buttonWithTitle:model.name titleColor:main_light_text_color font:[UIFont systemFontOfSize:15] target:self action:@selector(titleBtnClick:)];
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
        [self.view sendSubviewToBack:_scrollView];
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
        TYAVHomeViewController *contentVC = [[TYAVHomeViewController alloc] init];
        [self addChildViewController:contentVC];
        TYAVLableModel *model =  self.titleArr[index];
        contentVC.vClass = model.name;

        contentVC.view.frame = CGRectMake(KSCREEN_WIDTH*index, 0, self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:contentVC.view];
        
        [_listVCQueue setObject:contentVC forKey:@(index)];
    }
}
#pragma mark - ==懒加载==
- (TYGongGaoView *)gongGaoView {
    if (!_gongGaoView) {
        _gongGaoView = [[[NSBundle mainBundle] loadNibNamed:@"TYGongGaoView" owner:nil options:nil] lastObject];
        _gongGaoView.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_gongGaoView];
        [self.view bringSubviewToFront:_gongGaoView];
    }
    return _gongGaoView;
}
- (TYShengJiView *)shengJiView {
    if (!_shengJiView) {
        _shengJiView = [[[NSBundle mainBundle] loadNibNamed:@"TYShengJiView" owner:nil options:nil] lastObject];
        _shengJiView.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:_shengJiView];
        [self.view bringSubviewToFront:_shengJiView];
    }
    return _shengJiView;
}
@end

