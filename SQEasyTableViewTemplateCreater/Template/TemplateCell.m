//
//  TemplateCell.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "TemplateCell.h"
#import "TemplateModel.h"

@interface TemplateCell ()
@property (nonatomic, copy) void (^event)(NSDictionary *, NSString *);
@end

@implementation TemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)customViewWithData:(id<YSModelProtocol>)data {
    
}

- (void)handleEvent:(void (^)(NSDictionary *, NSString *))event {
    self.event = event;
}

@end
