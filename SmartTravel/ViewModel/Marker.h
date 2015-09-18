//
//  Marker.h
//  SmartTravel
//
//  Created by chenpold on 9/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "HotSpot.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>

/**
 *  UI model represents a marker
 */
@interface Marker : NSObject

@property (copy, nonatomic  ) NSString    *locationCode;
@property (assign, nonatomic) HotSpotType type;
@property (strong, nonatomic) GMSMarker   *gmsMarker;

- (instancetype)initWithLocationId:(NSString*)locationId
                              type:(HotSpotType)type
                         gmsMarker:(GMSMarker*)gmsMarker;
@end
