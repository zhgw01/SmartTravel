//
//  WarningView.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/5/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WarningType) {
    CollisionWarningType,
    VRUWarningType,
    WarningTypeCnt
};

@interface WarningView : UIView

- (void)updateType:(WarningType)type
          location:(NSString*)location
              rank:(NSNumber*)rank
             count:(NSNumber*)count
          distance:(NSNumber*)distance;

@end
