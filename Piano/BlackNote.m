//
//  BlackNote.m
//  Piano
//
//  Created by Andranik on 3/31/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "BlackNote.h"

@implementation BlackNote

- (id)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 2;
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}


@end
