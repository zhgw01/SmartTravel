//
//  HotSpotDetailView.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSpot.h"

@interface HotSpotDetailView : UIView

/**
 *  After user click the cell, should send message to HotSpotDetailView by this method to update view.
 *
 *  @param type if it's NOT HotSpotTypeSchoolZone, data looks like:
    {
        @"name" :
        @"details" {
            [
                @"Travel_direction":
                @"Reason":
                @"Total":
            ],
            [
                @"Travel_direction":
                @"Reason":
                @"Total":
            ],
            ...
        }
    },
    else if it's HotSpotTypeSchoolZone, details are nil;
 
 *  @param data see above description
 */
- (void)configWithType:(HotSpotType)type
               andData:(id)data;

@end
