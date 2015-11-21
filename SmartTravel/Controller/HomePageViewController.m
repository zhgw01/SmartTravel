//
//  HomePageViewController.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/11/21.
//  Copyright © 2015年 Gongwei. All rights reserved.
//
#import "HotSpot.h"
#import "HomePageViewController.h"
#import "HomeViewController.h"

@interface HomePageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button11;
@property (weak, nonatomic) IBOutlet UIButton *button12;
@property (weak, nonatomic) IBOutlet UIButton *button21;
@property (weak, nonatomic) IBOutlet UIButton *button22;
@property (weak, nonatomic) IBOutlet UIButton *button31;
@property (weak, nonatomic) IBOutlet UIButton *button32;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Smart Travel";
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"homepage_background"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.button11.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button12.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button21.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button22.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button31.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button32.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"homepage_button11"])
    {
        HomeViewController *homeVC = [segue destinationViewController];
        homeVC.title = @"School Zones";
        homeVC.type = HotSpotTypeSchoolLocation;
    }
    else if([segue.identifier isEqualToString:@"homepage_button12"])
    {
        HomeViewController *homeVC = [segue destinationViewController];
        homeVC.title = @"High-Collision Locations"
        ;
        homeVC.type = HotSpotTypeAllExceptSchool;
    }
}

@end
