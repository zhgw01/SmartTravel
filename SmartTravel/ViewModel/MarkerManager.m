//
//  MarkerManager.m
//  SmartTravel
//
//  Created by Gongwei on 15/5/5.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "Marker.h"
#import "MarkerManager.h"
#import "DBManager.h"
#import "HotSpot.h"
#import "AnimatedGMSMarker.h"

static NSString * const kStaticMarkerIconName  = @"area_collision";
static NSString * const kBreathingIconBaseName = @"breathing";

@implementation MarkerManager

- (instancetype)initWithType:(HotSpotType)type
{
    if (self = [super init])
    {
        self.type                  = type;
        self.hotSpotMarkers        = nil;
        self.preBreathLocationCode = nil;
        self.breathFrameArray  = @[
                                     @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10",
                                     @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                                     @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30"
                                     ];
    }
    return self;
}

- (void)refreshHotSpotMarkers
{
    NSArray* hotSpots = [[DBManager sharedInstance] selectHotSpots:self.type];
    
    NSMutableArray *markArr = [[NSMutableArray alloc] init];
    for (HotSpot* hotSpot in hotSpots)
    {
        AnimatedGMSMarker* gmsMarker = [[AnimatedGMSMarker alloc] init];
        gmsMarker.position           = CLLocationCoordinate2DMake(hotSpot.latitude.doubleValue, hotSpot.longtitude.doubleValue);
        gmsMarker.icon               = [UIImage imageNamed:kStaticMarkerIconName];
        gmsMarker.locCode            = hotSpot.locCode;
        gmsMarker.locationName       = hotSpot.location;
        
        Marker *marker = [[Marker alloc] initWithLocationId:hotSpot.locCode
                                                       type:hotSpot.type
                                                  gmsMarker:gmsMarker];
        [markArr addObject:marker];
    }
    self.hotSpotMarkers = [markArr copy];
}

- (void)detachGMSMapView
{
    for (Marker *marker in self.hotSpotMarkers)
    {
        marker.gmsMarker.map = nil;
    }
}

- (void)attachGMSMapView:(GMSMapView *)mapView
{
    [self detachGMSMapView];
    [self refreshHotSpotMarkers];
    
    for (Marker *marker in self.hotSpotMarkers)
    {
        marker.gmsMarker.map = mapView;
    }
}

- (void)breath:(NSString*)locationCode
{
    if ([self.preBreathLocationCode isEqualToString:locationCode])
    {
        return;
    }
    
    // Stop breathing last marker
    Marker *lastBreathingMarker = [self selectMarker:self.preBreathLocationCode];
    if (lastBreathingMarker)
    {
        AnimatedGMSMarker *animatedGMSMarker = (AnimatedGMSMarker *)lastBreathingMarker.gmsMarker;
        [animatedGMSMarker stopAnimation:kStaticMarkerIconName];
    }
    
    self.preBreathLocationCode = locationCode;
    
    // Start breathing recent marker
    Marker *curBreathingMarker = [self selectMarker:locationCode];
    if (curBreathingMarker)
    {
        AnimatedGMSMarker *animatedGMSMarker = (AnimatedGMSMarker *)curBreathingMarker.gmsMarker;
        [animatedGMSMarker setAnimation:kBreathingIconBaseName forFrames:self.breathFrameArray];
    }
}

- (void)stopBreath
{
    if (self.preBreathLocationCode)
    {
        Marker *lastBreathingMarker = [self selectMarker:self.preBreathLocationCode];
        if (lastBreathingMarker)
        {
            AnimatedGMSMarker *animatedGMSMarker = (AnimatedGMSMarker *)lastBreathingMarker.gmsMarker;
            [animatedGMSMarker stopAnimation:kStaticMarkerIconName];
        }
        
        self.preBreathLocationCode = nil;
    }
}

- (Marker*)selectMarker:(NSString*)locationCode
{
    Marker *res = nil;
    for (Marker *marker in self.hotSpotMarkers)
    {
        if ([marker.locationCode isEqualToString:locationCode])
        {
            res = marker;
            break;
        }
    }
    return res;
}

@end
