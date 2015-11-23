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

static const NSInteger kSectionCnt = 2;
static NSString * kCategoryCellIdentifier = @"CategoryTableViewCell";

@interface CategoryListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (nonatomic, strong) NSArray *categories;

@end

@implementation CategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.placeholderView.backgroundColor = [UIColor getSTGray];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:kCategoryCellIdentifier];
    
    self.categories = [self orderCategories:[[DBManager sharedInstance] selectCategories]];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"        <";
    backButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (NSArray*)orderCategories:(NSArray*)categories
{
    // Get reason category order list
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kConstantPlist
                                                          ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *reasonCategoryDic = [data valueForKey:kConstantPlistKeyOfReasonCategory];
    
    NSUInteger totalCount = reasonCategoryDic.count;
    NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:totalCount];
    for (NSUInteger idx = 0; idx < totalCount; ++idx)
    {
        [res addObject:@"Unknown category"];
    }

    // Insert the reason category at the told index
    for(NSString *category in categories)
    {
        NSInteger order = [[[reasonCategoryDic objectForKey:category] valueForKey:@"order"] integerValue];
        if (order >= 0 && order < totalCount)
        {
            [res setObject:category atIndexedSubscript:order];
        }
    }
    
    return res;
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
        return self.categories.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString* kHeadCellIdentifier = @"ReasonListHeadCell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kHeadCellIdentifier];
        {
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:kHeadCellIdentifier];
                cell.backgroundColor = [UIColor getSTGray];
                
                NSString *text = @"High-Collision Locations";
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
                [attrStr addAttributes:@{
                                         NSFontAttributeName  : [UIFont systemFontOfSize:16],
                                         NSForegroundColorAttributeName  : [UIColor whiteColor]
                                         }
                                 range:[text rangeOfString:text]];
                cell.textLabel.attributedText = attrStr;
            }
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {        
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellIdentifier];
        
        NSString *category = [self.categories objectAtIndex:indexPath.row];
        [cell configureWithCategory:category];
        return cell;
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
    HotspotListVC *hotspotListVC = [[HotspotListVC alloc] initWithNibName:@"HotspotListVC" bundle:nil];
    hotspotListVC.category = [self.categories objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:hotspotListVC animated:YES];
}

@end