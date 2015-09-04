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

@interface ReasonListVC ()

@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@property (nonatomic, strong) NSArray *reasons;

@end

@implementation ReasonListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.logoView.backgroundColor = [UIColor getSTGray];
    self.placeholderView.backgroundColor = [UIColor getSTGray];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    self.reasons = [[DBManager sharedInstance] selectAllReasonNames];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reasons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    NSString *reason = [[self.reasons objectAtIndex:indexPath.row] valueForKey:@"Reason"];
    cell.textLabel.text = reason;
    
    return cell;
}

#pragma mark - <UITableViewDelegate> methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotspotListVC *hotspotListVC = [[HotspotListVC alloc] initWithNibName:@"HotspotListVC" bundle:nil];
    hotspotListVC.reasonId = [[self.reasons objectAtIndex:indexPath.row] valueForKey:@"Reason_id"];

    [self.navigationController pushViewController:hotspotListVC animated:YES];
}

@end
