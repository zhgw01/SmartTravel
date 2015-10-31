//
//  SettingsViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppSettingManager.h"
#import "DBVersionAdapter.h"
#import "ResourceManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *voiceMessageSwitch;
@property (weak, nonatomic) IBOutlet UILabel *voiceMessageDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *autoCheckUpdateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoCheckUpdateSwitch;

@property (weak, nonatomic) IBOutlet UILabel *dateUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.voiceMessageDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.voiceMessageDescriptionLabel.numberOfLines = 0;
    
    self.autoCheckUpdateSwitch.on = [[AppSettingManager sharedInstance] getIsAutoCheckUpdate];
    
    NSString *currentVersion = [[[DBVersionAdapter alloc] init] getLatestVersion];
    self.dateUpdateLabel.text = currentVersion;
    
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleShortVersionString = [bundleDic objectForKey:@"CFBundleShortVersionString"];
#ifdef DEBUG
    self.versionLabel.text = [NSString stringWithFormat:@"%@ %@", bundleShortVersionString, @"test"];
#else
    self.versionLabel.text = bundleShortVersionString;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(versionHasBeenUpdated:)
                                                 name:kNotificationNameVersionHasBeenUpdated
                                               object:nil];
}

- (void)versionHasBeenUpdated:(NSDictionary*)data
{
    if (data)
    {
        NSDictionary *userInfo = [data valueForKey:@"userInfo"];
        if (userInfo)
        {
            self.dateUpdateLabel.text = [userInfo valueForKey:@"version"];
            [self.view setNeedsDisplay];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.voiceMessageSwitch.on = [[AppSettingManager sharedInstance] getIsWarningVoice];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)voiceMessageSwitchToggled:(id)sender
{
    UISwitch* swt = (UISwitch*)sender;
    [[AppSettingManager sharedInstance] setIsWarningVoice:swt.on];
}

- (IBAction)autoCheckUpdateSwitchToggled:(id)sender
{
    UISwitch* swt = (UISwitch*)sender;
    [[AppSettingManager sharedInstance] setIsAutoCheckUpdate:swt.on];
}

@end
