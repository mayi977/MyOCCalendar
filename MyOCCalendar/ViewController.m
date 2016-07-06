//
//  ViewController.m
//  MyOCCalendar
//
//  Created by Zilu.Ma on 16/7/6.
//  Copyright © 2016年 Zilu.Ma. All rights reserved.
//

#import "ViewController.h"
#import "CalendarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[[UIApplication sharedApplication] delegate] window].rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CalendarViewController alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
