//
//  HomeViewController.h
//  Auth
//
//  Created by Jose on 11/5/15.
//  Copyright © 2015 Jose Bethancourt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface HomeViewController : UIViewController <QRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;


@end
