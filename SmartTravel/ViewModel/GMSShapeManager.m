//
//  GMSShapeManager.m
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//
#import "LocationCoordinate.h"
#import "GMSShapeManager.h"

@interface GMSShapeManager ()

@property (nonatomic, assign) CGFloat defaultStrokeWidth;
@property (nonatomic, strong) GMSStrokeStyle *defaultStrokeStyle;
@property (nonatomic, strong) NSArray *schoolZones;

@end

@implementation GMSShapeManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.defaultStrokeWidth = 2.f;
        self.defaultStrokeStyle = [GMSStrokeStyle solidColor:[UIColor redColor]];
    }
    return self;
}

- (void)drawSchoolZones:(NSArray*)schoolZones
                  onMap:(GMSMapView*)map
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (NSArray *schoolZone in schoolZones)
    {
        NSArray *polylines = [self drawSchoolZone:schoolZone
                                            onMap:map];
        [tmp addObject:polylines];
    }
    self.schoolZones = tmp;
}

- (NSArray*)drawSchoolZone:(NSArray*)schoolZone
                     onMap:(GMSMapView*)map
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (NSArray *segment in schoolZone)
    {
        GMSPath *path = [self pathFromSegment:segment];

        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth  = self.defaultStrokeWidth;
        polyline.spans        = @[[GMSStyleSpan spanWithStyle:self.defaultStrokeStyle]];
        polyline.map          = map;
        
        [tmp addObject:polyline];
    }
    return tmp;
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

- (void)removeSchoolZonesOnMap:(GMSMapView*)map
{
    for (NSArray *schoolZone in self.schoolZones)
    {
        for (GMSPolyline * polyline in schoolZone)
        {
            polyline.map = nil;
        }
    }
}

@end
