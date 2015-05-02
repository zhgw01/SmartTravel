//
//  DBManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

- (FMDatabase *) db
{
    if (!self.path) {
        NSLog(@"You must specify the database file path");
        return nil;
    }
    
    return [FMDatabase databaseWithPath:self.path];
}


@end
