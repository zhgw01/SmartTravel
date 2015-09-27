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

- (void)enable:(BOOL)flag
     onMapView:(GMSMapView*)mapView
{
    if (flag)
    {
        self.markers = [self createMarkers];
        [self attachMapView:mapView];
    }
    else
    {
        [self detachMapView];
        self.markers = nil;
    }
}

- (NSArray*)createMarkers
{
    // Override by sub classes
    return nil;
}

- (void)detachMapView
{
    for (Marker *marker in self.markers)
    {
        marker.gmsMarker.map = nil;
    }
}

- (void)attachMapView:(GMSMapView*)mapView
{
    for (Marker *marker in self.markers)
    {
        marker.gmsMarker.map = mapView;
    }
}

@end
