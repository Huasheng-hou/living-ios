//
//  DataBase.h
//  living
//
//  Created by hxm on 2017/7/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

+ (instancetype)sharedDataBase;


- (BOOL)addToDraft:(NSDictionary *)info;
- (BOOL)deleteFromDraftWithID:(NSString *)ID;
- (BOOL)updateDraft:(NSString *)ID withInfo:(NSDictionary *)info;
- (NSArray *)queryFromDraft;

- (BOOL)deleteAllDataFromDraft;

//删除表
- (void)deleteTableWithName:(NSString *)table;

@end
