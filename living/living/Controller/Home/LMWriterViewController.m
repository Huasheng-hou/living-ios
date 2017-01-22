//
//  LMWriterViewController.m
//  living
//
//  Created by Ding on 2016/11/1.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMWriterViewController.h"
#import "LMhomePageCell.h"
#import "LMWriterDataRequest.h"
#import "LMActicleVO.h"
#import "LMHomeDetailController.h"
#import "ImageHelpTool.h"
#import "LMBlackWriterRequest.h"

static CGRect oldframe;
@interface LMWriterViewController ()
<
LMhomePageCellDelegate
>
{
    UITableView *_tableView;
    NSMutableDictionary *infoDic;
    UIImageView *headerView;
    UIView *backgroundViews;
    UIImageView *imageViews;
    NSString *franchisee;
}


@end

@implementation LMWriterViewController

- (id)initWithUUid:(NSString *)writerUUid
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
//        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
        _writerUUid = writerUUid;
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listData.count == 0) {
        
        [self loadNoState];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TA的空间";
    [self createUI];
    [self loadNewer];
    
}
-(void)createUI
{

    [super createUI];
    self.tableView.contentInset                 = UIEdgeInsetsMake(64, 0, 0, 0);
    self.pullToRefreshView.defaultContentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets        = UIEdgeInsetsMake(64, 0, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"屏蔽"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(reportAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)reportAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否屏蔽该作者"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction*action) {
                                                [self shieldWriter];
                                                
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)shieldWriter
{
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        LMBlackWriterRequest *request = [[LMBlackWriterRequest alloc] initWithAuthor_uuid:_writerUUid];
        HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request
                                               completed:^(NSString *resp, NSStringEncoding encoding) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(getarticleshieldDataResponse:)
                                                                          withObject:resp
                                                                       waitUntilDone:YES];
                                               } failed:^(NSError *error) {
                                                   
                                                   [self performSelectorOnMainThread:@selector(textStateHUD:)
                                                                          withObject:@"网络错误"
                                                                       waitUntilDone:YES];
                                               }];
        [proxy start];
    }else{
        [self IsLoginIn];
    }
    
}

- (void)getarticleshieldDataResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    if ([[bodyDic objectForKey:@"result"] isEqual:@"0"])
    {
        [self textStateHUD:@"屏蔽作者成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
        });
    }else{
        NSString *str = [bodyDic objectForKey:@"description"];
        [self textStateHUD:str];
    }
}

- (FitBaseRequest *)request
{
    LMWriterDataRequest *request = [[LMWriterDataRequest alloc] initWithPageIndex:self.current andPageSize:20 authorUuid:_writerUUid];
    
    return request;
}


