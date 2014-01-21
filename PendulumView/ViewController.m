//
//  ViewController.m
//  PendulumView
//
//  Created by Tu You on 14-1-19.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "ViewController.h"
#import "PendulumView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIColor *ballColor = [UIColor colorWithRed:0.47 green:0.60 blue:0.89 alpha:1];
    PendulumView *pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ballColor];
    [self.view addSubview:pendulum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
