//
//  TYSettingTableVC.m
//  XXOO
//
//  Created by wbb on 2019/4/15.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSettingTableVC.h"
#import "TYEmailTableViewController.h"

@interface TYSettingTableVC ()
@property (weak, nonatomic) IBOutlet UILabel *zhangHaoLab;
@property (nonatomic, copy) NSDictionary * dataDic;
@end
@implementation TYSettingTableVC
- (IBAction)isOpenSwitch:(UISwitch *)sender {
    sender.on = !sender.on;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:main_text_color}];
//
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mineGoBickImg"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    self.zhangHaoLab.text = @"";

    if ([TYGlobal userMessage]) {
        self.dataDic = [NSDictionary nullDic:[TYGlobal userMessage]];
        self.zhangHaoLab.text = self.dataDic[@"name"];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 0;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"mine" bundle:nil];
            TYEmailTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TYEmailTableViewController"];
            [self.navigationController pushVC:vc animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}
@end
