//
//  RVMViewModel+EPExtension.m
//  Ellipal
//
//  Created by cyl on 2018/7/20.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "RVMViewModel+EPExtension.h"
#import <objc/runtime.h>

@implementation RVMViewModel (EPExtension)

- (void)setTitle:(NSString *)title {
    objc_setAssociatedObject(self, @selector(title), title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSString *)title {
    return objc_getAssociatedObject(self, @selector(title));
}

@end
