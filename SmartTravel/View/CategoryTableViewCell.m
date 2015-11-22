//
//  CategoryTableViewCell.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/11/21.
//  Copyright © 2015年 Gongwei. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "UIColor+ST.h"
#import "STConstants.h"
#import "DBManager.h"

@interface CategoryTableViewCell ()

@property (nonatomic, copy) NSString *category;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor getSTGray];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithCategory:(NSString*)category
{
    if ([category isEqualToString:self.category])
    {
        return;
    }
    
    // TODO:
    self.icon.image = [self getImageOfCategory:category];
    self.nameLabel.text = category;
    self.countLabel.text = [NSString stringWithFormat:@"%d",
                            [self getTotalCollisionCountOfCategory:category]];
    
    [self setNeedsDisplay];
}

- (int)getTotalCollisionCountOfCategory:(NSString*)category
{
    int total = 0;
    NSArray *hotspots = [[DBManager sharedInstance] selectHotSpotsOfCategory:category];
    for (HotSpot *hotspot in hotspots)
    {
        total += [[hotspot count] intValue];
    }
    return total;
}

- (UIImage*)getImageOfCategory:(NSString*)category
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kConstantPlist
                                                          ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *reasonCategoryDic = [data valueForKey:kConstantPlistKeyOfReasonCategory];
    
    NSDictionary *categoryInfo = [reasonCategoryDic objectForKey:category];
    NSString *imageName = [categoryInfo valueForKey:@"icon"];
    return [UIImage imageNamed:imageName];
}

@end
