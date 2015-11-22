//
//  InfoVC.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/11/23.
//  Copyright © 2015年 Gongwei. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backHomePressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)roadSafetyPressed:(id)sender
{
    static NSString *kURLStr = @"http://www.edmonton.ca/transportation/traffic-safety.aspx";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLStr]];
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
