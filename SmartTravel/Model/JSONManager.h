//
//  JSONManager.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

// NOTE: Currently it's a utility class to assit read test data in json format
@interface JSONManager : NSObject

+ (JSONManager *)sharedInstance;

- (NSArray*)readJSONFromReadonlyJSONFile:(NSString*)fileName;

@end
