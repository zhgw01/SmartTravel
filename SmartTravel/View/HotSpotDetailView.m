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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *gripView;
@property (weak, nonatomic) IBOutlet UIView *gripBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@property (strong, nonatomic) NSArray* details;

@end

@implementation HotSpotDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reload:(NSArray*)details
{
    self.titleLabel.text = [details objectAtIndex:0];
    self.details = [details objectAtIndex:1];
    
    [self setNeedsDisplay];
    [self.detailsTableView reloadData];
}

- (void)awakeFromNib
{
    self.gripView.layer.cornerRadius = 4.0f;
    self.gripView.layer.masksToBounds = YES;
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    
    // Title label
    // Note: Don't use table's section header since it will be hidden when user scolls the cells, which PO doesn't like this default effect.
    self.titleLabel.text = @"Location";
    self.titleLabel.textColor = [UIColor colorWithRed:82.0/255 green:181.0/255 blue:219.0/255 alpha:1];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.details = [[NSArray alloc] init];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.details count] + 1;
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
        
        NSDictionary* detail = [self.details objectAtIndex:indexPath.row - 1];
        [cell configureDirection:[detail objectForKey:@"Travel_direction"]
                          reason:[detail objectForKey:@"Reason"]
                           total:[detail objectForKey:@"Total"]];
        
        return cell;
    }
    
    return nil;
}


#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 30.f;
    }
    return 52.f;
}

@end
