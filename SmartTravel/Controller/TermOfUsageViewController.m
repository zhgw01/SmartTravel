//
//  TermOfUsageViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/16.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "TermOfUsageViewController.h"
#import "TermUsage.h"
#import "GuideViewController.h"

#define SHOW_GUIDEVIEW_SEGUE @"ShowGuideViewController"

@interface TermOfUsageViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermOfUsageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [self loadTermOfUsage];
}

- (void)loadTermOfUsage
{
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"termofusage" ofType:@"html"];
    NSString *htmlData = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:htmlData baseURL:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: SHOW_GUIDEVIEW_SEGUE]) {
        [TermUsage setAgree:YES];
    }
    
}

@end
