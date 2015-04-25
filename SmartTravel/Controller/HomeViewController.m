//
//  HomeViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "HomeViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Zoom to Edmonton
    GMSCameraPosition* edmontonPosition = [GMSCameraPosition cameraWithLatitude:53.5501400 longitude:-113.4687100 zoom:8.0];
    self.mapView.camera = edmontonPosition;
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

@end
