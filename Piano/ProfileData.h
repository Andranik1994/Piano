//
//  ProfileData.h
//  Piano
//
//  Created by Andranik on 5/4/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileData : NSObject

@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *profileImageUrl;



+(ProfileData *)sharedProfileData;

@end

