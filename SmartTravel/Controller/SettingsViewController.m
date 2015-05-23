//
//  SettingsViewController.m
//  SmartTravel
//
//  Created by Gongwei on 15/4/25.
//  Copyright (c) 2015年 Gongwei. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppSettingManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *voiceMessageSwitch;
@property (weak, nonatomic) IBOutlet UILabel *voiceMessageDescriptionLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.voiceMessageDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.voiceMessageDescriptionLabel.numberOfLines = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
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

@end
