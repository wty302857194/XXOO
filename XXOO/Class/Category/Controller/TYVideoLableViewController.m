//
//  TYVideoLableViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYVideoLableViewController.h"

@interface TYVideoLableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSArray * topLabArr;
@property (nonatomic, copy) NSArray * bottomLabArr;
@end

@implementation TYVideoLableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 2;//_dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listviewid"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [self addLable:@[@"中文",@"中文",@"中文中文",@"中文中文",@"中文中文",@"中文中文",@"中文",@"中文",@"中文",@"中文",@"中文",@"中文中文",@"中文中文中文",@"中文中文中文",@"中文中文中文",@"中文中文中文",@"中文中文中文"] withContentView:cell.contentView];
    }else {
        [self addLable:@[] withContentView:cell.contentView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
    }
    return _tableView;
}

- (void)addLable:(NSArray *)labArr withContentView:(UIView *)view{
    
    UIView *topLabView = [UIView new];
    [view addSubview:topLabView];
    [topLabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    CGFloat marginX = 10;  //按钮距离左边和右边的距离
    CGFloat marginY = 10;  //按钮距离布局顶部的距离
    CGFloat gap = 10;    //按钮与按钮之间的距离
    
    
    UIButton *selectBtn = nil;
    for (int i =0; i<labArr.count; i++) {
        UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %@  ",labArr[i]] titleColor:main_select_text_color font:[UIFont systemFontOfSize:14] target:self action:@selector(chooseStation:)];
        btn.tag = 10+i;
        btn.cornerRadius = 15;
        btn.layer.borderColor = main_select_text_color.CGColor;
        btn.layer.borderWidth = 1;
        [topLabView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (selectBtn) {
                make.top.equalTo(selectBtn.mas_top);
                make.left.equalTo(selectBtn.mas_right).offset(gap);
                if (i == 30) {
                    make.bottom.offset(-marginX);
                }
            }
            else {
                make.top.offset(marginY);
                make.left.offset(marginX);
            }
            
            make.height.offset(30);
        }];
        
        [topLabView layoutIfNeeded];
        
        if ((btn.right+marginX)>KSCREEN_WIDTH) {
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(marginX);
                make.top.equalTo(selectBtn.mas_bottom).offset(10);
                make.height.offset(30);
            }];
        }
        
        selectBtn = btn;
    }
}
- (void)chooseStation:(UIButton *)btn {
    
}
@end
