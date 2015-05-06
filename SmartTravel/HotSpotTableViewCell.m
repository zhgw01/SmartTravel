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

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation HotSpotTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.countLabel.layer.cornerRadius = 4.f;
    self.countLabel.layer.masksToBounds = YES;
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

- (void)configureType:(NSString*)type
             location:(NSString*)location
                count:(NSNumber*)count
{
    BOOL needsLayout = NO;
    
    // Update type label
    if (![self.typeLabel.text isEqualToString:type])
    {
        self.typeLabel.text = type;
        needsLayout = YES;
    }
    
    // Update location label
    if (![self.locationLabel.text isEqualToString:location])
    {
        self.locationLabel.text = location;
        needsLayout = YES;
    }
    
    // Update label
    NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.numberStyle = NSNumberFormatterNoStyle;
    NSString* countStr = [numberFormat stringFromNumber:count];
    if (![self.countLabel.text isEqualToString:countStr])
    {
        self.countLabel.text = countStr;
        self.countLabel.backgroundColor =[self getColorForCount:count];
        
        needsLayout = YES;
    }
    
    if (needsLayout)
    {
        [self setNeedsLayout];
    }
}

@end
