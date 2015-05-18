//
//  MarkerManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "MarkerManager.h"
#import "DBManager.h"
#import "HotSpot.h"

@interface MarkerManager()

@property (nonatomic, strong) NSSet* hotSpotMarkers;

@end


@implementation MarkerManager

- (void)clearMarkers
{
    for (GMSMarker* marker in self.hotSpotMarkers) {
        marker.map = nil;
    }
}

- (void)getHotSpotMarkers
{
    NSArray* hotSpots = [[DBManager sharedInstance] selectHotSpots:HotSpotTypeAllExceptSchoolZone];
    NSMutableSet* set = [[NSMutableSet alloc] init];
    for (HotSpot* hotSpot in hotSpots)
    {
        GMSMarker* marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(hotSpot.latitude.doubleValue, hotSpot.longtitude.doubleValue);
        marker.icon = [UIImage imageNamed:@"area_collision"];
        [set addObject:marker];
    }
    self.hotSpotMarkers = [set copy];
}


- (void)drawMarkers: (GMSMapView *)mapView
{
    [self clearMarkers];
    [self getHotSpotMarkers];
    
    for (GMSMarker* marker in self.hotSpotMarkers) {
        if (marker.map == nil) {
            marker.map = mapView;
        }
    }
}

@end
