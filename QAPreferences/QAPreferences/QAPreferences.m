//
//  QAPreferences.m
//  QAPreferences
//
//  Created by Quentin ARNAULT on 17/02/13.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <objc/runtime.h>
#import "QAPreferences.h"

@implementation QAPreferences

#pragma mark -
+ (QAPreferences*)sharedInstance {
    static QAPreferences *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (NSDictionary *)defaultValues {
    return nil;
}

#pragma mark -
#pragma mark NSObject
- (id)init {
    self = [super init];
    
    if (self) {
        // register defaults values
        [[NSUserDefaults standardUserDefaults] registerDefaults:[self defaultValues]];
        
        // list properties and generate an implementation
        unsigned int nbProperties;
        objc_property_t * propertyList = class_copyPropertyList([self class]
                                                                , &nbProperties);
        
        for (int propertyIndex = 0; propertyIndex < nbProperties; ++propertyIndex) {
            objc_property_t property = propertyList[propertyIndex];
            NSString *propertyName = [NSString stringWithCString:property_getName(property)
                                                        encoding:NSUTF8StringEncoding];
            
            
            [self setAccessorImplementationForPropertyNamed:propertyName];
            [self setMutatorImplementationForPropertyNamed:propertyName];
        }
        
        // set application information
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                                                  forKey:@"qaBundleShortVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
                                                  forKey:@"qaBundleVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

#pragma mark -
#pragma mark private
- (void)setAccessorImplementationForPropertyNamed:(NSString *)propertyName {
    NSString *propertyNameOverride = [NSString stringWithFormat:@"%@%@"
                                      , propertyName
                                      , @"Override"];
    SEL propertyAccessorSelector = NSSelectorFromString(propertyName);
    
    Method propertyAccessorMethod = class_getInstanceMethod([self class], propertyAccessorSelector);
    
    method_setImplementation(propertyAccessorMethod
                             , imp_implementationWithBlock(
                                                           ^{
                                                               id actualValue = [[NSUserDefaults standardUserDefaults] valueForKey:propertyNameOverride];
                                                               
                                                               if (!actualValue)
                                                               {
                                                                   actualValue = [[NSUserDefaults standardUserDefaults] valueForKey:propertyName];
                                                               }
                                                               
                                                               return  actualValue;
                                                           }));
}

- (void)setMutatorImplementationForPropertyNamed:(NSString *)propertyName {
    NSString *mutatorName = [NSString stringWithFormat:@"%@%@%@%@"
                             // add leading set
                             , @"set"
                             // should change first letter to upper case
                             , [[propertyName substringWithRange:NSMakeRange(0, 1)] uppercaseString]
                             , [propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)]
                             // add trailing :
                             , @":"];
    
    SEL propertyAccessorSelector = NSSelectorFromString(mutatorName);
    
    Method propertyAccessorMethod = class_getInstanceMethod([self class], propertyAccessorSelector);
    method_setImplementation(propertyAccessorMethod
                             , imp_implementationWithBlock(
                                                           ^(id selfInstance, id newValueParameter){
                                                               [[NSUserDefaults standardUserDefaults] setValue:newValueParameter forKey:propertyName];
                                                               
                                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                                           }));
}

@end
