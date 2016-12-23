
//
//  BabBaseRequest.h
//  BabTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitBaseRequest : NSObject

@property (readonly, nonatomic) NSMutableDictionary     * params;
@property (strong, nonatomic)   NSData                  * imageData;
@property (strong, nonatomic)   NSString                * imageName;
@property (strong,nonatomic)    NSData                  * fileData;

//无输入参数初始化
- (id)initWithNone;

//服务器地址前缀，有默认值
- (NSString *)serverHost;

//是否是POST操作
- (BOOL)isPost;

//操作接口号路径
- (NSString *)methodPath;

//查询数据，这里会把公用的uid/token/time之类的数据附加进去
- (NSDictionary *)query;

//封装后的查询请求
- (NSURLRequest *)req;

//该接口是否需要用户授权才能调用,默认为YES
- (BOOL)isPrivate;

//该接口是否包含图片,默认为NO
- (BOOL)isImageInclude;

- (BOOL)isVoiceInclude;

@end
