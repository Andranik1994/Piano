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

@interface PianoViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *octaveControl;
@property (strong, nonatomic) UIView *pianoView;
@property (strong, nonatomic) UIView *intervalsView;
@property (strong, nonatomic) UIView *noticeView;

@end

@implementation PianoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIImage* image = [UIImage imageNamed:@"profileLinkImage.png"];
    CGRect frameimg = CGRectMake(0, 0, 30 , 30);
    UIButton *profileButton = [[UIButton alloc] initWithFrame:frameimg];
    [profileButton setBackgroundImage:image forState:UIControlStateNormal];
    [profileButton addTarget:self action:@selector(goToProfile)
            forControlEvents:UIControlEventTouchUpInside];
    [profileButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightBarButton =[[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.pianoView = [[UIView alloc] initWithFrame: CGRectMake ( 0, self.view.frame.size.height*6/10, self.view.frame.size.width, self.view.frame.size.height*4/10)];
    self.pianoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.pianoView];
    
    self.intervalsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*5/10,  self.view.frame.size.width, self.view.frame.size.height/10)];
    self.intervalsView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.intervalsView];
    
    self.noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height,  self.view.frame.size.width,
                                                               self.view.frame.size.height*5/10-self.navigationController.navigationBar.frame.size.height)];
    self.noticeView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.noticeView];
    
    
    self.octaveControl.selectedSegmentIndex = 1;
    [self createWhiteKey:self.octaveControl.selectedSegmentIndex];
    [self createBlackKey:self.octaveControl.selectedSegmentIndex];
    
    
    
    NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
}

