//
//  HomeViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "HomeViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <SWRevealViewController/SWRevealViewController.h>

@interface HomeViewController ()<SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hotspotListButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupSideBarMenu];
    [self zoomToEdmonton];
}

- (void) zoomToEdmonton
{
    // Zoom to Edmonton
    GMSCameraPosition* edmontonPosition = [GMSCameraPosition cameraWithLatitude:53.5501400 longitude:-113.4687100 zoom:12.0];
    self.mapView.camera = edmontonPosition;
}

- (void) setupNavigationBar
{
    //setup navigation
    self.title = @"Smart Travel";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) setupSideBarMenu
{
    if (self.revealViewController != nil) {
        self.hotspotListButton.target = self.revealViewController;
        self.hotspotListButton.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        self.settingsButton.target = self.revealViewController;
        self.settingsButton.action = @selector(rightRevealToggle:);
        
        self.revealViewController.rearViewRevealWidth = 300;
        self.revealViewController.rightViewRevealWidth = 300;
        
        self.revealViewController.delegate = self;
    }
}


#pragma mark - SWRevealViewController Delegate
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position != FrontViewPositionLeft) {
        self.mapView.userInteractionEnabled = NO;
    }
    else {
        self.mapView.userInteractionEnabled = YES;
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

@end
