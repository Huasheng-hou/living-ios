//
//  LMCommentCell.m
//  living
//
//  Created by Ding on 16/9/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCommentCell.h"
#import "FitConsts.h"

@interface LMCommentCell () {
    float _xScale;
    float _yScale;
}

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic,strong) UIImageView *addIcon;

@property (nonatomic,strong)UIView *backView;


@end

@implementation LMCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    _imageV = [UIImageView new];
    _imageV.backgroundColor = BG_GRAY_COLOR;
    [_imageV sizeToFit];
    _imageV.frame = CGRectMake(15, 15, 30, 30);
     _imageV.layer.cornerRadius =15;
    [_imageV setClipsToBounds:YES];
    _imageV.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_imageV];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:12.f];
    _nameLabel.textColor = TEXT_COLOR_LEVEL_3;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    
    _timeLabel = [UILabel new];

    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    _timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines  = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_titleLabel];
    
    
    _addIcon = [UIImageView new];
    _addIcon.image =[UIImage imageNamed:@"addIcon"];
    [self.contentView addSubview:_addIcon];
    
    
    _addressLabel = [UILabel new];
    _addressLabel.text = @"浙江杭州";
    _addressLabel.font = [UIFont systemFontOfSize:12.f];
    _addressLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_addressLabel];
    
    _lineLabel = [UILabel new];
    _lineLabel.backgroundColor =LINE_COLOR;
    [self.contentView addSubview:_lineLabel];
    
    
    _zanButton = [[LMCommentButton alloc] init];
    _zanButton.headImage.image = [UIImage imageNamed:@"zanIcon"];
    _zanButton.textLabel.textColor = TEXT_COLOR_LEVEL_3;
//    [_zanButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_zanButton];
    
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentAction:)];
    [_backView addGestureRecognizer:tap];
    
    
    
    _replyButton = [[LMCommentButton alloc] init];
    _replyButton.headImage.image = [UIImage imageNamed:@"reply"];
    [_replyButton.headImage sizeToFit];
    _replyButton.headImage.frame = CGRectMake(0, 6, 12, 12);
    _replyButton.textLabel.text = @"回复";
    _replyButton.textLabel.textColor = TEXT_COLOR_LEVEL_3;
    [_replyButton addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_replyButton];
}

- (void)setValue:(LMActicleCommentVO *)data
{

        if ([data.type isEqual:@"comment"]) {
                [_imageV sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"headIcon"]];
                if (data.nickName == nil) {
                    _nameLabel.text = @"匿名用户";
                }else{
                    _nameLabel.text = data.nickName;
                }
                _timeLabel.text = [self getUTCFormateDate:data.commentTime];
                _titleLabel.text = data.commentContent;
            
            
                if (data.hasPraised == YES) {
                    _zanButton.headImage.image = [UIImage imageNamed:@"zanIcon-click"];
                }else{
                    _zanButton.headImage.image = [UIImage imageNamed:@"zanIcon"];
                }
               _addressLabel.text = data.address;
                _zanButton.textLabel.text = [NSString stringWithFormat:@"%d",data.praiseCount];
            
                _commentUUid = data.commentUuid;
            
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
                //参数1 代表文字自适应的范围 2代表 文字自适应的方式前三种 3代表文字在自适应过程中自适应的字体大小
                _conHigh = [data.commentContent boundingRectWithSize:CGSizeMake(kScreenWidth-70, 100000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
        }
        if ([data.type isEqual:@"reply"]){

            [_imageV sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"headIcon"]];
            if (data.nickName == nil) {
                _nameLabel.text = [NSString stringWithFormat:@"匿名用户 回复了 %@",data.respondentNickname];
            }else{
                _nameLabel.text = [NSString stringWithFormat:@"%@ 回复了 %@",data.nickName,data.respondentNickname];
            }
            _addressLabel.text = data.address;
            _timeLabel.text = [self getUTCFormateDate:data.replyTime];
            _titleLabel.text = data.commentContent;
            _zanButton.hidden = YES;
            
            _replyButton.hidden = YES;
        
            _commentUUid = data.commentUuid;
            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            //参数1 代表文字自适应的范围 2代表 文字自适应的方式前三种 3代表文字在自适应过程中自适应的字体大小
            _conHigh    = [data.commentContent boundingRectWithSize:CGSizeMake(kScreenWidth-70, 100000)
                                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:attributes
                                                            context:nil].size.height;
    }   
}

- (void)setXScale:(float)xScale yScale:(float)yScale
{
    _xScale = xScale;
    _yScale = yScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_nameLabel sizeToFit];
    [_titleLabel sizeToFit];
    [_timeLabel sizeToFit];
    [_addIcon sizeToFit];
    [_addressLabel sizeToFit];
    [_replyButton sizeToFit];
    [_zanButton.textLabel sizeToFit];
    [_replyButton.textLabel sizeToFit];
    
    _zanButton.textLabel.frame = CGRectMake(15, 5, _zanButton.textLabel.bounds.size.width, _zanButton.textLabel.bounds.size.height);

    _replyButton.textLabel.frame = CGRectMake(15, 5, _replyButton.textLabel.bounds.size.width, _replyButton.textLabel.bounds.size.height);
    
    _nameLabel.frame = CGRectMake(55, 15, _nameLabel.bounds.size.width, 20);
    
    _timeLabel.frame = CGRectMake(55, 35, _timeLabel.bounds.size.width, _timeLabel.bounds.size.height);
    _titleLabel.frame = CGRectMake(55, 60, kScreenWidth-70, _conHigh);

    _addIcon.frame = CGRectMake(55, 70+_conHigh, _addIcon.bounds.size.width, _addIcon.bounds.size.height);
        _addressLabel.frame =CGRectMake(58+_addIcon.bounds.size.width,70+_conHigh, _addressLabel.bounds.size.width, _addressLabel.bounds.size.height);
    
    _lineLabel.frame = CGRectMake(15, 75+_conHigh+18, kScreenWidth-30, 0.5);
    
    _replyButton.frame = CGRectMake(kScreenWidth-_replyButton.textLabel.bounds.size.width-45, 65+_conHigh, _replyButton.textLabel.bounds.size.width+30, 30);
    
    _zanButton.frame = CGRectMake(kScreenWidth-_zanButton.textLabel.bounds.size.width-80-_replyButton.bounds.size.width, 70+_conHigh-5, _zanButton.textLabel.bounds.size.width+20, 30);
    _backView.frame = CGRectMake(kScreenWidth-_zanButton.textLabel.bounds.size.width-100-_replyButton.bounds.size.width, 55+_conHigh, _zanButton.textLabel.bounds.size.width+50, 35);
}

+ (CGFloat)cellHigth:(NSString *)titleString
{
    NSDictionary *attributes    = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGFloat conHigh = [titleString boundingRectWithSize:CGSizeMake(kScreenWidth-70, 100000)
                                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:attributes
                                                context:nil].size.height;
 
    return (75 + conHigh + 18 + 0.5);
}

- (void)commentAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillComment:)]) {
        [_delegate cellWillComment:self];
    }
}

- (void)replyAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(cellWillReply:)]) {
        [_delegate cellWillReply:self];
    }
}

- (NSString *)getUTCFormateDate:(NSString *)newDate
{
    NSString *str=[newDate substringWithRange:NSMakeRange(0, 16)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:str];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *dateContent  = nil;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"MM-dd HH:mm"];
        
    NSString *str2= [dateFormatter2 stringFromDate:newsDateFormatted];
    dateContent = str2;
    
    return dateContent;
}

@end
