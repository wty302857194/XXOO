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

    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = [UIColor redColor];
        
        UIView *topLabView = [UIView new];
//        topLabView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:topLabView];
        [topLabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
        }];
        
        CGFloat marginX = 10;  //按钮距离左边和右边的距离
        CGFloat marginY = 10;  //按钮距离布局顶部的距离
        CGFloat gap = 10;    //按钮与按钮之间的距离
        
        UIButton *selectBtn = nil;
        for (int i =0; i<20; i++) {
            UIButton *btn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"  %d  ",i] titleColor:main_select_text_color font:[UIFont systemFontOfSize:14] target:self action:@selector(chooseStation:)];
            btn.tag = 10+i;
            btn.cornerRadius = 15;
            btn.layer.borderColor = main_select_text_color.CGColor;
            btn.layer.borderWidth = 1;
            [topLabView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (selectBtn) {
//                    if (selectBtn.right+marginX>KSCREEN_WIDTH) {
//                        make.left.offset(marginX);
//                        make.top.equalTo(selectBtn.mas_bottom).offset(10);
//                    }else {
                        make.top.equalTo(selectBtn.mas_top);
                        make.left.equalTo(selectBtn.mas_right).offset(gap);
//                    }
                    if (i == 19) {
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
            
            NSLog(@"btn.right+marginX === %f",(btn.right+marginX));
            if ((btn.right+marginX)>KSCREEN_WIDTH) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(marginX);
                    make.top.equalTo(selectBtn.mas_bottom).offset(10);
                    make.height.offset(30);
                }];
                [topLabView layoutIfNeeded];
            }
            
            selectBtn = btn;
        }
        
    }else {
        
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

@end
