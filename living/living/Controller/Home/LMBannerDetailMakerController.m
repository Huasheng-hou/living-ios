//
//  LMBannerDetailMakerController.m
//  living
//
//  Created by Huasheng on 2017/2/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBannerDetailMakerController.h"
#import "LMMakerHeadView.h"
@interface LMBannerDetailMakerController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation LMBannerDetailMakerController
{
    UICollectionView * _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
    
}

- (void)createUI{

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
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
    
    UILabel * slogan = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, (kScreenWidth-30)/2-60, 55)];
    slogan.text = @"一个企业人的自我修养";
    slogan.textColor = [UIColor whiteColor];
    slogan.font = TEXT_FONT_BOLD_14;
    slogan.textAlignment = NSTextAlignmentCenter;
    slogan.numberOfLines = 2;
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


@end
