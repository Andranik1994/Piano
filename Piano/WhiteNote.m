//
//  WhiteNote.m
//  Piano
//
//  Created by Andranik on 3/28/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "WhiteNote.h"
#import <AudioToolbox/AudioToolbox.h>
#import<AVFoundation/AVFoundation.h>
#import "UIColor+Additions.h"

@interface WhiteNote ()

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@end

@implementation WhiteNote


- (id)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self action:@selector(playNote) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpEnd) forControlEvents:UIControlEventTouchUpInside];

    }

    return self;
}

- (void)playNote{
    
    NSString *path = [NSString stringWithFormat:@"%@/Sound/%@.aif",[[NSBundle mainBundle] resourcePath],self.tune];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer play];
     NSLog(@"%@",self.tune);
    [self setBackgroundColor:[UIColor colorWithR:227 G:221 B:209 A:1]];
}

- (void)touchUpEnd{
     [self setBackgroundColor:[UIColor whiteColor]];
}
@end
