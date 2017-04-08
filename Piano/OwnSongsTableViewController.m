//
//  OwnSongsTableViewController.m
//  Piano
//
//  Created by Andranik on 4/7/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "OwnSongsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
@import Firebase;
@import GoogleSignIn;

@interface OwnSongsTableViewController ()

@property (strong ,nonatomic) NSMutableDictionary *songsDictionary;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic , strong) NSNumber *number;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (strong ,nonatomic) NSString *currentSong;

@end

@implementation OwnSongsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
            NSLog(@"%@",self.songsDictionary);
        }
        
        [self.tableView reloadData];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];



}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songsDictionary count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ownSongsCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.songsDictionary allKeys] objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    NSLog(@"%@",cell.textLabel.text);
    self.currentSong = [self.songsDictionary objectForKey:cell.textLabel.text];
    [self play];
}

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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
