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
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@end

@implementation WarningView

- (void)awakeFromNib
{
    self.gripView.layer.cornerRadius = 4.0f;
    self.gripView.layer.masksToBounds = YES;
    
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.reasonLabel.textAlignment = NSTextAlignmentLeft;
    self.reasonLabel.numberOfLines = 0;
    self.reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
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

- (void)updateLocation:(NSString*)location
                reason:(NSString*)reason
              distance:(NSNumber*)distance
{
    BOOL needsDisplay = NO;

    if (![location isEqualToString:self.locationLabel.text])
    {
        self.locationLabel.text = location;
        needsDisplay = YES;
    }
    
    if (![reason isEqualToString:self.reasonLabel.text])
    {
        self.reasonLabel.text = reason;
        needsDisplay = YES;
    }
    
    NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.numberStyle = NSNumberFormatterNoStyle;
    
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
