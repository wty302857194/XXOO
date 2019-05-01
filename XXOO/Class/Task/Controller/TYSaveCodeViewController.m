//
//  TYSaveCodeViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/27.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSaveCodeViewController.h"

@interface TYSaveCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *codeBackView;
@property (weak, nonatomic) IBOutlet UILabel *myInvitationLab;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@end

@implementation TYSaveCodeViewController
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveCode:(UIButton *)sender {
    if(sender.tag == 10) {
        [self saveCodeRequestData];
    }else {
        
    }
}
- (void)saveCodeRequestData {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"tid":self.ID
                           };
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/saveQr" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        
        //开启一个图形上下文
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
        //获取图形上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //截图
        [self.view.layer renderInContext:ctx];
        //获取图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //关闭图形上下文
        UIGraphicsEndImageContext();
        [self loadImageFinished:image];
        
        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD promptMessage:msg inView:self.view];
    } failureBlock:^(NSString * _Nonnull description) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
// /user/api/getMySpreadCode
- (void)getMyCodeRequestData {
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/getMySpreadCode" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success&&data) {
            self.myInvitationLab.text = data;
            self.codeImage.image = [self drawImageWithString:data withImage:[UIImage imageNamed:@""] withRQ:214 withLogo:0];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading t
    [self getMyCodeRequestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

/**
 二维码生成
 
 @param str 字符串
 @param logoImage logoimage
 @param widHei 二维码宽高
 @param widHei logo宽高
 @return 二维码image
 */

- (UIImage *)drawImageWithString:(NSString *)str withImage:(UIImage *)logoImage withRQ:(CGFloat)rqWG withLogo:(CGFloat)logoWG{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //设置过滤器默认属性
    [qrImageFilter setDefaults];
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    
    // 消除模糊(不懂){"regPhone":"17512525508","shipName":"1111"}
    CGFloat scaleX = rqWG / qrImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = rqWG / qrImage.extent.size.height;
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    //----------------添加用户头像----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    //再把小图片画上去
    UIImage *sImage = logoImage;
    
    CGFloat sImageW = logoWG;
    CGFloat sImageH= logoWG;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
//    sImage = [self clipCornerRadius:sImage withSize:CGSizeMake(sImageW, sImageH)];
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //    获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return finalyImage;
    
}

@end
