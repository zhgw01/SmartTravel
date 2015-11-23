//
//  AboutVC.m
//  SmartTravel
//
//  Created by Yuan Huimin on 15/11/22.
//  Copyright © 2015年 Gongwei. All rights reserved.
//

#import "AboutVC.h"
#import "DBVersionAdapter.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet UIButton *button11;
@property (weak, nonatomic) IBOutlet UIButton *button12;
@property (weak, nonatomic) IBOutlet UIButton *button21;
@property (weak, nonatomic) IBOutlet UIButton *button22;
@property (weak, nonatomic) IBOutlet UILabel *updateDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionValueLabel;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.button11.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button12.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button21.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.button22.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"homepage_background"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    NSString *currentVersion = [[[DBVersionAdapter alloc] init] getLatestVersion];
    self.updateDateValueLabel.text = currentVersion;
    
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleShortVersionString = [bundleDic objectForKey:@"CFBundleShortVersionString"];
#ifdef DEBUG
    self.versionValueLabel.text = [NSString stringWithFormat:@"%@ %@", bundleShortVersionString, @"test"];
#else
    self.versionValueLabel.text = bundleShortVersionString;
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)anyButtonPressed:(id)sender
{
    static NSString *urlStr = @"http://www.edmonton.ca/transportation/traffic-safety.aspx";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (IBAction)backHomePressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
