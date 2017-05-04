//
//  SettingsViewController.m
//  Piano
//
//  Created by Andranik on 5/2/17.
//  Copyright © 2017 Andranik. All rights reserved.
//

#import "SettingsViewController.h"
#import "NonRotatingUIImagePickerController.h"
#import "ProfileData.h"
@import Firebase;

@interface SettingsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UITextField *nickNameTextField;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (assign, nonatomic) BOOL imageIsChanged;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Settings"];
    
    self.imageIsChanged = NO;
    
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height,
                                                                   self.view.frame.size.width,self.view.frame.size.height/15)];
    self.nickNameLabel.text = @"Nick Name";
    self.nickNameLabel.numberOfLines = 0;
    self.nickNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    self.nickNameLabel.adjustsFontSizeToFitWidth = YES;
    self.nickNameLabel.minimumScaleFactor = 10.0f/12.0f;
    self.nickNameLabel.clipsToBounds = YES;
    self.nickNameLabel.backgroundColor = [UIColor clearColor];
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.nickNameLabel];
    
    
    
    self.nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3,
                                                                           self.navigationController.navigationBar.frame.size.height + self.view.frame.size.height/15  ,
                                                                           self.view.frame.size.width/3,self.view.frame.size.height/15)];
    self.nickNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nickNameTextField.font = [UIFont systemFontOfSize:15];
    self.nickNameTextField.placeholder = @"Enter text";
    self.nickNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nickNameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nickNameTextField.returnKeyType = UIReturnKeyDone;
    self.nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nickNameTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nickNameTextField];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.saveButton.frame =  CGRectMake(self.view.frame.size.width/3,
                                        self.navigationController.navigationBar.frame.size.height +
                                        self.view.frame.size.height*4/15 +self.view.frame.size.width/4,
                                        self.view.frame.size.width/3,self.view.frame.size.height/15);
    
    [self.saveButton addTarget:self action:@selector(save)
              forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:self.saveButton];
    
    
    
    
    /* Replays ViewImage in Button */
    self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3/8,
                                                                      self.navigationController.navigationBar.frame.size.height + self.view.frame.size.height*2/15 + 10,
                                                                      self.view.frame.size.width/4,self.view.frame.size.width/4)];
    
    self.profileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectProfileImageView:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImage addGestureRecognizer:singleTap];
    self.profileImage.image = [UIImage imageNamed:@"addImage"];
    [self.view addSubview:self.profileImage];
    
}

- (void)save{
    
    
    
    
    NSMutableDictionary *values = [NSMutableDictionary new];
    if(![self.nickNameTextField.text  isEqual: @""]){
        [values setObject:self.nickNameTextField.text forKey:@"nickName"];
    }
    
    
    if(self.imageIsChanged == YES){
        NSString *userID = [FIRAuth auth].currentUser.uid;
        
        NSString *imageName = [[NSUUID new].UUIDString stringByAppendingString:@".png"];
        NSString *currentUserID = [FIRAuth auth].currentUser.uid;
        FIRStorageReference *storageRef = [[[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"gs://piano-17dd1.appspot.com/profile_images/%@",currentUserID]] child:imageName];
        NSData *uploadData = UIImagePNGRepresentation(self.profileImage.image);
        
        [storageRef putData:uploadData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
            
            if (error != nil) {
                NSLog(@"%@",error);
            } else {
                NSLog(@"%@",metadata);
                
                [values setObject:[metadata.downloadURL absoluteString] forKey:@"profileImageURL"];
                [values setObject:[NSString stringWithFormat:@"%@",storageRef]
                           forKey:@"profileImageStorageRef"];
                
                
                
                FIRDatabaseReference *usersReference = [[[FIRDatabase database] referenceFromURL:@"https://piano-17dd1.firebaseio.com/users"] child:userID];
                [usersReference updateChildValues:values withCompletionBlock:^(NSError *__nullable err, FIRDatabaseReference * ref){
                    if(err) {
                        NSLog(@"Error in updateChildValues:values withCompletionBlock ");
                        return;
                    }
                    NSLog(@"Saved user seccessfully in FireBace db");
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }
            NSLog(@"%@",values);
        }];
    }
}

- (void)handleSelectProfileImageView:(UIGestureRecognizer *)recognizer {
    NSLog(@"image clicked");
    //
    
    
    UIImagePickerController *picker = [[NonRotatingUIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:NO completion:nil];
    
    picker.allowsEditing = YES;
}

#pragma mark - Delegates Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.profileImage.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.imageIsChanged = YES;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"PickerController Did Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
