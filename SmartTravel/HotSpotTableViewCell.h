//
//  HotSpotTableViewCell.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/3/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSpot.h"

@interface HotSpotTableViewCell : UITableViewCell

- (void)configureCellWithLocation:(NSString*)location
                         andCount:(NSNumber*)count
                           ofType:(HotSpotType)hotSpotType;

@end
