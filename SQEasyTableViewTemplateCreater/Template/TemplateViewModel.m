//
//  TemplateViewModel.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "TemplateViewModel.h"

@implementation TemplateViewModel
@synthesize dataSource = _dataSource;

- (instancetype)init {
    self = [super init];
    if (self) {
        _refreshUISubject = RACSubject.new;
    }
    return self;
}

- (void)loadData {
    
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.refreshUISubject sendNext:self.dataSource];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (id<YSModelProtocol>)modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row];
}

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath {
    id<YSModelProtocol> model = [self modelAtIndexPath:indexPath];
    return model.height;
}

@end
