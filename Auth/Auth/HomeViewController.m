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

#import <LocalAuthentication/LocalAuthentication.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didReceiveRemoteNotification"]) {
        NSLog(@"notification is yes");
    }

    UIBarButtonItem *scancodeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Scan Code"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(scanCode)];
    self.navigationItem.rightBarButtonItem = scancodeButton;
    // Do any additional setup after loading the view.
}

-(void)scanCode {
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    // Set the presentation style
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Define the delegate receiver
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - QR Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSDictionary *response = [AuthAPI sendRequest:@{@"key": result, @"uuid": [FCUUID uuidForDevice], @"push_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"apntoken"] } toEndpoint:@"login" withType:@"POST"];
            if (response) {
                //good
            }else {
                //fail
            }
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
