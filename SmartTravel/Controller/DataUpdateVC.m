//
//  DataUpdateVC.m
//  SmartTravel
//
//  Created by Pengyu Chen on 15/8/9.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "DataUpdateVC.h"
#import "ResourceManager.h"

@interface DataUpdateVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *updateDataLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@end

@implementation DataUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.indicatorView.hidden = NO;
    self.updateDataLabel.hidden = NO;
    self.stopButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.indicatorView startAnimating];
    
    dispatch_queue_t updateQueue = dispatch_queue_create("update_data", nil);
    dispatch_async(updateQueue, ^{
        [ResourceManager updateOnline];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            self.updateDataLabel.hidden = YES;
            self.stopButton.hidden = NO;
        });
    });
}

- (IBAction)stopDidPress:(id)sender
{
    exit(0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