- (NSArray *)parseResponse:(NSString *)resp
{
    NSDictionary *bodyDic = [VOUtil parseBody:resp];
    
    NSData          *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary    *respDict = [NSJSONSerialization JSONObjectWithData:respData
                                                                options:NSJSONReadingMutableLeaves
                                                                  error:nil];
    
    NSDictionary *headDic = [respDict objectForKey:@"head"];
    NSString    *coderesult         = [headDic objectForKey:@"returnCode"];
    
    if (coderesult && ![coderesult isEqual:[NSNull null]] && [coderesult isKindOfClass:[NSString class]] && [coderesult isEqualToString:@"000"]) {
        
        if ([headDic objectForKey:@"franchisee"] && ![[headDic objectForKey:@"franchisee"] isEqual:[NSNull null]]
            && [[headDic objectForKey:@"franchisee"] isKindOfClass:[NSString class]] && [headDic[@"franchisee"] isEqual:@"yes"]) {
            
            franchisee = @"yes";
        }
    }
    
        infoDic = [bodyDic objectForKey:@"map"];
        NSString    *result         = [bodyDic objectForKey:@"result"];
        
        if (result && ![result isEqual:[NSNull null]] && [result isKindOfClass:[NSString class]] && [result isEqualToString:@"0"]) {
            
            self.max    = [[bodyDic objectForKey:@"total"] intValue];
            NSArray *resultArr  = [LMActicleVO LMActicleVOListWithArray:[bodyDic objectForKey:@"list"]];
            if (resultArr && resultArr.count > 0) {
                
                return resultArr;
            }
        }
    
        return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 20;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 40;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
        headLabel.text = @"全部文章";
        headLabel.font = TEXT_FONT_LEVEL_1;
        headLabel.textColor = LIVING_COLOR;
        [headView addSubview:headLabel];
        
        return headView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //头像
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        headerView.layer.cornerRadius = 35;
        headerView.backgroundColor = BG_GRAY_COLOR;
        headerView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.clipsToBounds = YES;
        headerView.userInteractionEnabled = YES;
        
        if (![infoDic[@"avatar"] isEqual:@""]&&infoDic[@"avatar"]) {
            [headerView setImageWithURL:[NSURL URLWithString:infoDic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
            UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)];
            [headerView addGestureRecognizer:tapClick];
            
        }
        [cell.contentView addSubview:headerView];
        
        if (_franchisee&&[_franchisee isEqualToString:@"yes"]) {
            UIImageView *Vimage = [[UIImageView alloc] initWithFrame:CGRectMake(68, 68, 14, 14)];
            Vimage.contentMode = UIViewContentModeScaleAspectFill;
            Vimage.image = [UIImage imageNamed:@"BigVRed"];
            Vimage.clipsToBounds = YES;
            [cell.contentView addSubview:Vimage];
        }

        if (_sign&&[_sign isEqualToString:@"menber"]&&![_franchisee isEqualToString:@"yes"]) {
            UIImageView *Vimage = [[UIImageView alloc] initWithFrame:CGRectMake(68, 68, 14, 14)];
            Vimage.contentMode = UIViewContentModeScaleAspectFill;
            Vimage.image = [UIImage imageNamed:@"BigVBlue"];
            Vimage.clipsToBounds = YES;
            [cell.contentView addSubview:Vimage];
        }
        
        //nick
        UILabel *nicklabel = [[UILabel alloc] initWithFrame:CGRectMake(100,20,30,30)];
        nicklabel.font = TEXT_FONT_LEVEL_1;
        nicklabel.textColor = TEXT_COLOR_LEVEL_2;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
        NSString *str= @"";
        if (infoDic[@"nickename"]&& ![infoDic[@"nickename"] isEqual:@""]) {
            str =infoDic[@"nickename"];
        }else{
            str = @"匿名作者";
        }
        
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(600, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        [nicklabel setFrame:CGRectMake(100, 20, textSize.width, 30)];
        nicklabel.text = str;
        [cell.contentView addSubview:nicklabel];
        
        //gender icon
        UIImageView *genderImage = [[UIImageView alloc] initWithFrame:CGRectMake(textSize.width+5+100, 27, 16, 16)];
        if (infoDic[@"gender"]) {
            if ([infoDic[@"gender"] isEqual:@"1"]) {
                [genderImage setImage:[UIImage imageNamed:@"gender-man"]];
            }else{
                [genderImage setImage:[UIImage imageNamed:@"gender-woman"]];
            }
        }
        [cell.contentView addSubview:genderImage];
        
        //地址
        UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(100, 52, 80, 20)];
        
        if (infoDic[@"address"]&&![infoDic[@"address"] isEqual:@""]) {
            question.text = [NSString stringWithFormat:@"地址：%@", infoDic[@"address"]];
        }else{
            question.text = @"地址：--";
        }
        
        
        question.font = TEXT_FONT_LEVEL_2;
        question.textColor = TEXT_COLOR_LEVEL_3;
        [question sizeToFit];
        question.frame = CGRectMake(100, 50, question.bounds.size.width, 20);
        [cell.contentView addSubview:question];
        
        return cell;
        
    }
    
    
    if (indexPath.section==1) {
        static NSString *cellIdd = @"cellIdd";
        UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            
            return cell;
        }
        
        cell    = [tableView dequeueReusableCellWithIdentifier:cellIdd];
        
        if (!cell) {
            
            cell    = [[LMhomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdd];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.listData.count > indexPath.row) {
            
            LMActicleVO     *vo = self.listData[indexPath.row];
            
            if (vo && [vo isKindOfClass:[LMActicleVO class]]) {
                
                [(LMhomePageCell *)cell setValue:vo];
            }
        }
        
        cell.tag = indexPath.row;
        [(LMhomePageCell *)cell setDelegate:self];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        LMActicleVO *list = [self.listData objectAtIndex:indexPath.row];
        LMHomeDetailController *detailVC = [[LMHomeDetailController alloc] init];
        
        detailVC.artcleuuid = list.articleUuid;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)headClick
{
    
    if (headerView.image) {
        [self showImage:headerView];
    }else{
        return;
    }
}

- (void)showImage:(UIImageView *)avatarImageView{
    self.navigationController.navigationBar.hidden=YES;
    
    UIImage *image=avatarImageView.image;
    //    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    backgroundViews=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:self.view];
    backgroundViews.backgroundColor=[UIColor blackColor];
    backgroundViews.alpha=0;
    imageViews=[[UIImageView alloc]initWithFrame:oldframe];
    imageViews.image=image;
    imageViews.tag=1;
    [backgroundViews addSubview:imageViews];
    [self.view addSubview:backgroundViews];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundViews addGestureRecognizer: tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenImageView:)];
    swipe.numberOfTouchesRequired =1;
    swipe.direction =UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    [backgroundViews addGestureRecognizer:swipe];
    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressAction:)];
    LongPress.minimumPressDuration = 1.0;
    [backgroundViews addGestureRecognizer:LongPress];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageViews.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundViews.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
    }];
}

- (void)hiddenImageView:(UISwipeGestureRecognizer*)tap{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        
    }];
}

- (void)LongPressAction:(UILongPressGestureRecognizer *)longPress
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(headerView.image,self,  @selector(image:didFinishSavingWithError:contextInfo:imageview:), NULL);
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo imageview:(UIImageView *)imageView

{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        imageViews.frame=oldframe;
        backgroundViews.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundViews removeFromSuperview];
        
    }];
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    self.navigationController.navigationBar.hidden=NO;
    [self textStateHUD:msg];
    
    
}

@end