- (IBAction)chooseOctave:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            NSLog(@"1");
            [self createWhiteKey:sender.selectedSegmentIndex];
            [self createBlackKey:sender.selectedSegmentIndex];
            break;
        }
        case 1:{
            
            NSLog(@"2");
            [self createWhiteKey:sender.selectedSegmentIndex];
            [self createBlackKey:sender.selectedSegmentIndex];
            break;
        }
        case 2:{
            NSLog(@"3");
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










- (void)createWhiteKey:(NSUInteger)segmentIndex{
    
    if(segmentIndex == 2){
        for(int i = 0;i<8;i++){
            WhiteNote *noteW = [[WhiteNote alloc] init];
            noteW.frame = CGRectMake(i*self.pianoView.frame.size.width/14, 0, self.view.frame.size.width/14, self.view.frame.size.height);
            
            switch (i) {
                case 0:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 2];
                    break;
                }
                case 1:{
                    noteW.tune = [NSString stringWithFormat:@"%luD",segmentIndex*2 + 2];
                    break;
                }
                case 2:{
                    noteW.tune = [NSString stringWithFormat:@"%luE",segmentIndex*2 + 2];
                    break;
                }
                case 3:{
                    noteW.tune = [NSString stringWithFormat:@"%luF",segmentIndex*2 + 2];
                    break;
                }
                case 4:{
                    noteW.tune = [NSString stringWithFormat:@"%luG",segmentIndex*2 + 2];
                    break;
                }
                case 5:{
                    noteW.tune = [NSString stringWithFormat:@"%luA",segmentIndex*2 + 3];
                    break;
                }
                case 6:{
                    noteW.tune = [NSString stringWithFormat:@"%luB",segmentIndex*2 + 3];
                    break;
                }
                case 7:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 3];
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
                    break;
                }
                case 1:{
                    noteW.tune = [NSString stringWithFormat:@"%luD",segmentIndex*2 + 2];
                    break;
                }
                case 2:{
                    noteW.tune = [NSString stringWithFormat:@"%luE",segmentIndex*2 + 2];
                    break;
                }
                case 3:{
                    noteW.tune = [NSString stringWithFormat:@"%luF",segmentIndex*2 + 2];
                    break;
                }
                case 4:{
                    noteW.tune = [NSString stringWithFormat:@"%luG",segmentIndex*2 + 2];
                    break;
                }
                case 5:{
                    noteW.tune = [NSString stringWithFormat:@"%luA",segmentIndex*2 + 3];
                    break;
                }
                case 6:{
                    noteW.tune = [NSString stringWithFormat:@"%luB",segmentIndex*2 + 3];
                    break;
                }
                    
                case 7:{
                    noteW.tune = [NSString stringWithFormat:@"%luC",segmentIndex*2 + 3];
                    break;
                }
                case 8:{
                    noteW.tune = [NSString stringWithFormat:@"%luD",segmentIndex*2 + 3];
                    break;
                }
                case 9:{
                    noteW.tune = [NSString stringWithFormat:@"%luE",segmentIndex*2 + 3];
                    break;
                }
                case 10:{
                    noteW.tune = [NSString stringWithFormat:@"%luF",segmentIndex*2 + 3];
                    break;
                }
                case 11:{
                    noteW.tune = [NSString stringWithFormat:@"%luG",segmentIndex*2 + 3];
                    break;
                }
                case 12:{
                    noteW.tune = [NSString stringWithFormat:@"%luA",segmentIndex*2 + 4];
                    break;
                }
                case 13:{
                    noteW.tune = [NSString stringWithFormat:@"%luB",segmentIndex*2 + 4];
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
        [self.pianoView addSubview:noteB1];
        
        
        BlackNote *noteB2 = [[BlackNote alloc] init];
        noteB2.frame = CGRectMake(noteB1.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB2.tune = [NSString stringWithFormat:@"%luDs",segmentIndex*2 + 2];
        [self.pianoView addSubview:noteB2];
        
        
        BlackNote *noteB3 = [[BlackNote alloc] init];
        noteB3.frame = CGRectMake(noteB2.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB3.tune = [NSString stringWithFormat:@"%luFs",segmentIndex*2 + 2];
        
        [self.pianoView addSubview:noteB3];
        
        
        BlackNote *noteB4 = [[BlackNote alloc] init];
        noteB4.frame = CGRectMake(noteB3.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB4.tune = [NSString stringWithFormat:@"%luGs",segmentIndex*2 + 2];
        [self.pianoView addSubview:noteB4];
        
        
        BlackNote *noteB5 = [[BlackNote alloc] init];
        noteB5.frame = CGRectMake(noteB4.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB5.tune = [NSString stringWithFormat:@"%luAs",segmentIndex*2 + 3];
        [self.pianoView addSubview:noteB5];
        
        
    }else{
        
        BlackNote *noteB1 = [[BlackNote alloc] init];
        noteB1.frame = CGRectMake(self.pianoView.frame.size.width/14 - self.pianoView.frame.size.width/41, 0,
                                  self.pianoView.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB1.tune = [NSString stringWithFormat:@"%luCs",segmentIndex*2 + 2];
        [self.pianoView addSubview:noteB1];
        
        
        BlackNote *noteB2 = [[BlackNote alloc] init];
        noteB2.frame = CGRectMake(noteB1.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB2.tune = [NSString stringWithFormat:@"%luDs",segmentIndex*2 + 2];
        [self.pianoView addSubview:noteB2];
        
        
        BlackNote *noteB3 = [[BlackNote alloc] init];
        noteB3.frame = CGRectMake(noteB2.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB3.tune = [NSString stringWithFormat:@"%luFs",segmentIndex*2 + 2];
        
        [self.pianoView addSubview:noteB3];
        
        
        BlackNote *noteB4 = [[BlackNote alloc] init];
        noteB4.frame = CGRectMake(noteB3.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB4.tune = [NSString stringWithFormat:@"%luGs",segmentIndex*2 + 2];
        [self.pianoView addSubview:noteB4];
        
        
        BlackNote *noteB5 = [[BlackNote alloc] init];
        noteB5.frame = CGRectMake(noteB4.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB5.tune = [NSString stringWithFormat:@"%luAs",segmentIndex*2 + 3];
        [self.pianoView addSubview:noteB5];
        
        
        BlackNote *noteB6 = [[BlackNote alloc] init];
        noteB6.frame = CGRectMake(noteB5.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB6.tune = [NSString stringWithFormat:@"%luCs",segmentIndex*2 + 3];
        [self.pianoView addSubview:noteB6];
        
        
        BlackNote *noteB7 = [[BlackNote alloc] init];
        noteB7.frame = CGRectMake(noteB6.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB7.tune = [NSString stringWithFormat:@"%luDs",segmentIndex*2 + 3];
        [self.pianoView addSubview:noteB7];
        
        
        BlackNote *noteB8 = [[BlackNote alloc] init];
        noteB8.frame = CGRectMake(noteB7.frame.origin.x + self.pianoView.frame.size.width/7 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB8.tune = [NSString stringWithFormat:@"%luFs",segmentIndex*2 + 3];
        [self.pianoView addSubview:noteB8];
        
        
        BlackNote *noteB9 = [[BlackNote alloc] init];
        noteB9.frame = CGRectMake(noteB8.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                  self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB9.tune = [NSString stringWithFormat:@"%luGs",segmentIndex*2 + 3];
        [self.pianoView addSubview:noteB9];
        
        
        BlackNote *noteB10 = [[BlackNote alloc] init];
        noteB10.frame = CGRectMake(noteB9.frame.origin.x + self.pianoView.frame.size.width/14 , 0,
                                   self.view.frame.size.width/21, self.pianoView.frame.size.height/2);
        noteB10.tune = [NSString stringWithFormat:@"%luAs",segmentIndex*2 + 4];
        [self.pianoView addSubview:noteB10];
        
    }
    
    
}

- (void)goToProfile{
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    [self.navigationController pushViewController:VC animated:NO];
    
}

@end
