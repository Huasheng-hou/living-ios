//
//  LMYaoGuoBiConvertController.m
//  living
//
//  Created by hxm on 2017/3/9.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYaoGuoBiConvertController.h"

#import "FitConsts.h"
#import "LMSubmitOrderController.h"

@interface LMYaoGuoBiConvertController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LMYaoGuoBiConvertController
{
    NSString * content;
    NSString * detail;
    
    
    
    
    UIImageView * headImage;
    UILabel * activityDetail;
    UILabel * activityIntroduction;
    UILabel * convert;
    
}
- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.ifRemoveLoadNoState        = NO;
        self.ifShowTableSeparator       = NO;
        self.hidesBottomBarWhenPushed   = NO;
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

    
    [self createUI];
    [self loadNewer];

}

- (void)createUI{
    [super createUI];
    content = @"活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍";
    detail = @"讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等讲师地址电话参与方法等等";

    self.navigationItem.title = @"腰果币兑换";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (FitBaseRequest *)request{
    FitBaseRequest * req = [[FitBaseRequest alloc] initWithNone];
    return req;
}
#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return kScreenWidth*3/5;
    }
    if (indexPath.section == 1) {
//        return 100;
        return [self getFrameByContent:content].size.height;
    }
    if (indexPath.section == 2) {
//        return 200;
        return [self getFrameByContent:detail].size.height;

    }
    if (indexPath.section == 3) {
        return 45;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 30;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * nameList = @[@"| 活动介绍", @"| 活动详情"];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 10)];
    titleLabel.textColor = TEXT_COLOR_LEVEL_4;
    titleLabel.font = TEXT_FONT_LEVEL_4;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:nameList[section-1]];
    [attr addAttribute:NSForegroundColorAttributeName value:LIVING_COLOR range:NSMakeRange(0, 2)];
    titleLabel.attributedText = attr;
    [headerView addSubview:titleLabel];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];

        }
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/5)];
        headImage.backgroundColor = BG_GRAY_COLOR;
        headImage.image = [UIImage imageNamed:@"demo"];
        headImage.contentMode = UIViewContentModeScaleAspectFill;
        headImage.clipsToBounds = YES;
        
        [cell.contentView addSubview:headImage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"introCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"introCell"];
            
        }
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        CGFloat h = [self getFrameByContent:content].size.height;
        activityIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, h)];
        activityIntroduction.text = content;
        activityIntroduction.textColor = TEXT_COLOR_LEVEL_3;
        activityIntroduction.font = TEXT_FONT_LEVEL_3;
        activityIntroduction.numberOfLines = -1;
        [activityIntroduction sizeToFit];
        
        [cell.contentView addSubview:activityIntroduction];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
            
        }
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        CGFloat h = [self getFrameByContent:detail].size.height;
        activityDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, h)];
        activityDetail.text = detail;
        activityDetail.textColor = TEXT_COLOR_LEVEL_3;
        activityDetail.font = TEXT_FONT_LEVEL_3;
        activityDetail.numberOfLines = -1;
        [activityDetail sizeToFit];
        
        [cell.contentView addSubview:activityDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"convertCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"convertCell"];
            
        }
        for (UIView * subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        convert = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth-50, 45)];
        convert.backgroundColor = ORANGE_COLOR;
        convert.text = @"立即兑换";
        convert.textColor = [UIColor whiteColor];
        convert.font = TEXT_FONT_LEVEL_2;
        convert.textAlignment = NSTextAlignmentCenter;
        convert.layer.masksToBounds = YES;
        convert.layer.cornerRadius = 3;
        [cell.contentView addSubview:convert];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    if (indexPath.section == 3) {
        LMSubmitOrderController * order = [[LMSubmitOrderController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }
    
}

#pragma mark - label宽高自适应
- (CGRect)getFrameByContent:(NSString *)text{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, kScreenWidth-40, 0)];
    label.text = text;
    //label.text = @"发动机上课了福建师范iOS防腐剂of绝对是客服你就看程序自动付款拉斯访问我看到弗利萨覅我陪我跑就是卡了防守打法静安寺反倒是开了房间卡拉是否打扫房间卡洛斯覅发到手机卡冷风机昂克赛拉覅发生快乐i1658461538461231234679164891的说法发大水";
    label.font = TEXT_FONT_LEVEL_3;
    label.numberOfLines = -1;
    [label sizeToFit];

    return label.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
