//
//  WarningView.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/5/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "WarningView.h"

@interface WarningView ()

@property (weak, nonatomic) IBOutlet UIView *gripView;
@property (weak, nonatomic) IBOutlet UIView *gripBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (assign, nonatomic) WarningType type;

@end

@implementation WarningView

- (void)awakeFromNib
{
    self.gripView.layer.cornerRadius = 4.0f;
    self.gripView.layer.masksToBounds = YES;
    self.type = WarningTypeCnt;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)didMoveToSuperview
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.gripBackgroundView addGestureRecognizer:panRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translatePoint = [recognizer translationInView:self.gripBackgroundView];
    // Do not hide this view if the pan distance is too small
    if (translatePoint.y < -5)
    {
        self.hidden = YES;
    }
}

- (NSString*)getTypeString:(WarningType)type
{
    switch (type) {
        case CollisionWarningType:
            return @"Car/Bus";
            break;
        case VRUWarningType:
            return @"Bicyle/Pedestrian";
        case WarningTypeCnt:
            return nil;
        default:
            break;
    }
}

- (UIColor*)getTypeColor:(WarningType)type
{
    switch (type) {
        case CollisionWarningType:
            return [UIColor redColor];
            break;
        case VRUWarningType:
            return [UIColor orangeColor];
        case WarningTypeCnt:
            return nil;
        default:
            break;
    }
}

- (void)updateType:(WarningType)type
          location:(NSString*)location
              rank:(NSNumber*)rank
             count:(NSNumber*)count
          distance:(NSNumber*)distance
{
    BOOL needsDisplay = NO;
    
    if (type != self.type)
    {
        self.type = type;
        UIColor* typeColor = [self getTypeColor:type];
        self.typeLabel.textColor = typeColor;
        self.typeLabel.text = [self getTypeString:type];
        
        self.distanceLabel.textColor = typeColor;
        self.unitLabel.textColor = typeColor;
        needsDisplay = YES;
    }
    
    if (![location isEqualToString:self.locationLabel.text])
    {
        self.locationLabel.text = location;
        needsDisplay = YES;
    }
    
    NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.numberStyle = NSNumberFormatterNoStyle;
    
    NSString* rankStr = [numberFormat stringFromNumber:rank];
    if (![rankStr isEqualToString:self.rankLabel.text])
    {
        self.rankLabel.text = rankStr;
        needsDisplay = YES;
    }
    
    NSString* countStr = [numberFormat stringFromNumber:count];
    if (![countStr isEqualToString:self.countLabel.text])
    {
        self.countLabel.text = countStr;
        needsDisplay = YES;
    }
    
    NSString* distanceStr = [numberFormat stringFromNumber:distance];
    if (![distanceStr isEqualToString:self.distanceLabel.text])
    {
        self.distanceLabel.text = distanceStr;
        needsDisplay = YES;
    }
    
    if (needsDisplay)
    {
        [self setNeedsDisplay];
    }
}

@end
