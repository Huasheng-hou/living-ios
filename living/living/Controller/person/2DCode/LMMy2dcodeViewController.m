//
//  LMMy2dcodeViewController.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMMy2dcodeViewController.h"
#import "LM2DcodeRequest.h"
#import "UIImageView+WebCache.h"
#import "LMFranchiseeViewController.h"
#import "UIView+frame.h"

@interface LMMy2dcodeViewController ()
{
    UIImageView *imageView;
    NSString *codeSting;
    UIView *KeepImage;
    UIButton *downButton;
    UILabel *endTimeLabel;
    NSInteger index;
}

@end

@implementation LMMy2dcodeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor  = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"二维码";
    [self get2DcodeRequest];
    
    //如果有缓存信息 则用缓存信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString        *filename   = [path stringByAppendingPathComponent:@"img.plist"];
    NSDictionary    *headerData = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    if (headerData && [headerData isKindOfClass:[NSDictionary class]]) {
        
        codeSting = [headerData objectForKey:@"code"];
        [self creatImageView];
    }
}

- (void)get2DcodeRequest
{
    if (![CheckUtils isLink]) {
        
        [self textStateHUD:@"无网络连接"];
        return;
    }
    LM2DcodeRequest *request = [[LM2DcodeRequest alloc] initWithUserUUid:[FitUserManager sharedUserManager].uuid];
    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                           completed:^(NSString *resp, NSStringEncoding encoding) {
                                               
                                               [self performSelectorOnMainThread:@selector(get2DcodeResponse:)
                                                                      withObject:resp
                                                                   waitUntilDone:YES];
                                           } failed:^(NSError *error) {
                                               
                                               [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                      withObject:@"网络错误"
                                                                   waitUntilDone:YES];
                                           }];
    [proxy start];
    
}

- (void)get2DcodeResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if (!bodyDic) {
        [self textStateHUD:@"获取数据失败"];
        return;
    }
    
    NSString *result    = [bodyDic objectForKey:@"result"];
    
    if (result && [result intValue] == 0)
    {
        codeSting =  bodyDic[@"code"];
        
        [self creatImageView];
        //将数据缓存到本地
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:@"contact.plist"];
        NSMutableDictionary *userInfo;
        userInfo=[[NSMutableDictionary alloc]initWithDictionary:bodyDic];
        [userInfo writeToFile:filename atomically:YES];
        
        
    } else {
        
        UILabel *msgLabel = [UILabel new];
        msgLabel.textColor = [UIColor whiteColor];
        msgLabel.text = @"你不是轻创客，没有二维码";
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [msgLabel sizeToFit];
        msgLabel.frame = CGRectMake(kScreenWidth/2-msgLabel.bounds.size.width/2-10, kScreenHeight/2-40, msgLabel.bounds.size.width+20, 45);
        [self.view addSubview:msgLabel];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"business"] style:UIBarButtonItemStylePlain target:self action:@selector(joinAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
}

-(void)creatImageView
{
    KeepImage = [[UIView alloc] initWithFrame:CGRectMake(15, 60+64, kScreenWidth-30, 115+kScreenWidth)];
    KeepImage.clipsToBounds = YES;
    KeepImage.layer.cornerRadius = 5;
    KeepImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:KeepImage];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    headImage.backgroundColor = [UIColor lightGrayColor];
    [headImage sd_setImageWithURL:[NSURL URLWithString:_headURL]];
    headImage.layer.cornerRadius = 5;
    headImage.clipsToBounds = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    [KeepImage addSubview:headImage];
    
    //nick
    UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(90,10,30,30)];
    nicklabel.font = TEXT_FONT_LEVEL_1;
    nicklabel.textColor = TEXT_COLOR_LEVEL_1;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
    NSString *str = _name;
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [nicklabel setFrame:CGRectMake(90, 22.5, textSize.width, 30)];
    nicklabel.text = str;
    [KeepImage addSubview:nicklabel];
    
    downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(kScreenWidth-85, 10, 40, 40);
    [downButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(saveImageToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [KeepImage addSubview:downButton];
    
    
    
    UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+6+90, 30, 16, 16)];
    if (_gender) {
        if ([_gender intValue] ==1) {
            [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
        }else{
            [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
        }
    }
    [KeepImage addSubview:genderImage];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = _address;
    addressLabel.textColor = TEXT_COLOR_LEVEL_3;
    addressLabel.font = TEXT_FONT_LEVEL_2;
    [addressLabel sizeToFit];
    addressLabel.frame = CGRectMake(91, 52, addressLabel.bounds.size.width, 20);
    [KeepImage addSubview: addressLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 125, kScreenWidth-70, kScreenWidth-70)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:codeSting]];
    [KeepImage addSubview:imageView];
    
    
    UIImageView *headImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-70)/2-25, (kScreenWidth-70)/2-25, 50, 50)];
    headImage2.backgroundColor = [UIColor lightGrayColor];
    [headImage2 sd_setImageWithURL:[NSURL URLWithString:_headURL]];
    headImage2.layer.cornerRadius = 5;
    headImage2.clipsToBounds = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    [imageView addSubview:headImage2];
    
    NSDate * date = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //设置时间间隔（秒）（这个我是计算出来的，不知道有没有简便的方法 )
    NSTimeInterval time = 30 * 24 * 60 * 60;//一年的秒数
    //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
    
    NSDate * lastYear = [date dateByAddingTimeInterval:time];
    
    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastYear];
    NSLog(@"%@",startDate);
    NSDate *endDate = [dateFormatter dateFromString:_endTime];
    
    [self compareOneDay:lastYear withAnotherDay:endDate];
    
}

- (void)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay  is in the future");
        
        NSString *string = [dateFormatter stringFromDate:anotherDay];
        
        endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 115+kScreenWidth-45, kScreenWidth-45, 45)];
        endTimeLabel.numberOfLines = 2;
        endTimeLabel.textAlignment = NSTextAlignmentCenter;
        endTimeLabel.text = [NSString stringWithFormat:@"您的加盟商资格将于%@到期,\n请点击右上角按钮进行续费",string];
        endTimeLabel.textColor = LIVING_COLOR;
        endTimeLabel.font = TEXT_FONT_LEVEL_1;
        [KeepImage addSubview:endTimeLabel];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"business"] style:UIBarButtonItemStylePlain target:self action:@selector(joinAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    else if (result == NSOrderedAscending){

    }
    //NSLog(@"Both dates are the same");
}




#pragma mark  --成为加盟商

-(void)joinAction
{
    //    NSLog(@"**********");
    LMFranchiseeViewController *joinVC = [[LMFranchiseeViewController alloc] init];
    joinVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:joinVC animated:YES];
}

- (void)saveImageToAlbum {
    [downButton setHidden:YES];
    [endTimeLabel setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self saveScreenshotToPhotosAlbum:KeepImage];
}


- (UIImage *) captureScreen:(UIView *)view  targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = view.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [view drawViewHierarchyInRect:thumbnailRect afterScreenUpdates:YES];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void)saveScreenshotToPhotosAlbum:(UIView *)view
{
    CGSize size = CGRectMake(0, 0, view.size.width*3/2, view.size.height*3/2).size;
    
    UIImageWriteToSavedPhotosAlbum([self captureScreen:view targetSize:size], nil, nil, nil);
    
    [self textStateHUD:@"保存到相册成功"];
    [downButton setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
}




@end
