//
//  DBLocationAdapter.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/14/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionUtility.h"

/**
 *  Adapter to facilicate query and join query location related tables including
 *  TBL_COLLOSION_LOCATION,
 *  TBL_LOCATION_REASON
 */
@interface DBLocationAdapter : NSObject

- (NSArray*)getLocationsOfReasonIds:(NSArray*)reasonIds
                        inDirection:(Direction)direction
                withinLocationCodes:(NSArray*)locCodes;

- (NSArray*)getLocCodesInRange:(double)radius
                    atLatitude:(double)latitude
                     longitude:(double)longitude;

- (BOOL)getLocationName:(NSString**)locationName
               latitude:(double*)latitude
              longitude:(double*)longitude
              ofLocCode:(NSString*)locCode;

@end
