//
//  PianoViewController.m
//  Piano
//
//  Created by Andranik on 3/27/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "PianoViewController.h"
#import "WhiteNote.h"
#import "BlackNote.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
@import Firebase;
@import GoogleSignIn;

@interface PianoViewController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *octaveControl;

@property (strong, nonatomic) UIView *pianoView;
@property (strong, nonatomic) UIView *intervalsView;

@property (strong, nonatomic) UIView *noticeView;
@property (strong, nonatomic) UILabel *noticeLabel;

@property (strong, nonatomic) UIView *controlPanelView;

@property (strong, nonatomic) NSString *deletetNotes;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (nonatomic , strong) NSNumber *number;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation PianoViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deletetNotes = [NSString new];
    self.number = [[NSNumber alloc] initWithInt:0];
    // Navigation Items
    
    UIImage *profileImage = [UIImage imageNamed:@"profileImage-1.png"];
    CGRect frameimg = CGRectMake(0, 0, 30 , 30);
    UIButton *profileButton = [[UIButton alloc] initWithFrame:frameimg];
    [profileButton setBackgroundImage:profileImage forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(goToProfile)
            forControlEvents:UIControlEventTouchUpInside];
    [profileButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    UIImage *saveImage = [UIImage imageNamed:@"saveImage-1.png"];
    frameimg = CGRectMake(0, 0, 30 , 30);
    UIButton *saveButton = [[UIButton alloc] initWithFrame:frameimg];
    [saveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save)
         forControlEvents:UIControlEventTouchUpInside];
    [saveButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *saveButtonItem =[[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    UIImage *playImage = [UIImage imageNamed:@"playImage-1.png"];
    frameimg = CGRectMake(0, 0, 30 , 30);
    UIButton *playButton = [[UIButton alloc] initWithFrame:frameimg];
    [playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(play)
         forControlEvents:UIControlEventTouchUpInside];
    [playButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *playButtonItem =[[UIBarButtonItem alloc] initWithCustomView:playButton];
    
    self.navigationItem.leftBarButtonItems = @[saveButtonItem, playButtonItem];
    
    
    // PianoView
    self.pianoView = [[UIView alloc] initWithFrame: CGRectMake ( 0, self.view.frame.size.height*6/10, self.view.frame.size.width, self.view.frame.size.height*4/10)];
    [self.view addSubview:self.pianoView];
    
    // IntervalsView
    self.intervalsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*5/10,  self.view.frame.size.width, self.view.frame.size.height/10)];
    [self.view addSubview:self.intervalsView];
    //// intervalButton_1
    frameimg = CGRectMake(0, 0, self.intervalsView.frame.size.width/6, self.intervalsView.frame.size.height);
    UIButton *intervalButton_1 = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton_1.frame = frameimg;
    [intervalButton_1 addTarget:self action:@selector(setInterval:)
               forControlEvents:UIControlEventTouchUpInside];
    [intervalButton_1 setTitle:@"1" forState:UIControlStateNormal];
    [intervalButton_1 setTintColor:[UIColor blackColor]];
    [[intervalButton_1 layer] setBorderWidth:1.0f];
    [[intervalButton_1 layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.intervalsView addSubview:intervalButton_1];
    
    //// intervalButton_2
    frameimg = CGRectMake(self.intervalsView.frame.size.width/6, 0, self.intervalsView.frame.size.width/6, self.intervalsView.frame.size.height);
    UIButton *intervalButton_2 = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton_2.frame = frameimg;
    [intervalButton_2 addTarget:self action:@selector(setInterval:)
               forControlEvents:UIControlEventTouchUpInside];
    [intervalButton_2 setTitle:@"1/2" forState:UIControlStateNormal];
    [intervalButton_2 setTintColor:[UIColor blackColor]];
    [[intervalButton_2 layer] setBorderWidth:1.0f];
    [[intervalButton_2 layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.intervalsView addSubview:intervalButton_2];
    //// intervalButton_3
    frameimg = CGRectMake(self.intervalsView.frame.size.width*2/6, 0, self.intervalsView.frame.size.width/6, self.intervalsView.frame.size.height);
    UIButton *intervalButton_3 = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton_3.frame = frameimg;
    [intervalButton_3 addTarget:self action:@selector(setInterval:)
               forControlEvents:UIControlEventTouchUpInside];
    [intervalButton_3 setTitle:@"1/4" forState:UIControlStateNormal];
    [intervalButton_3 setTintColor:[UIColor blackColor]];
    [[intervalButton_3 layer] setBorderWidth:1.0f];
    [[intervalButton_3 layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.intervalsView addSubview:intervalButton_3];
    //// intervalButton_4
    frameimg = CGRectMake(self.intervalsView.frame.size.width*3/6, 0, self.intervalsView.frame.size.width/6, self.intervalsView.frame.size.height);
    UIButton *intervalButton_4 = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton_4.frame = frameimg;
    [intervalButton_4 addTarget:self action:@selector(setInterval:)
               forControlEvents:UIControlEventTouchUpInside];
    [intervalButton_4 setTitle:@"1/8" forState:UIControlStateNormal];
    [intervalButton_4 setTintColor:[UIColor blackColor]];
    [[intervalButton_4 layer] setBorderWidth:1.0f];
    [[intervalButton_4 layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.intervalsView addSubview:intervalButton_4];
    //// intervalButton_5
    frameimg = CGRectMake(self.intervalsView.frame.size.width*4/6, 0, self.intervalsView.frame.size.width/6, self.intervalsView.frame.size.height);
    UIButton *intervalButton_5 = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton_5.frame = frameimg;
    [intervalButton_5 addTarget:self action:@selector(setInterval:)
               forControlEvents:UIControlEventTouchUpInside];
    [intervalButton_5 setTitle:@"1/16" forState:UIControlStateNormal];
    [intervalButton_5 setTintColor:[UIColor blackColor]];
    [[intervalButton_5 layer] setBorderWidth:1.0f];
    [[intervalButton_5 layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.intervalsView addSubview:intervalButton_5];
    //// intervalButton_6
    frameimg = CGRectMake(self.intervalsView.frame.size.width*5/6, 0, self.intervalsView.frame.size.width/6, self.intervalsView.frame.size.height);
    UIButton *intervalButton_6 = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton_6.frame = frameimg;
    [intervalButton_6 addTarget:self action:@selector(setInterval:)
               forControlEvents:UIControlEventTouchUpInside];
    [intervalButton_6 setTitle:@"1/32" forState:UIControlStateNormal];
    [intervalButton_6 setTintColor:[UIColor blackColor]];
    [[intervalButton_6 layer] setBorderWidth:1.0f];
    [[intervalButton_6 layer] setBorderColor:[UIColor blackColor].CGColor];
    [self.intervalsView addSubview:intervalButton_6];
    
    
    
    
    // NoticeView
    self.noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, profileButton.frame.origin.x,
                                                               self.view.frame.size.height*5/10-self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.noticeView];
    //// NoticeLabel
    self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width*9/10,
                                                                 self.view.frame.size.height*5/10-self.navigationController.navigationBar.frame.size.height)];
    self.noticeLabel.text = @"";
    self.noticeLabel.numberOfLines = 0;
    self.noticeLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    self.noticeLabel.adjustsFontSizeToFitWidth = YES;
    self.noticeLabel.minimumScaleFactor = 10.0f/12.0f;
    self.noticeLabel.clipsToBounds = YES;
    self.noticeLabel.backgroundColor = [UIColor clearColor];
    self.noticeLabel.textColor = [UIColor blackColor];
    self.noticeLabel.textAlignment = NSTextAlignmentCenter;
    self.noticeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.noticeView addSubview:self.noticeLabel];
    
    
    
    // ControlPanelView
    self.controlPanelView = [[UIView alloc] initWithFrame:CGRectMake(profileButton.frame.origin.x,
                                                                     self.navigationController.navigationBar.frame.size.height,
                                                                     self.view.frame.size.width - profileButton.frame.origin.x,
                                                                     self.view.frame.size.height*5/10-self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.controlPanelView];
    //// backImage
    UIImage *backImage = [UIImage imageNamed:@"backImage-1.png"];
    frameimg = CGRectMake(self.controlPanelView.frame.size.width/3, 10, self.controlPanelView.frame.size.width/1.5 , self.controlPanelView.frame.size.width/1.5);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setShowsTouchWhenHighlighted:YES];
    [self.controlPanelView addSubview:backButton];
    //// right Image
    UIImage *rightImage = [UIImage imageNamed:@"rightImage-1.png"];
    frameimg = CGRectMake(self.controlPanelView.frame.size.width/3, backButton.frame.size.height + 18, self.controlPanelView.frame.size.width/1.5 , self.controlPanelView.frame.size.width/1.5);
    UIButton *rightButton = [[UIButton alloc] initWithFrame:frameimg];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(right)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setShowsTouchWhenHighlighted:YES];
    [self.controlPanelView addSubview:rightButton];
    //// basket Image
    UIImage *basketImage = [UIImage imageNamed:@"basketImage-1.png"];
    frameimg = CGRectMake(self.controlPanelView.frame.size.width/3, rightButton.frame.size.height + backButton.frame.size.height + 26, self.controlPanelView.frame.size.width/1.5 , self.controlPanelView.frame.size.width/1.5);
    UIButton *basketButton = [[UIButton alloc] initWithFrame:frameimg];
    [basketButton setBackgroundImage:basketImage forState:UIControlStateNormal];
    [basketButton addTarget:self action:@selector(basket)
           forControlEvents:UIControlEventTouchUpInside];
    [basketButton setShowsTouchWhenHighlighted:YES];
    [self.controlPanelView addSubview:basketButton];
    
    
    
    // Did Load prefereces
    self.octaveControl.selectedSegmentIndex = 1;
    [self createWhiteKey:self.octaveControl.selectedSegmentIndex];
    [self createBlackKey:self.octaveControl.selectedSegmentIndex];
    
    //Firebase
    self.ref = [[FIRDatabase database] reference];
    
}

- (void)createWhiteKey:(NSUInteger)segmentIndex{
    
    if(segmentIndex == 2){
        for(int i = 0;i<8;i++){
            WhiteNote *noteW = [[WhiteNote alloc] init];
            noteW.frame = CGRectMake(i*self.pianoView.frame.size.width/14, 0, self.view.frame.size.width/14, self.view.frame.size.height);
            
            switch (i) {
                case 0:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 1:{
                    noteW.tune = [NSString stringWithFormat:@"%luD",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 2:{
                    noteW.tune = [NSString stringWithFormat:@"%luE",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 3:{
                    noteW.tune = [NSString stringWithFormat:@"%luF",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 4:{
                    noteW.tune = [NSString stringWithFormat:@"%luG",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 5:{
                    noteW.tune = [NSString stringWithFormat:@"%luA",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 6:{
                    noteW.tune = [NSString stringWithFormat:@"%luB",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 7:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                    
                default:
                    break;
            }
            [self.pianoView addSubview:noteW];
        }
        
        
    }else{
        for(int i = 0;i<14;i++){
            WhiteNote *noteW = [[WhiteNote alloc] init];
            noteW.frame = CGRectMake(i*self.pianoView.frame.size.width/14, 0, self.view.frame.size.width/14, self.view.frame.size.height);
            
            switch (i) {
                case 0:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 1:{
                    noteW.tune = [NSString stringWithFormat:@"%luD",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 2:{
                    noteW.tune = [NSString stringWithFormat:@"%luE",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 3:{
                    noteW.tune = [NSString stringWithFormat:@"%luF",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 4:{
                    noteW.tune = [NSString stringWithFormat:@"%luG",segmentIndex*2 + 2];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 5:{
                    noteW.tune = [NSString stringWithFormat:@"%luA",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 6:{
                    noteW.tune = [NSString stringWithFormat:@"%luB",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                    
                case 7:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 8:{
                    noteW.tune = [NSString stringWithFormat:@"%luD",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 9:{
                    noteW.tune = [NSString stringWithFormat:@"%luE",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 10:{
                    noteW.tune = [NSString stringWithFormat:@"%luF",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 11:{
                    noteW.tune = [NSString stringWithFormat:@"%luG",segmentIndex*2 + 3];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 12:{
                    noteW.tune = [NSString stringWithFormat:@"%luA",segmentIndex*2 + 4];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                case 13:{
                    noteW.tune = [NSString stringWithFormat:@"%luB",segmentIndex*2 + 4];
                    [noteW addTarget:self action:@selector(changeLabelW:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                    
                default:
                    break;
            }
            [self.pianoView addSubview:noteW];
        }
    }
}
- (void)createBlackKey:(NSUInteger)segmentIndex{
    if(segmentIndex == 2){
        BlackNote *noteB1 = [[BlackNote alloc] init];
        noteB1.frame = CGRectMake(self.pianoView.frame.size.width/14 - self.pianoView.frame.size.width/41, 0,
                                  self.pianoView.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB1.tune = [NSString stringWithFormat:@"%luCs",segmentIndex*2 + 2];
        [noteB1 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.pianoView addSubview:noteB1];
        
        
        BlackNote *noteB2 = [[BlackNote alloc] init];
        noteB2.frame = CGRectMake(noteB1.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB2.tune = [NSString stringWithFormat:@"%luDs",segmentIndex*2 + 2];
        [noteB2 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB2];
        
        
        BlackNote *noteB3 = [[BlackNote alloc] init];
        noteB3.frame = CGRectMake(noteB2.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB3.tune = [NSString stringWithFormat:@"%luFs",segmentIndex*2 + 2];
        [noteB3 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB3];
        
        
        BlackNote *noteB4 = [[BlackNote alloc] init];
        noteB4.frame = CGRectMake(noteB3.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB4.tune = [NSString stringWithFormat:@"%luGs",segmentIndex*2 + 2];
        [noteB4 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB4];
        
        
        BlackNote *noteB5 = [[BlackNote alloc] init];
        noteB5.frame = CGRectMake(noteB4.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB5.tune = [NSString stringWithFormat:@"%luAs",segmentIndex*2 + 3];
        [noteB5 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB5];
    }else{
        
        BlackNote *noteB1 = [[BlackNote alloc] init];
        noteB1.frame = CGRectMake(self.pianoView.frame.size.width/14 - self.pianoView.frame.size.width/41, 0,
                                  self.pianoView.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB1.tune = [NSString stringWithFormat:@"%luCs",segmentIndex*2 + 2];
        [noteB1 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB1];
        
        
        BlackNote *noteB2 = [[BlackNote alloc] init];
        noteB2.frame = CGRectMake(noteB1.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB2.tune = [NSString stringWithFormat:@"%luDs",segmentIndex*2 + 2];
        [noteB2 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB2];
        
        
        BlackNote *noteB3 = [[BlackNote alloc] init];
        noteB3.frame = CGRectMake(noteB2.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB3.tune = [NSString stringWithFormat:@"%luFs",segmentIndex*2 + 2];
        [noteB3 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.pianoView addSubview:noteB3];
        
        
        BlackNote *noteB4 = [[BlackNote alloc] init];
        noteB4.frame = CGRectMake(noteB3.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB4.tune = [NSString stringWithFormat:@"%luGs",segmentIndex*2 + 2];
        [noteB4 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB4];
        
        
        BlackNote *noteB5 = [[BlackNote alloc] init];
        noteB5.frame = CGRectMake(noteB4.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB5.tune = [NSString stringWithFormat:@"%luAs",segmentIndex*2 + 3];
        [noteB5 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB5];
        
        
        BlackNote *noteB6 = [[BlackNote alloc] init];
        noteB6.frame = CGRectMake(noteB5.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB6.tune = [NSString stringWithFormat:@"%luCs",segmentIndex*2 + 3];
        [noteB6 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB6];
        
        
        BlackNote *noteB7 = [[BlackNote alloc] init];
        noteB7.frame = CGRectMake(noteB6.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB7.tune = [NSString stringWithFormat:@"%luDs",segmentIndex*2 + 3];
        [noteB7 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB7];
        
        
        BlackNote *noteB8 = [[BlackNote alloc] init];
        noteB8.frame = CGRectMake(noteB7.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB8.tune = [NSString stringWithFormat:@"%luFs",segmentIndex*2 + 3];
        [noteB8 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB8];
        
        
        BlackNote *noteB9 = [[BlackNote alloc] init];
        noteB9.frame = CGRectMake(noteB8.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB9.tune = [NSString stringWithFormat:@"%luGs",segmentIndex*2 + 3];
        [noteB9 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB9];
        
        
        BlackNote *noteB10 = [[BlackNote alloc] init];
        noteB10.frame = CGRectMake(noteB9.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                   self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB10.tune = [NSString stringWithFormat:@"%luAs",segmentIndex*2 + 4];
        [noteB10 addTarget:self action:@selector(changeLabelB:) forControlEvents:UIControlEventTouchUpInside];
        [self.pianoView addSubview:noteB10];
    }
}

- (IBAction)chooseOctave:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            [self createWhiteKey:sender.selectedSegmentIndex];
            [self createBlackKey:sender.selectedSegmentIndex];
            break;
        }
        case 1:{
            [self createWhiteKey:sender.selectedSegmentIndex];
            [self createBlackKey:sender.selectedSegmentIndex];
            break;
        }
        case 2:{
            for (UIView *view in [self.pianoView subviews])
            {
                [view removeFromSuperview];
            }
            [self createWhiteKey:sender.selectedSegmentIndex];
            [self createBlackKey:sender.selectedSegmentIndex];
            break;
        }
            
        default:
            break;
    }
}

- (void)changeLabelW:(WhiteNote *)sender{
    self.noticeLabel.text = [NSString stringWithFormat:@"%@",[self.noticeLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",sender.tune]]];
    self.deletetNotes = @"";
}

- (void)changeLabelB:(BlackNote *)sender{
    self.noticeLabel.text = [NSString stringWithFormat:@"%@",[self.noticeLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",sender.tune]]];
    self.deletetNotes = @"";
}




- (void)goToProfile{
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)save{
    
    if (![self.noticeLabel.text  isEqual: @""]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Great !"
                                                                       message:@"Write the name of composition."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"SAVE" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               UITextField *nameField = alert.textFields[0];
                                                               
                                                               NSString *userID = [FIRAuth auth].currentUser.uid;
                                                               
                                                               FIRDatabaseReference *userReference = [[[FIRDatabase database] referenceFromURL:
                                                                                                       [NSString stringWithFormat:@"https://piano-17dd1.firebaseio.com/users/%@",userID]]
                                                                                                      child:@"songs"];
                                                               
                                                               NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                       self.noticeLabel.text,nameField.text,
                                                                                       nil];
                                                               
                                                               [userReference updateChildValues:values withCompletionBlock:^(NSError *__nullable err, FIRDatabaseReference * ref){
                                                                   if(err) {
                                                                       NSLog(@"In - PianoViewCantroller - Error in save ");
                                                                       return;
                                                                   }
                                                                   NSLog(@"Saved song seccessfully in FireBace db");
                                                               }];
                                                           }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        
        [alert addAction:saveAction];
        [alert addAction:cancelAction];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Input name...";
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)play{
    NSArray *split = [[self.noticeLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString: @" "];

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


- (void)back{
    if (![self.noticeLabel.text isEqualToString:@""]){
        NSRange range= [self.noticeLabel.text rangeOfString: @" " options: NSBackwardsSearch];
        self.deletetNotes = [[self.noticeLabel.text substringFromIndex:range.location] stringByAppendingString:self.deletetNotes];
        
        
        
        self.noticeLabel.text = [self.noticeLabel.text substringToIndex: range.location];
    }
}

- (void)right{
    if(![self.deletetNotes  isEqual: @""]){
        self.deletetNotes = [self.deletetNotes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(self.deletetNotes.length > 3){
            self.noticeLabel.text = [self.noticeLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",[[self.deletetNotes componentsSeparatedByString:@" "] objectAtIndex:0]]];
            NSRange range= [self.deletetNotes rangeOfString: @" "];
            self.deletetNotes  = [self.deletetNotes substringFromIndex:range.location];
        } else{
            self.noticeLabel.text = [self.noticeLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.deletetNotes]];
            self.deletetNotes = @"";
        }
    }
    
    
    
}

- (void)basket{
    if(![self.noticeLabel.text isEqual:@""]){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete"
                                                                   message:@"Do you really want to delete your composition?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          self.deletetNotes = @"";
                                                          self.noticeLabel.text = @"";
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){}];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setInterval:(UIButton *)sender{
    self.noticeLabel.text = [NSString stringWithFormat:@"%@",[self.noticeLabel.text stringByAppendingString:[NSString stringWithFormat:@" '%@'",[sender currentTitle]]]];
    self.deletetNotes = @"";
}



@end
