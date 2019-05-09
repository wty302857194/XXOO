//
//  TYHelpViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYHelpViewController.h"

@interface TYHelpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation TYHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.contentLab.text = @"";
    [self getRuleInfoRequestData];
}
- (IBAction)cancelBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 //  /sysTem/api/getRuleInfo
- (void)getRuleInfoRequestData {
    
    NSDictionary * dic = @{
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/sysTem/api/getRuleInfo" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSString *content = data[@"content"]?:@"";
            NSMutableAttributedString *jtExpireDay_str=  [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            self.contentLab.attributedText = jtExpireDay_str;
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
