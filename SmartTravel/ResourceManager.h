//
//  ResourceManager.h
//  SmartTravel
//
//  Created by ChenPengyu on 15/6/2.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject

+ (ResourceManager *)sharedInstance;

// Return YES if copy succeeded
+ (BOOL)copyResourceFromAppBundle:(NSString*)oldFileName
        toUserDocumentWithNewName:(NSString*)newFileName
                          withExt:(NSString*)ext
                   forceOverwrite:(BOOL)forceOverwrite;

// Check if there's newer version online. If there's, update the data.
+ (BOOL)updateOnline;

@end
