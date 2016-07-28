//
//  ViewController.m
//  GJSliderBar
//
//  Created by tongguan on 16/7/26.
//  Copyright © 2016年 MinorUncle. All rights reserved.
//

#import "ViewController.h"
#import "GJSliderBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(100, 100, 200, 50);
    GJSliderBar* slider = [[GJSliderBar alloc]initWithFrame:rect];
    slider.itemFont = [UIFont systemFontOfSize:20];
    slider.titleNames =  @[@"1-1",@"1-2",@"1-3",@"1-4234",@"1-5",@"1-6",@"1-762",@"1-8",@"1152346346-9",@"1-10",@"1-11"];
    
    [self.view addSubview:slider];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
