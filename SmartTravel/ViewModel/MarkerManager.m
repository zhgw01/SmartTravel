//
//  MarkerManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "Marker.h"
#import "MarkerManager.h"

@implementation MarkerManager

- (void)drawMarkersOnMapView:(GMSMapView*)mapView
{
    self.markers = [self createMarkers];
    for (Marker *marker in self.markers)
    {
        marker.gmsMarker.map = mapView;
    }
}

- (void)eraseMarkersOnMapAndReleaseMarkers:(BOOL)releaeMarkers
{
    for (Marker *marker in self.markers)
    {
        marker.gmsMarker.map = nil;
    }
    
    if (releaeMarkers)
    {
        self.markers = nil;
    }
}

- (NSArray*)createMarkers
{
    // Override by sub classes
    return nil;
}

@end
