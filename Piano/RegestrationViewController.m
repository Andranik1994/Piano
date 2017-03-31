//
//  RegestrationViewController.m
//  Piano
//
//  Created by Andranik on 3/27/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "RegestrationViewController.h"


@interface RegestrationViewController () 

@property(weak, nonatomic) IBOutlet GIDSignInButton *googleButton;

@end

@implementation RegestrationViewController

- (void)viewDidLoad {
    
    [GIDSignIn sharedInstance].uiDelegate = self;

    if ([FIRAuth auth].currentUser) {
        UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"pianoViewController"];
        [self.navigationController pushViewController:VC animated:NO];
    } else {
        [super viewDidLoad];
        
//        [GIDSignIn sharedInstance].uiDelegate = self;
//        [[GIDSignIn sharedInstance] signIn];
//        self.googleButton.style = kGIDSignInButtonStyleStandard;
        self.title = @"WELCOME";
        
    }
    
    
}
- (IBAction)pushGoogleButon:(id)sender {
   

    
}




@end
