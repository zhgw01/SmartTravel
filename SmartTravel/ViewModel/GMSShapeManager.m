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
@property (nonatomic, strong) NSArray *polylines;

@end

@implementation GMSShapeManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.defaultStrokeWidth = 10.f;
        self.defaultStrokeStyle = [GMSStrokeStyle solidColor:[UIColor redColor]];
    }
    return self;
}

- (void)drawSegments:(NSArray*)segments
               onMap:(GMSMapView*)map
{
    NSMutableArray *polylines = [[NSMutableArray alloc] init];
    for (NSArray *segment in segments)
    {
        GMSPath *path = [self pathFromSegment:segment];

        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth  = self.defaultStrokeWidth;
        polyline.spans        = @[[GMSStyleSpan spanWithStyle:self.defaultStrokeStyle]];
        polyline.map          = map;
        
        [polylines addObject:polyline];
    }
    self.polylines = polylines;
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

- (void)removeAllSegmentsOnMap:(GMSMapView*)map
{
    for (GMSPolyline * polyline in self.polylines)
    {
        polyline.map = nil;
    }
}

@end
