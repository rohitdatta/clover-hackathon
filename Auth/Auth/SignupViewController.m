//
//  SignupViewController.m
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import "SignupViewController.h"
#import "User.h"
#import "AuthAPI.h"
#import "FCUUID.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    self.title = @"Signup";
    
    RLMResults *users = [User allObjects];
    
    if (users.count > 0){
        [self performSegueWithIdentifier:@"home" sender:self];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signupButton:(id)sender {
    
    
    User *newUser = [[User alloc] init];
    newUser.firstname = self.firstname.text;
    newUser.email = self.username.text;
    
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    // You only need to do this once (per thread)
    
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    [realm addObject:newUser];
    [realm commitWriteTransaction];
    
    [self performSegueWithIdentifier:@"home" sender:self];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
