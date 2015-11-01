//
//  HotspotListVC.m
//  SmartTravel
//
//  Created by chenpold on 8/30/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "HotspotListVC.h"
#import "UIColor+ST.h"
#import "DBManager.h"
#import "HotSpotTableViewCell.h"
#import "DBSchoolAdapter.h"

NSString * kNotificatonNameHotSpotSelected = @"kNotificatonNameHotSpotSelected";

@interface HotspotListVC ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@property (strong, nonatomic) NSArray *hotspots;

@end

@implementation HotspotListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    self.tableView.backgroundColor = [UIColor getSTGray];
    self.placeholderView.backgroundColor = [UIColor getSTGray];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    // Reason id -1 represents school locations
    if (self.reasonId == -1)
    {
        DBSchoolAdapter *dbSchoolAdapter = [[DBSchoolAdapter alloc] init];
        NSArray *allSchools = [dbSchoolAdapter selectAllSchoolsOrderByName];
        
        NSMutableArray *hotspots = [[NSMutableArray alloc] init];
        // Adapt all school format to hot spot format
        for (NSDictionary *school in allSchools)
        {
            NSString *schoolId              = [school valueForKey:kColId];
            NSString *schoolLocationName    = [school valueForKey:kColSchoolName];
            double schoolLatitude           = [[school objectForKey:kColLatitude] doubleValue];
            double schoolLongitude          = [[school objectForKey:kColLongitude] doubleValue];
            int schoolTotal                 = 1;

            HotSpot* hotSpot = [[HotSpot alloc] initWithLocCode:schoolId
                                                       location:schoolLocationName
                                                          count:schoolTotal
                                                       latitude:schoolLatitude
                                                     longtitude:schoolLongitude
                                                           type:HotSpotTypeSchoolLocation];

            [hotspots addObject:hotSpot];
        }
        self.hotspots = hotspots;
    }
    else
    {
        self.hotspots = [[DBManager sharedInstance] selectHotSpotsOfReason:self.reasonId];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotSpot* hotSpot = [self.hotspots objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificatonNameHotSpotSelected
                                                        object:nil
                                                      userInfo:@{@"HotSpot":hotSpot}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotspots.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* kCellIdentifier = @"HotSpotCell";
    static NSString* kCellNibName = @"HotSpotTableViewCell";
    
    HotSpotTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil] lastObject];
    }
    
    HotSpot* hotSpot = [self.hotspots objectAtIndex:indexPath.row];
    [cell configureCellWithLocation:hotSpot.location
                           andCount:hotSpot.count
                             ofType:hotSpot.type];
    
    return cell;
}

@end
