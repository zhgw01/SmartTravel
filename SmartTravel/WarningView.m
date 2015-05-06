//
//  WarningView.m
//  SmartTravel
//
//  Created by Pengyu Chen on 5/5/15.
//  Copyright (c) 2015 Gongwei. All rights reserved.
//

#import "WarningView.h"

@interface WarningView ()

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *gripView;
@property (weak, nonatomic) IBOutlet UIView *gripBackgroundView;

@end

@implementation WarningView

- (instancetype)initWithFrame:(CGRect)frame
{
    [[NSBundle mainBundle] loadNibNamed:@"WarningView" owner:self options:nil];
    // Set the view equal width and 1/3 height with parent
    CGRect myFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * 0.35);
    if (self = [super initWithFrame:myFrame])
    {
        [self addSubview:self.view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.view.frame = self.frame;
    
    self.gripView.layer.cornerRadius = 4.0f;
    self.gripView.layer.masksToBounds = YES;
}

- (void)didMoveToSuperview
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.gripBackgroundView addGestureRecognizer:panRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translatePoint = [recognizer translationInView:self.gripBackgroundView];
    // Do not dismiss this view if the pan distance is too small
    if (translatePoint.y < -5)
    {
        [self removeFromSuperview];
    }
}

@end
