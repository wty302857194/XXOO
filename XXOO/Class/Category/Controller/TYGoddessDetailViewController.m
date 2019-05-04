//
//  TYGoddessDetailViewController.m
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGoddessDetailViewController.h"
#import "TYGoddessHeaderView.h"
//#import "TYGoddessHeaderView.h"

@interface TYGoddessDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TYGoddessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getActorByIdRequestData];
}
/*
 
 {
 avatar: "1",                         //封面
 birthAdress: "1",                    //出生地址
 birthDay: "1",                        //出生日期
 click: 1,                            //点击量
 createTime: "2019-04-20 17:13:07",    //发布时间
 cup: "1",                            //罩杯
 cupId: "1",                            //分类id
 describe: "1",                        //描述
 height: "1",                        //身高
 id: 1,                                //ID
 interest: "1",                        //兴趣
 measurement: "1",                    //三围
 modifyTime: null,                    //
 name: "1",                            //名字
 worksNum: 1                            //作品数量
 }
 
 */
//  /videoActor/api/getActorById
- (void)getActorByIdRequestData {
    NSDictionary * dic = @{
                           @"id":self.ID?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/videoActor/api/getActorById" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success&&data) {
            weakSelf.title = data[@"name"];
            [weakSelf addTableHeaderView:data];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)addTableHeaderView:(NSDictionary *)dic {
    TYGoddessHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"TYGoddessHeaderView" owner:nil options:nil] lastObject];
    view.dataDic = dic;
    self.tableView.tableHeaderView = view;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 0;//_dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"listviewid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
