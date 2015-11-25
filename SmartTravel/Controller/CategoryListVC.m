//
//  CategoryListVC.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "CategoryListVC.h"
#import "DBManager.h"
#import "UIColor+ST.h"
#import "HotspotListVC.h"
#import "STConstants.h"
#import "CategoryTableViewCell.h"
#import "AppSettingManager.h"
#import "HotSpotTableViewCell.h"
#import "DBSchoolAdapter.h"

static const NSInteger kSectionCnt = 2;
static NSString * kCategoryCellIdentifier = @"CategoryTableViewCellId";
static NSString * kSchoolCellIdentifier = @"HotSpotTableViewCellId";

@interface CategoryListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *schools;

@property (nonatomic, assign) MenuEnum menu;

@end

@implementation CategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.placeholderView.backgroundColor = [UIColor getSTGray];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"        <";
    backButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    self.menu = [AppSettingManager sharedInstance].menu;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HotSpotTableViewCell" bundle:nil] forCellReuseIdentifier:kSchoolCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:kCategoryCellIdentifier];

    // Get all schools
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
    self.schools = hotspots;

    // Get all categories
    self.categories = [[DBManager sharedInstance] selectCategories];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willRightRevealToggle:)
                                                 name:@"WillRightRevealToggle" object:nil];
}

- (void)willRightRevealToggle:(id)sender
{
    if (self.menu != [AppSettingManager sharedInstance].menu)
    {
        self.menu = [AppSettingManager sharedInstance].menu;
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:NO];
    }
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

#pragma mark - <UITableViewDataSource> methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSectionCnt;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        if (self.menu == MenuSchoolZones)
        {
            return self.schools.count;
        }
        else if (self.menu == MenuHighCollisionLocations)
        {
            return self.categories.count;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString* kHeadCellIdentifier = @"Section0CellID";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kHeadCellIdentifier];
        {
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:kHeadCellIdentifier];
                cell.backgroundColor = [UIColor getSTGray];
            }
            NSString *text = nil;
            if (self.menu == MenuHighCollisionLocations)
            {
                text = @"High-Collision Locations";
            }
            else if (self.menu == MenuSchoolZones)
            {
                text = @"Schools";
            }
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
            [attrStr addAttributes:@{
                                     NSFontAttributeName  : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName  : [UIColor whiteColor]
                                     }
                             range:[text rangeOfString:text]];
            cell.textLabel.attributedText = attrStr;
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (self.menu == MenuHighCollisionLocations)
        {
            CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellIdentifier];
            
            NSString *category = [self.categories objectAtIndex:indexPath.row];
            [cell configureWithCategory:category];
            return cell;
        }
        else if (self.menu == MenuSchoolZones)
        {
            HotSpotTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSchoolCellIdentifier];
            
            HotSpot* hotSpot = [self.schools objectAtIndex:indexPath.row];
            [cell configureCellWithLocation:hotSpot.location
                                   andCount:hotSpot.count
                                     ofType:hotSpot.type];
            return cell;
        }
        return nil;

    }
    return nil;
}

#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    else if (indexPath.section == 1)
    {
        return 60.f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menu == MenuHighCollisionLocations)
    {
        HotspotListVC *hotspotListVC = [[HotspotListVC alloc] initWithNibName:@"HotspotListVC" bundle:nil];
        hotspotListVC.category = [self.categories objectAtIndex:indexPath.row];

        [self.navigationController pushViewController:hotspotListVC animated:YES];
    }
    else if (self.menu == MenuSchoolZones)
    {
        HotSpot* hotSpot = [self.schools objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificatonNameHotSpotSelected
                                                            object:nil
                                                          userInfo:@{@"HotSpot":hotSpot}];
    }
}

@end
