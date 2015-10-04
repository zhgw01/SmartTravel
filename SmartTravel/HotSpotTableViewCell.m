//
//  HotSpotTableViewCell.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/3/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HotSpotTableViewCell.h"

@interface HotSpotTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *roadwayPortionLabel;

@end

@implementation HotSpotTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.countLabel.layer.cornerRadius = 6.f;
    self.countLabel.layer.masksToBounds = YES;
    
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIColor*)getColorForCount:(NSNumber*)count
{
    static NSInteger kPureRedCount = 100;
    static NSInteger kPureGreenCount = 0;
    
    // If count >= 100, use pure red; if count == 0, use pure green.
    // Other values will get a color combined with red and green
    NSInteger countVal = [count integerValue];
    if (countVal >= kPureRedCount)
    {
        countVal = kPureRedCount;
    }
    if (countVal <= kPureGreenCount)
    {
        countVal = kPureGreenCount;
    }
    
    CGFloat red = (countVal - kPureGreenCount) * 1.f / (kPureRedCount - kPureGreenCount);
    CGFloat green = (kPureRedCount - countVal) * 1.f / (kPureRedCount - kPureGreenCount);
    return [UIColor colorWithRed:red green:green blue:0.f alpha:1.f];
}

- (void)configureCellWithLocation:(NSString*)location
                         andCount:(NSNumber*)count
                           ofType:(HotSpotType)hotSpotType
{
    BOOL needsLayout = NO;
    
    // Update location label
    if (![self.locationLabel.text isEqualToString:location])
    {
        self.locationLabel.text = location;
        needsLayout = YES;
    }
    
    // Update count label
    NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.numberStyle = NSNumberFormatterNoStyle;
    NSString* countStr = [numberFormat stringFromNumber:count];
    if (![self.countLabel.text isEqualToString:countStr])
    {
        self.countLabel.text = countStr;
        self.countLabel.backgroundColor =[self getColorForCount:count];
        
        needsLayout = YES;
    }
    
    // Update roadwayPortionLabel
    NSString *hotSpotTypeStr = [HotSpot toString:hotSpotType];
    if (![self.roadwayPortionLabel.text isEqualToString:hotSpotTypeStr])
    {
        self.roadwayPortionLabel.text = hotSpotTypeStr;
        needsLayout = YES;
    }
    
    // Don't show hot spot type count
    if (hotSpotType == HotSpotTypeSchoolLocation)
    {
        self.countLabel.hidden = YES;
    }
    else
    {
        self.countLabel.hidden = NO;
    }

    if (needsLayout)
    {
        [self setNeedsLayout];
    }
}

@end
