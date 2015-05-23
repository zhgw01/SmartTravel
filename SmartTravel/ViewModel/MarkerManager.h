//
//  MarkerManager.h
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MarkerManager : NSObject

/**
 *  Enable the breathing effect of the marker for the given location code
 *
 *  @param locCode location code of NSString*
 */
- (void)breathingMarker:(NSString*)locCode;

- (void)drawMarkers:(GMSMapView *)mapView;

@end
