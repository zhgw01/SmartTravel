//
//  SchoolMarkerManager.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "Marker.h"
#import "DBSchoolAdapter.h"
#import "SchoolMarkerManager.h"

static NSString * const kMarkerSchoolIcon = @"school";

@implementation SchoolMarkerManager

// Override parent class
- (NSArray*)createMarkers
{
    DBSchoolAdapter *dbSchoolAdapter = [[DBSchoolAdapter alloc] init];
    NSArray *allSchools = [dbSchoolAdapter selectAllSchools];
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    for (NSDictionary *school in allSchools)
    {
        double latitude = [[school valueForKey:kColLatitude] doubleValue];
        double longitude = [[school valueForKey:kColLongitude] doubleValue];
        
        Marker *gmsMarker       = [[Marker alloc] init];
        gmsMarker.position      = CLLocationCoordinate2DMake(latitude, longitude);
        gmsMarker.icon          = [UIImage imageNamed:kMarkerSchoolIcon];
        gmsMarker.locationName  = [school valueForKey:kColSchoolName];
        // TODO: Need location id for school?
        gmsMarker.locationCode  = @"School Location Code";
        gmsMarker.hotSpotType   = HotSpotTypeSchoolZone;
        [markers addObject:gmsMarker];
    }
    return [markers copy];
}
@end
