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

@interface SchoolMarkerManager ()

@property (nonatomic, strong) NSArray           *schoolMarkers;
@property (nonatomic, strong) DBSchoolAdapter   *dbSchoolAdapter;

@end

@implementation SchoolMarkerManager

// Override parent class
- (NSArray*)createMarkers
{
    NSArray *allSchools = [self.dbSchoolAdapter selectAllSchools];
    NSMutableArray *markers = [[NSMutableArray alloc] init];
    for (NSDictionary *school in allSchools)
    {
        double latitude = [[school valueForKey:kColLatitude] doubleValue];
        double longitude = [[school valueForKey:kColLongitude] doubleValue];
        
        GMSMarker *gmsMarker    = [[GMSMarker alloc] init];
        gmsMarker.position      = CLLocationCoordinate2DMake(latitude, longitude);
        gmsMarker.icon          = [UIImage imageNamed:kMarkerSchoolIcon];
        
        // TODO: Need location id for school?
        Marker *marker = [[Marker alloc] initWithLocationId:@"School Location ID"
                                                       type:HotSpotTypeSchoolZone
                                                  gmsMarker:gmsMarker];
        [markers addObject:marker];
    }
    return [markers copy];
}
@end
