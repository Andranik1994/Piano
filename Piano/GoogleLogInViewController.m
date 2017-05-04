//
//  RegestrationViewController.m
//  Piano
//
//  Created by Andranik on 3/27/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "GoogleLogInViewController.h"


@interface GoogleLogInViewController ()

@property(weak, nonatomic) IBOutlet GIDSignInButton *googleButton;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation GoogleLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"WELCOME";
    [GIDSignIn sharedInstance].uiDelegate = self;
    if ([FIRAuth auth].currentUser) {
        NSLog(@"In - GoogleLogInViewController 'viewDidLoad IF'");
        UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"pianoViewController"];
        [self.navigationController pushViewController:VC animated:NO];
    }
}
- (IBAction)pushGoogleSignIn:(id)sender {
    NSLog(@"In - GoogleLogInViewController 'pushGoogleSignIn'");
}

#pragma mark - Google SignIn Delegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"In - GoogleLogInViewController 'signInWillDispatch'");
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    
    [self presentViewController:viewController animated:YES completion:nil];
    NSLog(@"In - GoogleLogInViewController 'signIn presentViewController'");
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"pianoViewController"];
    [self.navigationController pushViewController:VC animated:NO];
       
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"In - GoogleLogInViewController 'signIn dismissViewController'");
}



@end
