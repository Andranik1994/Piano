//
//  WhiteNote.m
//  Piano
//
//  Created by Andranik on 3/28/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "WhiteNote.h"

@implementation WhiteNote


- (id)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

@end
