//
//  HotSpotListViewController.h
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotSpotListViewControllerMapDelegate <NSObject>

- (void)hotSpotTableViewCellDidSelectWithLatitude:(NSNumber*)latitude
                                     andLongitude:(NSNumber*)longitude;

@end

@interface HotSpotListViewController : UIViewController

@property (nonatomic, assign) id<HotSpotListViewControllerMapDelegate> mapDelegate;

@end
