//
//  HomeViewController.m
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import "HomeViewController.h"
#import "FCUUID.h"
#import "AuthAPI.h"
#import "UIColor+FlatColors.h"
#import "User.h"
#import "AuthScanner.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Realm.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Auth";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didReceiveRemoteNotification"]) {
        [AuthScanner validateFingerFromPush:[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationData"]];
    }
    
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor flatCloudsColor];
    RLMResults *users = [User allObjects];
    self.topLabel.text = [NSString stringWithFormat:@"Welcome back, %@", users[0][@"firstname"]];
}

-(IBAction)scanButton:(id)sender {
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}


#pragma mark - QR Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    
    [self dismissViewControllerAnimated:YES completion:^{

        AudioServicesPlaySystemSound (1352);
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"qrcode"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            RLMResults *users = [User allObjects];
            [AuthAPI sendRequest:@{@"username": users[0][@"email"], @"uuid": [FCUUID uuidForDevice], @"push_key":[[NSUserDefaults standardUserDefaults] objectForKey:@"apntoken"], @"one_time_code": result} toEndpoint:@"login/register" withType:@"POST"];
        });
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
