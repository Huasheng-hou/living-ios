//
//  LMBannerDetailMakerController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailMakerController.h"
#import "LMMakerHeadView.h"

#import "LMSubmitSuccessController.h"
@interface LMBannerDetailMakerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LMMakerDelegate>

@end

@implementation LMBannerDetailMakerController
{
    UICollectionView * _collectionView;
    
    BOOL isShow;
    CGFloat keyBoardHeight;
    
    UIView * bgView;
    UIView * topView;
    UIView * botView;
    UILabel * tips;
    UITextField * nameTF;
    UITextField * phoneTF;
    UIButton * bookBtn;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
    
}

- (void)createUI{

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"mainCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHead"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 235);
    }
    return CGSizeMake((kScreenWidth-30)/2, 115);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
        LMMakerHeadView * headerView = [[LMMakerHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 235)];
        headerView.delegate = self;
        [cell.contentView addSubview:headerView];
        cell.backgroundColor = BG_GRAY_COLOR;
        return cell;
    }
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/2, 100)];
    imageView.backgroundColor = BG_GRAY_COLOR;
    imageView.image = [UIImage imageNamed:@""];
    [cell.contentView addSubview:imageView];
    
    UILabel * slogan = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, (kScreenWidth-30)/2-60, 0)];
    slogan.text = @"一个企业人的自我修养";
    slogan.textColor = [UIColor whiteColor];
    slogan.font = TEXT_FONT_BOLD_14;
    slogan.textAlignment = NSTextAlignmentCenter;
    slogan.numberOfLines = -1;
    [slogan sizeToFit];
    slogan.center = CGPointMake(30+((kScreenWidth-30)/2-60)/2, 100/2);
    [cell.contentView addSubview:slogan];
    
    return cell;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 40);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * typeNames = @[@"丨 腰美路演", @"丨 腰美轻创客", @"丨 腰美运动", @"丨 腰美医疗"];
    UICollectionReusableView * backView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        backView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHead" forIndexPath:indexPath];
        backView.backgroundColor = [UIColor whiteColor];
        for (UIView * subView in backView.subviews) {
            [subView removeFromSuperview];
        }
        
        
        UILabel * typeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 10)];
        typeName.textColor = TEXT_COLOR_LEVEL_4;
        typeName.font = TEXT_FONT_LEVEL_4;
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:typeNames[indexPath.section-1]];
        [attr addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR range:NSMakeRange(0, 2)];
        typeName.attributedText = attr;
        [backView addSubview:typeName];
        
        UILabel * lookMore = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60-10, 15, 60, 10)];
        lookMore.text = @"查看更多 >";
        lookMore.textAlignment = NSTextAlignmentRight;
        lookMore.textColor = TEXT_COLOR_LEVEL_5;
        lookMore.font = TEXT_FONT_LEVEL_4;
        lookMore.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMore:)];
        [lookMore addGestureRecognizer:tap];
        [backView addSubview:lookMore];
        

        return  backView;
    }
    
    return nil;
}

- (void)lookMore:(UITapGestureRecognizer *)tap{
    
    NSLog(@"查看更多。。。");
}

#pragma mark - 点击了解轻创客
- (void)gotoNextPage{
    
    [self contactUs];
    
}

