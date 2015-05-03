//
//  HotSpotListViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "HotSpotListViewController.h"
#import "AppDelegate.h"
#import "Collision.h"
#import "VRU.h"
#import "HotSpotTableViewCell.h"

static NSString * const kCollisionsQuerySmt = @"select * from Collision";
static NSString * const kVRUsQuerySmt = @"select * from VRU";

typedef enum : NSUInteger {
    HotSpotTypeCollision,
    HotSpotTypeVRU,
    HotSpotTypeNumber
} HotSpotType;

@interface HotSpotListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *collisionLabel;
@property (weak, nonatomic) IBOutlet UILabel *vruLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* collisions;
@property (nonatomic, strong) NSMutableArray* vrus;

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
    
    self.collisions = [[NSMutableArray alloc] init];
    self.vrus = [[NSMutableArray alloc] init];
    
    // Query all collsions and VRUs from database
    // and update count labels
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSUInteger collisionCount = [self getCollisions:appDelegate];
    self.collisionLabel.text = [NSString stringWithFormat:@"%lu", collisionCount];
    
    NSUInteger vruCount = [self getVRUs:appDelegate];
    self.vruLabel.text = [NSString stringWithFormat:@"%lu", vruCount];
    
    // Default tab is collision
    self.type = HotSpotTypeCollision;
    self.collsionHotSpotIndicatorView.backgroundColor = self.selectionViewColor;
    self.vruHotSpotIndicatorView.backgroundColor = self.unSelectionViewColor;
}

- (NSUInteger)getCollisions:(AppDelegate*)appDelegate
{
    FMResultSet *resultSet = [appDelegate.database executeQuery:kCollisionsQuerySmt];
    NSError *error = nil;
    while ([resultSet next])
    {
        Collision *collision = [MTLFMDBAdapter modelOfClass:Collision.class fromFMResultSet:resultSet error:&error];
        NSAssert(collision, @"Collsion should be non nil");
        [self.collisions addObject:collision];
    }
    
    return [self.collisions count];
}

- (NSUInteger)getVRUs:(AppDelegate*)appDelegate
{
    FMResultSet *resultSet = [appDelegate.database executeQuery:kVRUsQuerySmt];
    NSError *error = nil;
    while ([resultSet next])
    {
        VRU *vru = [MTLFMDBAdapter modelOfClass:VRU.class fromFMResultSet:resultSet error:&error];
        NSAssert(vru, @"VRU should be non nil");
        [self.vrus addObject:vru];
    }
    
    return [self.vrus count];
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
        Collision* collision = [self.collisions objectAtIndex:indexPath.row];
        [cell configureType:nil location:collision.location count:collision.count];
    }
    else if (self.type == HotSpotTypeVRU)
    {
        VRU* vru = [self.vrus objectAtIndex:indexPath.row];
        NSString* typeStr =  [[vru.portion componentsSeparatedByString:@"-"] lastObject];
        [cell configureType:typeStr location:vru.location count:vru.count];
    }
    else
    {
        NSAssert(NO, @"Error: Unsupported hot spot type");
        return nil;
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
    // TODO: Implement
    // Show the location in map
}
@end
