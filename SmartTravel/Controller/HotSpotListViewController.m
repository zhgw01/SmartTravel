//
//  HotSpotListViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "HotSpotListViewController.h"
#import "DBManager.h"
#import "HotSpotTableViewCell.h"
#import "HotSpot.h"

@interface HotSpotListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *intersectionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *midStreetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *midAvenueCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolZoneCountLabel;

//@property (weak, nonatomic) IBOutlet UILabel *vruLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* intersections;
@property (nonatomic, strong) NSArray* midStreets;
@property (nonatomic, strong) NSArray* midAvenues;
@property (nonatomic, strong) NSArray* schoolZones;

@property (nonatomic, assign) HotSpotType type;

@property (nonatomic, strong) UIColor* selectionViewColor;
@property (nonatomic, strong) UIColor* unSelectionViewColor;

@property (weak, nonatomic) IBOutlet UIView *intersectionIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *midStreetIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *midAvenueIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *schoolZoneIndicatorView;

@end

@implementation HotSpotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set default hotspot type
    self.type = HotSpotTypeIntersection;

    // Set colors
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.selectionViewColor= [UIColor colorWithRed:0.3 green:0.64 blue:0.76 alpha:1];
    self.unSelectionViewColor= [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    
    [self setupModel];
    self.intersectionCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.intersections.count];
    self.midStreetCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.midStreets.count];
    self.midAvenueCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.midAvenues.count];
    self.schoolZoneCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.schoolZones.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupModel
{
    DBManager* dbManager = [DBManager sharedInstance];
    self.intersections = [dbManager selectHotSpots:HotSpotTypeIntersection];
    self.midStreets = [dbManager selectHotSpots:HotSpotTypeMidStreet];
    self.midAvenues = [dbManager selectHotSpots:HotSpotTypeMidAvenue];
    self.schoolZones = [dbManager selectHotSpots:HotSpotTypeSchoolZone];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tabSelected:(HotSpotType)hotSpotType
{
    self.intersectionIndicatorView.backgroundColor = self.unSelectionViewColor;
    self.midStreetIndicatorView.backgroundColor = self.unSelectionViewColor;
    self.midAvenueIndicatorView.backgroundColor = self.unSelectionViewColor;
    self.schoolZoneIndicatorView.backgroundColor = self.unSelectionViewColor;
    
    if (hotSpotType == HotSpotTypeIntersection)
    {
        self.intersectionIndicatorView.backgroundColor = self.selectionViewColor;
    }
    else if (hotSpotType == HotSpotTypeMidStreet)
    {
        self.midStreetIndicatorView.backgroundColor = self.selectionViewColor;
    }
    else if (hotSpotType == HotSpotTypeMidAvenue)
    {
        self.midAvenueIndicatorView.backgroundColor = self.selectionViewColor;
    }
    else if (hotSpotType == HotSpotTypeSchoolZone)
    {
        self.schoolZoneIndicatorView.backgroundColor = self.selectionViewColor;
    }
}

- (HotSpot*)getHotSpotOfType:(HotSpotType)hotSpotType
                       atRow:(NSInteger)row
{
    HotSpot* hotSpot = nil;
    if (self.type == HotSpotTypeIntersection)
    {
        hotSpot = [self.intersections objectAtIndex:row];
    }
    else if (self.type == HotSpotTypeMidStreet)
    {
        hotSpot = [self.midStreets objectAtIndex:row];
    }
    else if (self.type == HotSpotTypeMidAvenue)
    {
        hotSpot = [self.midAvenues objectAtIndex:row];
    }
    else if (self.type == HotSpotTypeSchoolZone)
    {
        hotSpot = [self.schoolZones objectAtIndex:row];
    }
    else
    {
        NSAssert(NO, @"Unsupported hot spot type");
    }
    return hotSpot;
}

#pragma mark - <UITableViewDataSource> methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == HotSpotTypeIntersection)
    {
        return [self.intersections count];
    }
    else if (self.type == HotSpotTypeMidStreet)
    {
        return [self.midStreets count];
    }
    else if (self.type == HotSpotTypeMidAvenue)
    {
        return [self.midAvenues count];
    }
    else if (self.type == HotSpotTypeSchoolZone)
    {
        return [self.schoolZones count];
    }
    return 0;
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
    
    HotSpot* hotSpot = [self getHotSpotOfType:self.type atRow:indexPath.row];
    
    [cell configureCellWithLocation:hotSpot.location andCount:hotSpot.count];
    
    return cell;
}

#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSpot* hotSpot = [self getHotSpotOfType:self.type atRow:indexPath.row];

    if ([self.mapDelegate respondsToSelector:@selector(hotSpotTableViewCellDidSelect:)])
    {
        [self.mapDelegate hotSpotTableViewCellDidSelect:hotSpot];
    }
}

#pragma mark - Button actions

- (IBAction)intersectionSelected:(id)sender
{
    if (self.type != HotSpotTypeIntersection)
    {
        self.type = HotSpotTypeIntersection;
        [self tabSelected:self.type];
        [self.tableView reloadData];
    }
}

- (IBAction)midStreetSelected:(id)sender
{
    if (self.type != HotSpotTypeMidStreet)
    {
        self.type = HotSpotTypeMidStreet;
        [self tabSelected:self.type];
        [self.tableView reloadData];
    }
}

- (IBAction)midAvenueSelected:(id)sender
{
    if (self.type != HotSpotTypeMidAvenue)
    {
        self.type = HotSpotTypeMidAvenue;
        [self tabSelected:self.type];
        [self.tableView reloadData];
    }
}

- (IBAction)schoolZoneSelected:(id)sender
{
    if (self.type != HotSpotTypeSchoolZone)
    {
        self.type = HotSpotTypeSchoolZone;
        [self tabSelected:self.type];
        [self.tableView reloadData];
    }
}
@end
