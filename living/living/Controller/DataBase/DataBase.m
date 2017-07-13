//
//  DataBase.m
//  living
//
//  Created by hxm on 2017/7/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "DataBase.h"
#import <FMDB/FMDB.h>
#import "FitUserManager.h"
static DataBase *dataBase = nil;

@interface DataBase ()

@property (nonatomic, strong) FMDatabase *db;
@end

@implementation DataBase

+ (instancetype)sharedDataBase {
    if (dataBase == nil) {
        dataBase = [[DataBase alloc] init];
    }
    [dataBase initDataBase];
    return dataBase;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (dataBase == nil) {
        
        dataBase = [super allocWithZone:zone];
    }
    return dataBase;
    
}

-(id)copy{
    
    return self;
}

-(id)mutableCopy{
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
}
-(void)initDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"yaoguo.sqlite"];
    NSLog(@"%@", NSHomeDirectory());
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS 'draft' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'title' VARCHAR(255),'desp' VARCHAR(255),'category' VARCHAR(255),'type' VARCHAR(255),'content' text,'time' VARCHAR(255))";
    
    [_db executeUpdate:sql];

    [_db close];
}


- (BOOL)addToDraft:(NSDictionary *)info {
    
    [_db open];
    
    BOOL isOK = [_db executeUpdate:@"INSERT INTO draft(person_id,title,desp,category,type,content,time) values(?,?,?,?,?,?,?);" withArgumentsInArray:@[info[@"person_id"], info[@"title"], info[@"desp"], info[@"category"], info[@"type"], info[@"content"], info[@"time"]]];
    if (!isOK) {
        NSLog(@"插入失败");
    } else {
        NSLog(@"插入成功");
    }
    [_db close];
    return isOK;
}
- (NSArray *)queryFromDraft {
    [_db open];
    
    NSMutableArray *array = [NSMutableArray new];
    NSString *sql = @"select * from draft where person_id = ? order by id desc;";
    FMResultSet *res = [_db executeQuery:sql withArgumentsInArray:@[[FitUserManager sharedUserManager].uuid]];
    while ([res next]) {
        NSString *draftID = [res stringForColumn:@"id"];
        NSString *title = [res stringForColumn:@"title"];
        NSString *desp = [res stringForColumn:@"desp"];
        NSString *category = [res stringForColumn:@"category"];
        NSString *type = [res stringForColumn:@"type"];
        NSString *content = [res stringForColumn:@"content"];
        NSString *time = [res stringForColumn:@"time"];
        
        NSDictionary *articleDic = @{@"id":draftID, @"title":title, @"desp":desp, @"category":category, @"type":type, @"content":content, @"time":time};
        [array addObject:articleDic];
    }
    [_db close];
    return array;
}
- (BOOL)deleteFromDraftWithID:(NSString *)ID {
    [_db open];
    
    BOOL isOK = [_db executeUpdate:@"delete from draft where id = ?" withArgumentsInArray:@[ID]];
    if (!isOK) {
        NSLog(@"删除失败");
    } else {
        NSLog(@"删除成功");
    }

    [_db close];
    return isOK;
}

//清空表
- (BOOL)deleteAllDataFromDraft {
    
    [_db open];
    
    BOOL isOK = [_db executeUpdate:@"delete from draft;"];
    if (!isOK) {
        NSLog(@"删除失败");
    } else {
        NSLog(@"删除成功");
    }
    
    [_db close];
    return isOK;
}
//删除表
- (void)deleteTableWithName:(NSString *)table {
    [_db open];
    
    [_db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@;", table]];
    [_db close];
}

@end