#pragma mark 联系我们
- (void)contactUs{
    
    NSLog(@"联系我们");
    
    
    
    
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view.window addSubview:bgView];
    
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-170)];
    topView.backgroundColor = MASK_COLOR;
    [bgView addSubview:topView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
    [topView addGestureRecognizer:tap];
    
    
    botView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-170, kScreenWidth, 170)];
    botView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:botView];
    
    tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 15)];
    tips.text = @"留下姓名电话，预约就进生活馆了解“创客”详情";
    tips.textColor = TEXT_COLOR_LEVEL_4;
    tips.font = TEXT_FONT_LEVEL_4;
    [botView addSubview:tips];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 35, kScreenWidth-20, 25)];
    nameTF.keyboardType = UIKeyboardTypeDefault;
    nameTF.placeholder = @" 姓名";
    nameTF.textColor = TEXT_COLOR_LEVEL_2;
    nameTF.font = TEXT_FONT_LEVEL_2;
    [nameTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    nameTF.borderStyle = UITextBorderStyleLine;
    nameTF.layer.borderColor = TEXT_COLOR_LEVEL_4.CGColor;
    nameTF.layer.borderWidth = 1;
    nameTF.layer.masksToBounds = YES;
    nameTF.layer.cornerRadius = 3;
    [botView addSubview:nameTF];
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 75, kScreenWidth-20, 25)];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.placeholder = @" 电话";
    phoneTF.textColor = TEXT_COLOR_LEVEL_2;
    phoneTF.font = TEXT_FONT_LEVEL_2;
    [phoneTF setValue:TEXT_COLOR_LEVEL_4 forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.borderStyle = UITextBorderStyleLine;
    phoneTF.layer.borderColor = TEXT_COLOR_LEVEL_4.CGColor;
    phoneTF.layer.borderWidth = 1;
    phoneTF.layer.masksToBounds = YES;
    phoneTF.layer.cornerRadius = 3;
    [botView addSubview:phoneTF];
    
    
    bookBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 115, kScreenWidth-40, 35)];
    [bookBtn setTitle:@"预约生活馆" forState:UIControlStateNormal];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bookBtn.titleLabel.font = TEXT_FONT_BOLD_14;
    bookBtn.backgroundColor = ORANGE_COLOR;
    bookBtn.layer.masksToBounds = YES;
    bookBtn.layer.cornerRadius = 3;
    [bookBtn addTarget:self action:@selector(booking:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:bookBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)booking:(UIButton *)btn{
    
    NSLog(@"预约生活馆");
    //验证输入内容
    if ([self checkConfirm]) {
        //移除当前视图
        [bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //跳转下一页面
        LMSubmitSuccessController * ssVC = [[LMSubmitSuccessController alloc] init];
        ssVC.title = @"预约成功";
        [self.navigationController pushViewController:ssVC animated:YES];
    }
    
    
}
#pragma 验证输入内容
- (BOOL)checkConfirm{
    if ([nameTF.text isEqualToString:@""] ) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        [self textStateHUD:@"请输入姓名"];
        return NO;
    }
    else if ([phoneTF.text isEqualToString:@""]) {
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        [self textStateHUD:@"请输入电话"];
        return NO;
    }
    else{
        // 手机号正则
        NSString *mobileRegex = @"[1][34578][0-9]{9}";
        NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
        
        if (![mobilePredicate evaluateWithObject:phoneTF.text]) {
            
            [nameTF resignFirstResponder];
            [phoneTF resignFirstResponder];
            [self textStateHUD:@"手机格式不正确"];
            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号码"
            //                                                                       message:nil
            //                                                                preferredStyle:UIAlertControllerStyleAlert];
            //            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
            //                                                  style:UIAlertActionStyleCancel
            //                                                handler:nil]];
            //
            //            [self presentViewController:alert animated:YES completion:nil];
            
            
            return NO;
        }
    }
    return YES;
}

- (void)keyboardShow:(NSNotification *)noti{
    if (isShow) {
        return;
    }
    isShow = YES;
    NSLog(@"%@", [noti userInfo]);
    
    CGRect frame = bgView.frame;
    NSDictionary * info = [noti userInfo];
    CGSize kSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyBoardHeight = kSize.height;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y-kSize.height, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = rect;
    }];
    
    
}

- (void)keyboardHide:(NSNotification *)noti{
    
    [self hideAnimation];
    
}


- (void)remove:(UITapGestureRecognizer *)tap{
    if (isShow) {
        
        [nameTF resignFirstResponder];
        [phoneTF resignFirstResponder];
        
    }else{
        [bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)hideAnimation{
    isShow = NO;
    
    CGRect frame = bgView.frame;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y+keyBoardHeight, frame.size.width, frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = rect;
    }];
    
    
}

@end
