//
//  DBLocationAdapter.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/14/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBLocationAdapter : NSObject

- (NSArray*)getLocCodesInRange:(double)radius
                    atLatitude:(double)latitude
                     longitude:(double)longitude;

- (BOOL)getLocationName:(NSString**)locationName
               reasonId:(int*)reasonId
                  total:(int*)total
        warningPriority:(int*)warningPriority
              ofLocCode:(NSString*)locCode;

@end
