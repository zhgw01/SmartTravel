//
//  Marker.m
//  SmartTravel
//
//  Created by chenpold on 9/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "Marker.h"

@implementation Marker

- (instancetype)initWithLocationId:(NSString*)locationId
                              type:(HotSpotType)type
                         gmsMarker:(GMSMarker*)gmsMarker
{
    if (self = [super init])
    {
        self.locationCode = locationId;
        self.type       = type;
        self.gmsMarker  = gmsMarker;
    }
    return self;
}

@end
