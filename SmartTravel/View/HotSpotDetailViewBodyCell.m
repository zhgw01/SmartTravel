//
//  HotSpotDetailViewBodyCell.m
//  SmartTravel
//
//  Created by chenpold on 5/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "HotSpotDetailViewBodyCell.h"

@interface HotSpotDetailViewBodyCell()
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation HotSpotDetailViewBodyCell

- (void)awakeFromNib {
    // Initialization code
    
    self.reasonLabel.textAlignment = NSTextAlignmentLeft;
    self.reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.reasonLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureDirection:(NSString*)direction
                    reason:(NSString*)reason
                     total:(NSNumber*)total
{
    BOOL needRedraw = NO;
    
    if (![direction isEqualToString:self.directionLabel.text])
    {
        self.directionLabel.text = direction;
        needRedraw = YES;
    }
    
    if (![reason isEqualToString:self.reasonLabel.text])
    {
        self.reasonLabel.text = reason;
        needRedraw = YES;
    }
    
    NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.numberStyle = NSNumberFormatterNoStyle;
    NSString* totalStr = [numberFormat stringFromNumber:total];
    if (![totalStr isEqualToString:self.totalLabel.text])
    {
        self.totalLabel.text = totalStr;
        needRedraw = YES;
    }
    
    if (needRedraw)
    {
        [self setNeedsDisplay];
    }
}

@end
