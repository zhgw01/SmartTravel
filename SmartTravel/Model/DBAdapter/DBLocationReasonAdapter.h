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

- (NSArray*)getLocationReasonsAtLatitude:(double)latitude
                               longitude:(double)longitude
                                  ofDate:(NSDate*)date
                             inDirection:(Direction)direction
                            withinRadius:(double)radius;
@end
