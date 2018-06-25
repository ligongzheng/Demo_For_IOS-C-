//
//  ViewController.h
//  AddGtest
//
//  Created by 李恭政 on 18/6/22.
//  Copyright © 2018年 李恭政. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    IBOutlet UITextView* logTextView;
}


- (IBAction)EnterForGest;

- (void)redirectNotificationHandle:(NSNotification *)nf;
- (void)redirectSTD:(int )fd;

@end

