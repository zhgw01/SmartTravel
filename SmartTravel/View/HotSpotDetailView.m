//
//  HotSpotDetailView.m
//  SmartTravel
//
//  Created by chenpold on 5/18/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "HotSpotDetailView.h"
#import "HotSpotDetailViewHeaderCell.h"
#import "HotSpotDetailViewBodyCell.h"


@interface HotSpotDetailView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *gripView;
@property (weak, nonatomic) IBOutlet UIView *gripBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@end

@implementation HotSpotDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.gripView.layer.cornerRadius = 4.0f;
    self.gripView.layer.masksToBounds = YES;
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
}

- (void)didMoveToSuperview
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.gripBackgroundView addGestureRecognizer:panRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translatePoint = [recognizer translationInView:self.gripBackgroundView];
    // Do not hide this view if the pan distance is too small
    if (translatePoint.y > 5)
    {
        self.hidden = YES;
    }
}

#pragma mark - <UITableViewDataSource> methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 60)];
    label.text = @"Location";
    label.textColor = [UIColor colorWithRed:82.0/255 green:181.0/255 blue:219.0/255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kHeaderCellIdentifier = @"HotSpotDetailViewHeaderCell";
    static NSString* kHeaderCellNibName = @"HotSpotDetailViewHeaderCell";
    
    static NSString* kBodyCellIdentifier = @"HotSpotDetailViewBodyCell";
    static NSString* kBodyCellNibName = @"HotSpotDetailViewBodyCell";
    
    if (indexPath.row == 0)
    {
        HotSpotDetailViewHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:kHeaderCellNibName owner:self options:nil] lastObject];
        }
        
        return cell;
    }
    else
    {
        HotSpotDetailViewBodyCell* cell = [tableView dequeueReusableCellWithIdentifier:kBodyCellIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:kBodyCellNibName owner:self options:nil] lastObject];
        }
        
        return cell;
    }
    
    return nil;
}


#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
