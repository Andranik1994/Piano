//
//  ProfileViewController.m
//  Piano
//
//  Created by Andranik on 3/31/17.
//  Copyright © 2017 Andranik. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
#import "ProfileViewController.h"
@import Firebase;
@import GoogleSignIn;

@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong ,nonatomic) UIImageView *profileImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UITableView *mySongsTableView;
@property (strong, nonatomic) UITableView *searchTableView;

@property (strong ,nonatomic) NSMutableDictionary *songsDictionary;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic , strong) NSNumber *number;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (strong ,nonatomic) NSString *currentSong;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentControl.selectedSegmentIndex = 0;
    [self controlProfile:self.segmentControl.selectedSegmentIndex];
    
    
    self.ref = [[FIRDatabase database] reference];
    self.songsDictionary = [NSMutableDictionary new];
    self.number = [[NSNumber alloc] initWithInt:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[[self.ref child:@"users"] child:userID ] child:@"songs"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            [self.songsDictionary setObject:child.value forKey:child.key];
        }
        
        [self.mySongsTableView reloadData];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
}

#pragma mark - SegmentController
- (IBAction)chooseSegment:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            [self controlProfile:sender.selectedSegmentIndex];
            break;
        }
        case 1:{
            [self controlSearch:sender.selectedSegmentIndex];
            break;
        }
        default:
            break;
    }
}

- (void)controlProfile:(NSUInteger)segmentIndex{
    
    [self.searchTableView removeFromSuperview];
    
    
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@",currentUser.photoURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *profileImage = [[UIImage alloc] initWithData:data];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame: CGRectMake (self.view.frame.size.height/15,
                                                                            self.view.frame.size.width/15,
                                                                            60,
                                                                            60)];
    self.profileImageView.image = profileImage;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = YES;
    [self.view addSubview:self.profileImageView];
    
    
    
    
    UIFont * customFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.height/15 + 60 + self.view.frame.size.height/15,  self.view.frame.size.width/15, self.view.frame.size.height/2 - self.view.frame.size.height/15 + 60, 50)];
    self.nameLabel.text = currentUser.displayName;
    self.nameLabel.font = customFont;
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.minimumScaleFactor = 10.0f/12.0f;
    self.nameLabel.clipsToBounds = YES;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.nameLabel];
    
    
    
    self.mySongsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2,
                                                                          self.navigationController.navigationBar.frame.size.height,
                                                                          self.view.frame.size.width/2,
                                                                          self.view.frame.size.height)];
    [self.view addSubview:self.mySongsTableView];
    self.mySongsTableView.delegate = self;
    self.mySongsTableView.dataSource = self;
}

- (void)controlSearch:(NSUInteger)segmentIndex{
    [self.profileImageView removeFromSuperview];
    [self.nameLabel removeFromSuperview];
    [self.mySongsTableView removeFromSuperview];
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height,
                                                                         self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:self.searchTableView];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([tableView isEqual:self.mySongsTableView]){
        
        return [self.songsDictionary count];
    }else{
        
        return 15;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if([tableView isEqual:self.mySongsTableView]){
        
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if([tableView isEqual:self.mySongsTableView]){
        
        cell.textLabel.text = [[self.songsDictionary allKeys] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"playImage-1"];
        
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([tableView isEqual:self.mySongsTableView]){
        self.currentSong = [self.songsDictionary objectForKey:cell.textLabel.text];
        [self play];
    }else{
        NSLog(@"Do somthing");
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.mySongsTableView])
    {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *userID = [FIRAuth auth].currentUser.uid;
        [[[[self.ref child:@"users"] child:userID ] child:@"songs"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            // Get user value
            NSEnumerator *children = [snapshot children];
            FIRDataSnapshot *child;
            while (child = [children nextObject]) {
                if([child.key isEqualToString:cell.textLabel.text]){
                    [child.ref removeValue];
                    [self.songsDictionary removeObjectForKey:child.key];
                    [tableView reloadData];
                }
            }
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
    
}




#pragma mark - PlaySong

- (void)play{
    NSArray *split = [[self.currentSong stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" "];
    
    if(self.number.unsignedIntValue < [split count]){
        
        if ([[split objectAtIndex:self.number.unsignedIntValue] isEqual: @"'1'"]){
            [NSTimer scheduledTimerWithTimeInterval:4.0
                                             target:self
                                           selector:@selector(timerOff)
                                           userInfo:nil
                                            repeats:NO];
        }else if ([[split objectAtIndex:self.number.unsignedIntValue] isEqual: @"'1/2'"]){
            [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(timerOff)
                                           userInfo:nil
                                            repeats:NO];
        }else if ([[split objectAtIndex:self.number.unsignedIntValue] isEqual: @"'1/4'"]){
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(timerOff)
                                           userInfo:nil
                                            repeats:NO];
        }else if ([[split objectAtIndex:self.number.unsignedIntValue] isEqual: @"'1/8'"]){
            [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(timerOff)
                                           userInfo:nil
                                            repeats:NO];
        }else if ([[split objectAtIndex:self.number.unsignedIntValue] isEqual: @"'1/16'"]){
            [NSTimer scheduledTimerWithTimeInterval:0.25
                                             target:self
                                           selector:@selector(timerOff)
                                           userInfo:nil
                                            repeats:NO];
        }else if ([[split objectAtIndex:self.number.unsignedIntValue] isEqual: @"'1/32'"]){
            [NSTimer scheduledTimerWithTimeInterval:0.125
                                             target:self
                                           selector:@selector(timerOff)
                                           userInfo:nil
                                            repeats:NO];
        }else{
            NSString *path = [NSString stringWithFormat:@"%@/Sound/%@.aif",[[NSBundle mainBundle] resourcePath],[split objectAtIndex:self.number.unsignedIntValue]];
            NSURL *soundURL = [NSURL fileURLWithPath:path];
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
            self.audioPlayer.currentTime = 0;
            [self.audioPlayer play];
            self.number = [NSNumber numberWithUnsignedInteger:self.number.unsignedIntValue +1];
            [self play];
        }
    }else if (self.number.unsignedIntValue == [split count]){
        self.number = [NSNumber numberWithUnsignedInteger:0];
    }
}

- (void)timerOff{
    self.number = [NSNumber numberWithUnsignedInteger:self.number.unsignedIntValue +1];
    [self play];
}


@end
