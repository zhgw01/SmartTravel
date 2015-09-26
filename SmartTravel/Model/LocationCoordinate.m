//
//  LocationCoordinate.m
//  SmartTravel
//
//  Created by chenpold on 9/19/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "LocationCoordinate.h"

@implementation LocationCoordinate

- (instancetype)initWithLatitude:(double)latitude
                    andLongitude:(double)longitude
{
    if (self = [super init])
    {
        self.latitude  = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LocationCoordinate *locationCoordinate = [[self class] allocWithZone:zone];
    locationCoordinate.latitude  = self.latitude;
    locationCoordinate.longitude = self.longitude;
    return locationCoordinate;
}

+ (NSArray*)parseSegmentsFromString:(NSString*)string
{
    NSError *error = nil;
    NSString *regStr = @"\\[([0-9\\., \\+-]+)\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (error)
    {
        return nil;
    }
    
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *textCheckingResult in [regex matchesInString:string
                                                                    options:NSMatchingReportCompletion
                                                                      range:NSMakeRange(0, string.length)])
    {
        NSString *matched = [string substringWithRange:textCheckingResult.range];
        NSArray *segment = [self parseSegmentFromString:matched];
        if (segment)
        {
            [segments addObject:segment];
        }
        else
        {
            NSLog(@"Error: %@ is not a valid segment.", matched);
        }
    }
    
    return segments;
}

+ (NSArray*)parseSegmentFromString:(NSString *)string
{
    NSMutableArray *segment = [[NSMutableArray alloc] init];
    NSArray *doubleStrArr = [[string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" []"]] componentsSeparatedByString:@","];
    for (NSUInteger idx = 0; idx < doubleStrArr.count; idx += 2)
    {
        NSString *longitudeStr = [doubleStrArr objectAtIndex:idx];
        NSString *latitudeStr = [doubleStrArr objectAtIndex:idx + 1];
        double longitude = [longitudeStr doubleValue];
        double latitude = [latitudeStr doubleValue];
        LocationCoordinate *lc = [[LocationCoordinate alloc] initWithLatitude:latitude andLongitude:longitude];
        [segment addObject:lc];
    }
    return segment;
}

@end
