//
//  BlackNote.h
//  Piano
//
//  Created by Andranik on 3/31/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackNote : UIButton

@property (nonatomic, strong) NSString *tune;

- (void)playNote;
- (void)touchUpEnd;

@end
