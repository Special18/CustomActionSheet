//
//  ViewController.m
//  CustomActionSheet
//
//  Created by MrXir on 2017/6/23.
//  Copyright © 2017年 LJS. All rights reserved.
//

#import "ViewController.h"
#import "MRActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"123" forState:0];
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)didClickButton:(UIButton *)sender {
  
    
    MRActionSheet *actionSheet = [[MRActionSheet alloc] initWithTitle:@"123" buttonTitles:@[@"1", @"2", @"3"] specialButtonIndex:-1 clicked:^(NSInteger selectedIndex) {
        
        switch (selectedIndex) {
            case 0:
                NSLog(@"1");
                break;
            case 1:
                NSLog(@"2");
                break;
            case 2:
                NSLog(@"3");
                break;
                
            default:
                break;
        }
        
    }];
    
    [actionSheet show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
