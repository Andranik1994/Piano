//
//  NonRotatingUIImagePickerController.m
//  Piano
//
//  Created by Andranik on 5/4/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "NonRotatingUIImagePickerController.h"

@interface NonRotatingUIImagePickerController ()

@end

@implementation NonRotatingUIImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// Disable Landscape mode.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}



@end
