//
//  TemplateController.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "TemplateController.h"
#import "TemplateViewModel.h"
#import "YSViewProtocol.h"

@interface TemplateViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TemplateViewModel *viewModel;
@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [self.viewModel.refreshUISubject subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<YSModelProtocol> model = [self.viewModel modelAtIndexPath:indexPath];
    id<YSViewProtocol> cell = [tableView dequeueReusableCellWithIdentifier:model.identifier forIndexPath:indexPath];
    [cell customViewWithData:model];
    
    return (UITableViewCell *)cell;
}

#pragma mark -
- (TemplateViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = TemplateViewModel.new;
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
