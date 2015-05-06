//
//  MarkerManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "MarkerManager.h"
#import "Collision.h"
#import "VRU.h"
#include "DBManager.h"

@interface MarkerManager()

@property (nonatomic, strong) NSSet* collisionMarkers;
@property (nonatomic, strong) NSSet* vruMarkers;

@end


@implementation MarkerManager

- (void)clearMarkers
{
    for (GMSMarker* marker in self.collisionMarkers) {
        marker.map = nil;
    }
    
    for (GMSMarker* marker in self.vruMarkers) {
        marker.map = nil;
    }
}

-(void)getCollisionMarkers
{
    NSArray* collisions = [[DBManager sharedInstance] selectAllCollisions];
    NSMutableSet* set = [[NSMutableSet alloc] init];
    for (Collision* collision in collisions) {
        GMSMarker* marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(collision.latitude.doubleValue, collision.longtitude.doubleValue);
        marker.icon = [UIImage imageNamed:@"area_collision"];
        [set addObject:marker];
    }
    self.collisionMarkers = [set copy];
}

-(void)getVRUMarkers
{
    NSArray* vrus = [[DBManager sharedInstance] selectAllVRUs];
    NSMutableSet* set = [[NSMutableSet alloc] init];
    for (VRU* vru in vrus) {
        GMSMarker* marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(vru.latitude.doubleValue, vru.longtitude.doubleValue);
        marker.icon = [UIImage imageNamed:@"area_vru"];
        [set addObject:marker];
    }
    self.vruMarkers = [set copy];
}

- (void)drawMarkers: (GMSMapView *)mapView
{
    [self clearMarkers];
    [self getCollisionMarkers];
    [self getVRUMarkers];
    
    for (GMSMarker* marker in self.collisionMarkers) {
        if (marker.map == nil) {
            marker.map = mapView;
        }
    }
    
    for (GMSMarker* marker in self.vruMarkers) {
        if (marker.map == nil) {
            marker.map = mapView;
        }
    }
 
}

@end
