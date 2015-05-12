//
//  HotSpotListViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "HotSpotListViewController.h"
#import "DBManager.h"
#import "Collision.h"
#import "VRU.h"
#import "HotSpotTableViewCell.h"
#import "HotSpot.h"

@interface HotSpotListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *collisionLabel;
@property (weak, nonatomic) IBOutlet UILabel *vruLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* collisions;
@property (nonatomic, strong) NSArray* vrus;

@property (nonatomic, assign) HotSpotType type;

@property (nonatomic, strong) UIColor* selectionViewColor;
@property (nonatomic, strong) UIColor* unSelectionViewColor;

@property (weak, nonatomic) IBOutlet UIView *collsionHotSpotIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *vruHotSpotIndicatorView;

@end

@implementation HotSpotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set colors
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.selectionViewColor= [UIColor colorWithRed:0.3 green:0.64 blue:0.76 alpha:1];
    self.unSelectionViewColor= [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    
    // Query all collsions and VRUs from database
    NSComparator hotSpotCmptr = ^NSComparisonResult(id obj1, id obj2)
    {
        HotSpot* hotSpot1 = (HotSpot*)obj1;
        HotSpot* hotSpot2 = (HotSpot*)obj2;
        return [hotSpot1.count compare:hotSpot2.count];
    };
    self.collisions = [[[DBManager sharedInstance] selectAllCollisions] sortedArrayUsingComparator:hotSpotCmptr];
    self.vrus = [[[DBManager sharedInstance] selectAllVRUs] sortedArrayUsingComparator:hotSpotCmptr];
    
    // and update count labels
    self.collisionLabel.text = [NSString stringWithFormat:@"%lu", self.collisions.count];
    self.vruLabel.text = [NSString stringWithFormat:@"%lu", self.vrus.count];
    
    // Default tab is collision
    self.type = HotSpotTypeCollision;
    self.collsionHotSpotIndicatorView.backgroundColor = self.selectionViewColor;
    self.vruHotSpotIndicatorView.backgroundColor = self.unSelectionViewColor;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)collisionButtonPressed:(id)sender
{
    if (self.type != HotSpotTypeCollision)
    {
        self.type = HotSpotTypeCollision;
        [self.tableView reloadData];
        
        self.collsionHotSpotIndicatorView.backgroundColor = self.selectionViewColor;
        self.vruHotSpotIndicatorView.backgroundColor = self.unSelectionViewColor;
    }
}

- (IBAction)vruButtonPressed:(id)sender
{
    if (self.type != HotSpotTypeVRU)
    {
        self.type = HotSpotTypeVRU;
        [self.tableView reloadData];
        
        self.collsionHotSpotIndicatorView.backgroundColor = self.unSelectionViewColor;
        self.vruHotSpotIndicatorView.backgroundColor = self.selectionViewColor;
    }
}

#pragma mark - <UITableViewDataSource> methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == HotSpotTypeCollision)
    {
        return [self.collisions count];
    }
    else if (self.type == HotSpotTypeVRU)
    {
        return [self.vrus count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCellIdentifier = @"HotSpotTableViewCell";
    static NSString* kCellNibName = @"HotSpotTableViewCell";
    
    HotSpotTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil] lastObject];
    }
    
    if (self.type == HotSpotTypeCollision)
    {
        HotSpot* hotSpot = [self.collisions objectAtIndex:indexPath.row];
        [cell configureType:hotSpot.tag location:hotSpot.location count:hotSpot.count];
    }
    else if (self.type == HotSpotTypeVRU)
    {
        HotSpot* hotSpot = [self.vrus objectAtIndex:indexPath.row];
        [cell configureType:hotSpot.tag location:hotSpot.location count:hotSpot.count];
    }
    else
    {
        NSAssert(NO, @"Unsupported hot spot type");
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSpot* hotSpot = nil;
    if (self.type == HotSpotTypeCollision)
    {
        hotSpot = [self.collisions objectAtIndex:indexPath.row];
    }
    else if (self.type == HotSpotTypeVRU)
    {
        hotSpot = [self.vrus objectAtIndex:indexPath.row];
    }
    else
    {
        NSAssert(NO, @"Unsupported hot spot type");
    }

    if ([self.mapDelegate respondsToSelector:@selector(hotSpotTableViewCellDidSelect:)])
    {
        [self.mapDelegate hotSpotTableViewCellDidSelect:hotSpot];
    }
}
@end
