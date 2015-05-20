//
//  DBLocationReasonAdapter.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/15/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Direction.h"

@interface DBLocationReasonAdapter : NSObject

// Get top 1 location_reason which satisfy all the requirements
- (NSDictionary*)getLocationReasonAtLatitude:(double)latitude
                                   longitude:(double)longitude
                                 ofReasonIds:(NSArray*)reasonIds
                                 inDirection:(Direction)direction
                                withinRadius:(double)radius;
@end
