//
//  TYGoddessHeaderView.m
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGoddessHeaderView.h"
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
@implementation TYGoddessHeaderView

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]] placeholderImage:PLACEHOLEDERIMAGE];
    self.dateLab.text = [NSString stringWithFormat:@"出生日期：%@",dataDic[@"birthDay"]];
    self.heightLab.text = [NSString stringWithFormat:@"身高：%@",dataDic[@"height"]];
    self.xingQuLab.text = [NSString stringWithFormat:@"兴趣：%@",dataDic[@"interest"]];
    self.contentLab.text = [NSString stringWithFormat:@"女优介绍：%@",dataDic[@"describe"]];
    self.addressLab.text = [NSString stringWithFormat:@"出生地：%@",dataDic[@"birthAdress"]];
    self.sanWeiLab.text = [NSString stringWithFormat:@"三围：%@",dataDic[@"measurement"]];
    
}

@end
