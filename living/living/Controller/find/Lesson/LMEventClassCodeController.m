//
//  LMEventClassCodeController.m
//  living
//
//  Created by hxm on 2017/5/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEventClassCodeController.h"

@interface LMEventClassCodeController ()

@end

@implementation LMEventClassCodeController
{
    UIImage * qrImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveCode:)];
    
    qrImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_codeUrl]]];
    UIImageView * qrCode = [[UIImageView alloc] initWithFrame:CGRectMake(20, 74, kScreenWidth-40, kScreenWidth-40)];
    qrCode.center = self.view.center;
    qrCode.clipsToBounds = YES;
    qrCode.contentMode = UIViewContentModeScaleAspectFill;
    qrCode.image = qrImage;
    [self.view addSubview:qrCode];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(qrCode.frame)+10, kScreenWidth-40, 20)];
    titleLabel.text = _name;
    titleLabel.textColor = TEXT_COLOR_LEVEL_1;
    titleLabel.font = TEXT_FONT_LEVEL_1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
}

- (void)saveCode:(UIBarButtonItem *)item {
    
    UIImageWriteToSavedPhotosAlbum(qrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [self textStateHUD:@"保存成功"];
    }else {
        [self textStateHUD:@"保存失败"];
    }
}

@end
