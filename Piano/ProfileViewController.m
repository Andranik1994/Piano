//
//  ProfileViewController.m
//  Piano
//
//  Created by Andranik on 3/31/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "ProfileViewController.h"
@import Firebase;
@import GoogleSignIn;

@interface ProfileViewController ()

@property (strong ,nonatomic) UIImageView *profileImageView;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@",currentUser.photoURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *profileImage = [[UIImage alloc] initWithData:data];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame: CGRectMake (self.view.frame.size.height/15,
                                                                            self.view.frame.size.width/15,
                                                                            60,
                                                                            60)];
    self.profileImageView.backgroundColor = [UIColor redColor];
    self.profileImageView.image = profileImage;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = YES;
    [self.view addSubview:self.profileImageView];
    

    
    
    UIFont * customFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.height/15 + 60 + self.view.frame.size.height/15,  self.view.frame.size.width/15, 500, 50)];
    fromLabel.text = currentUser.displayName;
    fromLabel.font = customFont;
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;     fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:fromLabel];
    
    //OwnSongsButton
    CGRect frameimg = CGRectMake(self.view.frame.size.width/10, self.view.frame.size.height/2, self.view.frame.size.width*2/10 , 30);
    UIButton *ownSongsButton = [[UIButton alloc] initWithFrame:frameimg];
    [ownSongsButton setBackgroundColor:[UIColor redColor]];
    [ownSongsButton addTarget:self action:@selector(goToOwnSongsTableView)
         forControlEvents:UIControlEventTouchUpInside];
    [ownSongsButton setTitle:@"Own Songs" forState:UIControlStateNormal];

    [self.view addSubview:ownSongsButton];
    //SearchSongsButton
    frameimg = CGRectMake(self.view.frame.size.width*4/10, self.view.frame.size.height/2, self.view.frame.size.width*2/10 , 30);
    UIButton *searchSongsButton = [[UIButton alloc] initWithFrame:frameimg];
    [searchSongsButton setBackgroundColor:[UIColor redColor]];
    [searchSongsButton addTarget:self action:@selector(goToSearchSongs)
             forControlEvents:UIControlEventTouchUpInside];
     [searchSongsButton setTitle:@"Search" forState:UIControlStateNormal];
    
    [self.view addSubview:searchSongsButton];
    
}

- (void)goToOwnSongsTableView{
    UITableViewController *TVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ownSongsTableViewController"];
    [self.navigationController pushViewController:TVC animated:YES];
}

- (void)goToSearchSongs{
    NSLog(@"Search !!!");
}
@end
