//
//  CollisionMarkerManager.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "Marker.h"
#import "DBManager.h"
#import "CollisionMarkerManager.h"

static NSString * const kMarkerCollisionIcon    = @"area_collision";
static NSString * const kBreathingIconBaseName  = @"breathing";

@interface CollisionMarkerManager ()

@property (nonatomic, copy  ) NSString  *preBreathLocationCode;
@property (nonatomic, strong) NSArray   *breathFrameArray;

@end

@implementation CollisionMarkerManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.breathFrameArray = @[
                                @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10",
                                @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                                @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30"
                                ];
    }
    return self;
}

// Override parent class
- (NSArray*)createMarkers
{
    NSArray* hotSpots = [[DBManager sharedInstance] selectHotSpots:HotSpotTypeAllExceptSchool];
    
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    for (HotSpot* hotSpot in hotSpots)
    {
        Marker* gmsMarker            = [[Marker alloc] init];
        gmsMarker.position           = CLLocationCoordinate2DMake(hotSpot.latitude.doubleValue, hotSpot.longtitude.doubleValue);
        gmsMarker.icon               = [UIImage imageNamed:kMarkerCollisionIcon];
        gmsMarker.locationCode       = hotSpot.locCode;
        gmsMarker.locationName       = hotSpot.location;
        gmsMarker.hotSpotType        = hotSpot.type;
        [markers addObject:gmsMarker];
    }
    return [markers copy];
}

- (void)breath:(NSString*)locationCode
{
    if ([self.preBreathLocationCode isEqualToString:locationCode])
    {
        return;
    }
    
    // Stop breathing last marker
    Marker *lastBreathingMarker = [self selectMarker:self.preBreathLocationCode];
    [lastBreathingMarker stopAnimation:kMarkerCollisionIcon];
    
    self.preBreathLocationCode = locationCode;
    
    // Start breathing recent marker
    Marker *curBreathingMarker = [self selectMarker:locationCode];
    [curBreathingMarker setAnimation:kBreathingIconBaseName forFrames:self.breathFrameArray];

}

- (void)stopBreath
{
    if (self.preBreathLocationCode)
    {
        Marker *lastBreathingMarker = [self selectMarker:self.preBreathLocationCode];
        [lastBreathingMarker stopAnimation:kMarkerCollisionIcon];
        
        self.preBreathLocationCode = nil;
    }
}

- (Marker*)selectMarker:(NSString*)locationCode
{
    Marker *res = nil;
    for (Marker *marker in self.markers)
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
