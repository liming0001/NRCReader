//
//  EmpowerView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmpowerView : UIView
@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property(nonatomic,copy)void (^sureActionBlock)(NSString *adminName,NSString *password);

@end

NS_ASSUME_NONNULL_END
