//
//  GuideViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/19.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)onTap:(id)sender {
    [self onExit];
}

- (void)onExit {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* rootController = [storyboard instantiateInitialViewController];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rootController;

}

@end
