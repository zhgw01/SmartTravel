//
//  HotSpotDetailView.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSpotDetailView : UIView

/**
 *  After user click the cell, should send message to HotSpotDetailView by this method to update view.
 *
 *  @param detailsOfLocationName 1st element is location name, 2nd element is details.
 */
- (void)reload:(NSArray*)detailsOfLocationName;

@end
