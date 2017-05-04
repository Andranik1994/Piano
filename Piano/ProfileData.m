//
//  ProfileData.m
//  Piano
//
//  Created by Andranik on 5/4/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "ProfileData.h"

@interface ProfileData ()


@end


@implementation ProfileData

static ProfileData *sharedProfileData = NULL;

- (id)init {
    self = [super init];
    if (self) {
        self.nickName = [[NSString alloc]init];
        self.profileImageUrl = [[NSString alloc]init];
    }
    return self;
}


+(ProfileData *)sharedProfileData{
    if(!sharedProfileData || sharedProfileData == NULL){
        sharedProfileData = [ProfileData new];
    }
    return sharedProfileData;
}


@end
