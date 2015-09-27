//
//  SchoolShapeManager.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "DBSchoolAdapter.h"
#import "LocationCoordinate.h"
#import "SchoolShapeManager.h"

@interface SchoolShapeManager ()

@property (nonatomic, strong) DBSchoolAdapter *dbSchoolAdapter;

@end

@implementation SchoolShapeManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.dbSchoolAdapter = [[DBSchoolAdapter alloc] init];
    }
    return self;
}

// Override parent class
- (NSArray*)createShapes
{
    NSMutableArray *allSchoolZones = [[NSMutableArray alloc] init];

    NSArray *allSchools = [self.dbSchoolAdapter selectAllSchools];
    for (NSDictionary *school in allSchools)
    {
        NSString *segmentsStr = [school objectForKey:kColSzSegments];
        NSArray *segments = [LocationCoordinate parseSegmentsFromString:segmentsStr];
        
        NSMutableArray *polylines = [[NSMutableArray alloc] init];
        for (NSArray *segment in segments)
        {
            GMSPath *path = [self pathFromSegment:segment];
            
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeWidth  = self.defaultStrokeWidth;
            polyline.spans        = @[[GMSStyleSpan spanWithStyle:self.defaultStrokeStyle]];
            
            [polylines addObject:polyline];
        }
        [allSchoolZones addObject:polylines];
    }

    return [allSchoolZones copy];
}

// Override parent class
- (void)drawShapesOnMapView:(GMSMapView*)mapView
{
    self.shapes = [self createShapes];
    
    for (NSArray *schoolZone in self.shapes)
    {
        for(GMSPolyline *polyline in schoolZone)
        {
            polyline.map = mapView;
        }
    }
}

- (GMSPath*)pathFromSegment:(NSArray*)segment
{
    GMSMutablePath *path = [GMSMutablePath path];
    for (LocationCoordinate* point in segment)
    {
        [path addLatitude:point.latitude
                longitude:point.longitude];
    }
    return path;
}

// Override parent class
- (void)eraseShapesOnMapAndReleaseShapes:(BOOL)releaseShapes
{
    for (NSArray *schoolZone in self.shapes)
    {
        for(GMSPolyline *polyline in schoolZone)
        {
            polyline.map = nil;
        }
    }
    
    if (releaseShapes)
    {
        self.shapes = nil;
    }
}

@end

