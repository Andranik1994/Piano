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
    [super viewDidLoad];
    self.title = @"WELCOME";
    [GIDSignIn sharedInstance].uiDelegate = self;
    if ([FIRAuth auth].currentUser) {
        UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"pianoViewController"];
        [self.navigationController pushViewController:VC animated:NO];
    }
    
}
- (IBAction)pushGoogleSignIn:(id)sender {
    NSLog(@"In - RegestrationViewController 'pushGoogleSignIn'");
}

#pragma mark - Google SignIn Delegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"In - RegestrationViewController 'signInWillDispatch'");
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    
    [self presentViewController:viewController animated:YES completion:nil];
    NSLog(@"In - RegestrationViewController 'signIn presentViewController'");
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"pianoViewController"];
    [self.navigationController pushViewController:VC animated:NO];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"In - RegestrationViewController 'signIn dismissViewController'");
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    NSLog(@"In - RegestrationViewController 'signIn didSignInForUser:'");
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"pianoViewController"];
    [self.navigationController pushViewController:VC animated:NO];
}

@end
