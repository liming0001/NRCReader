
//
//  EPSound.m
//  Ellipal_update
//
//  Created by 李黎明 on 2019/7/29.
//  Copyright © 2019 afuiot. All rights reserved.
//

#import "EPSound.h"

@implementation EPSound

+(void)playWithSoundName:(NSString *)soundName{
    SystemSoundID soundID;
//    NSString *path=[[NSBundle mainBundle]pathForResource:soundName ofType:@"wav"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
//    //需要手动释放：
//    AudioServicesDisposeSystemSoundID(soundID);
//
//    SystemSoundID soundID;
    
    NSURL *audioUrl = [[NSBundle mainBundle] URLForResource:soundName withExtension:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(audioUrl), &soundID);
    
    AudioServicesPlayAlertSound(soundID);
//    AudioServicesDisposeSystemSoundID(soundID);

}

@end
