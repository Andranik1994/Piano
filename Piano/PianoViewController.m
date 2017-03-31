//
//  PianoViewController.m
//  Piano
//
//  Created by Andranik on 3/27/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "PianoViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
#import "WhiteNote.h"
#import "BlackNote.h"

@interface PianoViewController ()

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation PianoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIImage* image = [UIImage imageNamed:@"profileLinkImage.png"];
    CGRect frameimg = CGRectMake(0, 0, 33 , 33);
    UIButton *profileButton = [[UIButton alloc] initWithFrame:frameimg];
    
    [profileButton setBackgroundImage:image forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(goToProfile)
         forControlEvents:UIControlEventTouchUpInside];
    [profileButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self createWhiteKey];
    [self createBlackKey];
    
}

- (void)goToProfile{
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)playWhite:(WhiteNote*) noteW{
    
    NSString *path = [NSString stringWithFormat:@"%@/Sound/%@.aif",[[NSBundle mainBundle] resourcePath],noteW.tune];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    self.audioPlayer.currentTime =0;
    [self.audioPlayer play];
}

- (void)playBlack:(BlackNote*) noteW{
    
    NSString *path = [NSString stringWithFormat:@"%@/Sound/%@.aif",[[NSBundle mainBundle] resourcePath],noteW.tune];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    self.audioPlayer.currentTime =0;
    [self.audioPlayer play];
}

- (void)createWhiteKey{
    for(int i = 0;i<14;i++){
        WhiteNote *noteW = [[WhiteNote alloc] init];
        
        [noteW addTarget:self
                  action:@selector(playWhite:)
        forControlEvents:UIControlEventTouchUpInside];
        
        noteW.frame = CGRectMake(i*self.view.frame.size.width/14, self.view.frame.size.height/2, self.view.frame.size.width/14, self.view.frame.size.height/2);
        
        switch (i) {
            case 0:{
                noteW.tune = [NSString stringWithFormat:@"%dC",5];
                break;
            }
            case 1:{
                noteW.tune = [NSString stringWithFormat:@"%dD",5];
                break;
            }
            case 2:{
                noteW.tune = [NSString stringWithFormat:@"%dE",5];
                break;
            }
            case 3:{
                noteW.tune = [NSString stringWithFormat:@"%dF",5];
                break;
            }
            case 4:{
                noteW.tune = [NSString stringWithFormat:@"%dG",5];
                break;
            }
            case 5:{
                noteW.tune = [NSString stringWithFormat:@"%dA",5];
                break;
            }
            case 6:{
                noteW.tune = [NSString stringWithFormat:@"%dB",5];
                break;
            }
                
            case 7:{
                noteW.tune = [NSString stringWithFormat:@"%dC",6];
                break;
            }
            case 8:{
                noteW.tune = [NSString stringWithFormat:@"%dD",6];
                break;
            }
            case 9:{
                noteW.tune = [NSString stringWithFormat:@"%dE",6];
                break;
            }
            case 10:{
                noteW.tune = [NSString stringWithFormat:@"%dF",6];
                break;
            }
            case 11:{
                noteW.tune = [NSString stringWithFormat:@"%dG",6];
                break;
            }
            case 12:{
                noteW.tune = [NSString stringWithFormat:@"%dA",6];
                break;
            }
            case 13:{
                noteW.tune = [NSString stringWithFormat:@"%dB",6];
                break;
            }
                
            default:
                break;
        }
        
        
        [self.view addSubview:noteW];
    }

}

- (void)createBlackKey{
    BlackNote *noteB1 = [[BlackNote alloc] init];
    [noteB1 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB1.frame = CGRectMake(self.view.frame.size.width/14 - self.view.frame.size.width/41, self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB1.tune = [NSString stringWithFormat:@"%dCs",5];
    
    [self.view addSubview:noteB1];
    
    
    BlackNote *noteB2 = [[BlackNote alloc] init];
    [noteB2 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB2.frame = CGRectMake(noteB1.frame.origin.x + self.view.frame.size.width/14 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB2.tune = [NSString stringWithFormat:@"%dDs",5];
    
    [self.view addSubview:noteB2];
    
    
    BlackNote *noteB3 = [[BlackNote alloc] init];
    [noteB3 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB3.frame = CGRectMake(noteB2.frame.origin.x + self.view.frame.size.width/7 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB3.tune = [NSString stringWithFormat:@"%dFs",5];
    
    
    [self.view addSubview:noteB3];
    
    
    BlackNote *noteB4 = [[BlackNote alloc] init];
    [noteB4 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB4.frame = CGRectMake(noteB3.frame.origin.x + self.view.frame.size.width/14 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB4.tune = [NSString stringWithFormat:@"%dGs",5];
    
    
    [self.view addSubview:noteB4];
    
    
    BlackNote *noteB5 = [[BlackNote alloc] init];
    [noteB5 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB5.frame = CGRectMake(noteB4.frame.origin.x + self.view.frame.size.width/14 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB5.tune = [NSString stringWithFormat:@"%dAs",5];
    
    [self.view addSubview:noteB5];
    
    
    BlackNote *noteB6 = [[BlackNote alloc] init];
    [noteB6 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB6.frame = CGRectMake(noteB5.frame.origin.x + self.view.frame.size.width/7 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB6.tune = [NSString stringWithFormat:@"%dCs",6];
    
    [self.view addSubview:noteB6];
    
    
    BlackNote *noteB7 = [[BlackNote alloc] init];
    [noteB7 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB7.frame = CGRectMake(noteB6.frame.origin.x + self.view.frame.size.width/14 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB7.tune = [NSString stringWithFormat:@"%dDs",6];
    
    [self.view addSubview:noteB7];
    
    
    BlackNote *noteB8 = [[BlackNote alloc] init];
    [noteB8 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB8.frame = CGRectMake(noteB7.frame.origin.x + self.view.frame.size.width/14 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB8.tune = [NSString stringWithFormat:@"%dFs",6];
    
    [self.view addSubview:noteB8];
    
    
    BlackNote *noteB9 = [[BlackNote alloc] init];
    [noteB9 addTarget:self
               action:@selector(playBlack:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB9.frame = CGRectMake(noteB8.frame.origin.x + self.view.frame.size.width/7 , self.view.frame.size.height/2,
                              self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB9.tune = [NSString stringWithFormat:@"%dGs",6];
    
    [self.view addSubview:noteB9];
    
    
    BlackNote *noteB10 = [[BlackNote alloc] init];
    [noteB10 addTarget:self
                action:@selector(playBlack:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    noteB10.frame = CGRectMake(noteB9.frame.origin.x + self.view.frame.size.width/14 , self.view.frame.size.height/2,
                               self.view.frame.size.width/21, self.view.frame.size.height/4);
    noteB10.tune = [NSString stringWithFormat:@"%dAs",6];
    
    [self.view addSubview:noteB10];

}

@end
