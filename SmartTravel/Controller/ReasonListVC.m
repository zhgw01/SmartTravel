//
//  ReasonListVC.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "ReasonListVC.h"
#import "DBManager.h"
#import "UIColor+ST.h"
#import "HotspotListVC.h"

static const NSInteger kSectionCnt = 2;

@interface ReasonListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@property (nonatomic, strong) NSArray *reasons;

@end

@implementation ReasonListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.placeholderView.backgroundColor = [UIColor getSTGray];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    self.reasons = [[DBManager sharedInstance] selectReasonCategories];
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
        return self.reasons.count;
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
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"High-Collision Locations"];
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
        static NSString* kCellIdentifier = @"ReasonCell";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kCellIdentifier];
            cell.backgroundColor = [UIColor getSTGray];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        
        // Configure Cell
        NSString *category = [[self.reasons objectAtIndex:indexPath.row] valueForKey:@"Category"];
        cell.textLabel.text = category;
        
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
    hotspotListVC.reasonId = [[[self.reasons objectAtIndex:indexPath.row] objectForKey:@"Reason_id"] intValue];

    [self.navigationController pushViewController:hotspotListVC animated:YES];
}

@end
