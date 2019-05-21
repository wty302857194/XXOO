//
//  TYFanKuiTableViewController.m
//  
//
//  Created by wbb on 2019/5/21.
//

#import "TYFanKuiTableViewController.h"
#import "FSTextView.h"

@interface TYFanKuiTableViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UIButton *_selectBtn;
    UIImage *_userImage;
}

@property (weak, nonatomic) IBOutlet UITableViewCell *selectCell;
@property (weak, nonatomic) IBOutlet FSTextView *miaoShuTV;
@property (weak, nonatomic) IBOutlet UIImageView *ChooseImgView;

@property (nonatomic, copy) NSString * tvStr;
@property (nonatomic, copy) NSString * selectTitle;
@property (nonatomic, copy) NSArray * titleArr;
@end

@implementation TYFanKuiTableViewController
- (IBAction)tiJiao:(UIButton *)sender {
    [self changePersonPic];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _miaoShuTV.delegate = self;
    _miaoShuTV.text = @"";
    self.tvStr = @"";
    self.selectTitle = @"";
    
    _miaoShuTV.placeholder = @"请输入问题描述";
    [self.ChooseImgView addTarget:self action:@selector(addImg)];
    TYWEAK_SELF;
    [_miaoShuTV addTextDidChangeHandler:^(FSTextView *textView) {
        // 抬头改变的时候 要判断
        weakSelf.tvStr = textView.text;
    }];
    
    [self getProblemListRequestData];
}
- (void)addImg {
    // 初始化 添加 提示内容
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 添加 AlertAction 事件回调（三种类型：默认，取消，警告）
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok");
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing=YES;
        picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
        // 移除
        [alertController dismissViewControllerAnimated:YES completion:^{
            NSLog(@"dismiss");
        }];
    }];
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"error");
        if(![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] &&
           ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            [MBProgressHUD promptMessage:@"此设备不支持拍照" inView:self.view];
            return;
        }
        UIImagePickerController* picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing=YES;
        picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    // cancel类自动变成最后一个，警告类推荐放上面
    [alertController addAction:errorAction];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    // 出现
    [self presentViewController:alertController animated:YES completion:^{
        NSLog(@"presented");
    }];

}
//  /sysTem/api/getProblemList  系统-反馈列表

/*
 {
 content: "",        //内容
 id: 12,             //ID
 title: "",  //说明
 type: 4           //
 }
 */
- (void)getProblemListRequestData {
    NSDictionary * dic = @{};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/sysTem/api/getProblemList" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            weakSelf.titleArr = [NSArray arrayWithArray:data];
            
            [weakSelf addLable:weakSelf.titleArr withView:weakSelf.selectCell.contentView];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
- (void)addLable:(NSArray *)labArr withView:(UIView *)view {
    
    UIView *topLabView = [UIView new];
    [view addSubview:topLabView];
    [topLabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    CGFloat marginX = 10;  //按钮距离左边和右边的距离
    CGFloat marginY = 10;  //按钮距离布局顶部的距离
    CGFloat gap = 10;    //按钮与按钮之间的距离
    CGFloat Width = (KSCREEN_WIDTH - 4*gap)/3.f;
    
    UIButton *selectBtn = nil;
    for (int i =0; i<labArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:main_light_text_color font:[UIFont systemFontOfSize:14] target:self action:@selector(chooseStation:)];
        NSDictionary *dataDic = labArr[i];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",dataDic[@"content"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"fanKuiImageNomal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"fanKuiImageSelecter"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:main_light_text_color forState:UIControlStateNormal];

//        btn.layer.borderColor = main_light_text_color.CGColor;
//        btn.layer.borderWidth = 1;

        btn.tag = 10+i;
//        btn.cornerRadius = 15;
        [topLabView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.width.offset(Width);
            
            if (selectBtn) {
                make.top.equalTo(selectBtn.mas_top);
                make.left.equalTo(selectBtn.mas_right).offset(gap);
                
            }
            else {
                make.top.offset(marginY);
                make.left.offset(marginX);
            }
            if (i == labArr.count-1) {
                make.bottom.offset(-marginX);
            }
            
        }];
        
        [topLabView layoutIfNeeded];
        
        if ((btn.right+marginX)>KSCREEN_WIDTH) {
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(marginX);
                make.top.equalTo(selectBtn.mas_bottom).offset(10);
                make.height.offset(30);
                make.width.offset(Width);
            }];
        }
        
        selectBtn = btn;
    }
    
    [self.tableView reloadData];
}
- (void)chooseStation:(UIButton *)btn {
    if(_selectBtn == btn) return;
    btn.selected = !btn.selected;
    _selectBtn.selected = !_selectBtn.selected;
    NSDictionary *dataDic = self.titleArr[btn.tag - 10];
    self.selectTitle =  dataDic[@"content"];
    
//    btn.layer.borderColor = main_select_text_color.CGColor;
//    [btn setTitleColor:main_select_text_color forState:UIControlStateNormal];
//    _selectBtn.layer.borderColor = main_light_text_color.CGColor;
//    [_selectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    
    _selectBtn = btn;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - UIPickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    double size = image.size.height*image.size.width;
    UIImage *newImage;
    if ( size > 120 * 120)
    {
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointMake(0, 0);
        thumbnailRect.size.width  = 120;
        thumbnailRect.size.height = 120;
        UIGraphicsBeginImageContext(thumbnailRect.size); // this will crop
        [image drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
            
            UIGraphicsEndImageContext();
    }
    _userImage = newImage;
    self.ChooseImgView.image = newImage;
}
#pragma mark - 上传图片   /upload/api/uploadFile
- (void)changePersonPic
{
    if(self.selectTitle.length==0) {
        [MBProgressHUD promptMessage:@"请选择你遇到的问题" inView:self.view];
        return;
    }
    if(self.tvStr.length==0) {
        [MBProgressHUD promptMessage:@"请填写你的问题描述" inView:self.view];
        return;
    }
    
    NSData *data=  UIImagePNGRepresentation(_userImage);
    NSString *headStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"content":self.tvStr?:@"",
                           @"title":self.selectTitle?:@"",
                           @"picUrl":headStr?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TYWEAK_SELF;
    [TYNetWorkTool postRequest:@"/userFeedback/api/feedBack" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}
@end
