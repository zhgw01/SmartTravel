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
#import "AnimatedGMSMarker.h"

static NSString * const kStaticMarkerIconName = @"area_collision";
static NSString * const kBreathingIconBaseName = @"breathing";

@interface MarkerManager()

/**
 *  Key is location code
 *  Value is the marker
 */
@property (nonatomic, strong) NSDictionary* hotSpotMarkersDic;

@property (nonatomic, copy) NSString* lastBreathingLocCode;
@property (nonatomic, strong) NSArray* breathingFrameArray;

@end

@implementation MarkerManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.breathingFrameArray = @[
                                     @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10",
                                     @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                                     @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30"
                                     ];
    }
    return self;
}

- (void)clearMarkers
{
    NSEnumerator* enu = [self.hotSpotMarkersDic keyEnumerator];
    NSString* locCode = nil;
    while (locCode = [enu nextObject])
    {
        AnimatedGMSMarker* marker = self.hotSpotMarkersDic[locCode];
        marker.map = nil;
    }
}

- (void)getHotSpotMarkers
{
    NSArray* hotSpots = [[DBManager sharedInstance] selectHotSpots:HotSpotTypeAllExceptSchoolZone];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for (HotSpot* hotSpot in hotSpots)
    {
        AnimatedGMSMarker* marker = [[AnimatedGMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(hotSpot.latitude.doubleValue,
                                                     hotSpot.longtitude.doubleValue);
        marker.icon = [UIImage imageNamed:kStaticMarkerIconName];
        [dic setObject:marker forKey:hotSpot.locCode];
    }
    self.hotSpotMarkersDic = [dic copy];
}

- (void)drawMarkers: (GMSMapView *)mapView
{
    [self clearMarkers];
    [self getHotSpotMarkers];
    
    NSEnumerator* enu = [self.hotSpotMarkersDic keyEnumerator];
    NSString* locCode = nil;
    while (locCode = [enu nextObject])
    {
        AnimatedGMSMarker* marker = self.hotSpotMarkersDic[locCode];
        marker.map = mapView;
    }
}

- (void)breathingMarker:(NSString*)locCode;
{
    if ([self.lastBreathingLocCode isEqualToString:locCode])
    {
        return;
    }
    
    // Stop breathing last marker
    AnimatedGMSMarker* lastBreathingMarker = [self.hotSpotMarkersDic objectForKey:self.lastBreathingLocCode];
    [lastBreathingMarker stopAnimation:kStaticMarkerIconName];
    
    self.lastBreathingLocCode = locCode;
    
    // Start breathing recent marker
    AnimatedGMSMarker* marker = [self.hotSpotMarkersDic objectForKey:self.lastBreathingLocCode];
    [marker setAnimation:kBreathingIconBaseName forFrames:self.breathingFrameArray];
}

@end
