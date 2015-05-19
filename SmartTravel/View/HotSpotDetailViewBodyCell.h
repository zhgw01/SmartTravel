//
//  HotSpotDetailViewBodyCell.h
//  SmartTravel
//
//  Created by chenpold on 5/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSpotDetailViewBodyCell : UITableViewCell

- (void)configureDirection:(NSString*)direction
                    reason:(NSString*)reason
                     total:(NSNumber*)total;

@end
