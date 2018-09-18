//
//  TemplateViewModel.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSViewModelProtocol.h"

@interface TemplateViewModel : NSObject <YSViewModelProtocol>

@property (nonatomic, strong) RACSubject *refreshUISubject;

@end
