//
//  MarkerManagerFactory.h
//  SmartTravel
//
//  Created by Yuan Huimin on 15/9/27.
//  Copyright © 2015年 Gongwei. All rights reserved.
//

#import "MarkerManager.h"
#import "HotSpot.h"
#import <Foundation/Foundation.h>

@interface MarkerManagerFactory : NSObject

+ (MarkerManager*)createMarkerManager:(HotSpotType)type;

@end
