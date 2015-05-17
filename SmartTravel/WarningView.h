//
//  WarningView.h
//  SmartTravel
//
//  Created by Pengyu Chen on 5/5/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningView : UIView

- (void)updateLocation:(NSString*)location
                  rank:(NSNumber*)rank
                 count:(NSNumber*)count
              distance:(NSNumber*)distance;

@end
