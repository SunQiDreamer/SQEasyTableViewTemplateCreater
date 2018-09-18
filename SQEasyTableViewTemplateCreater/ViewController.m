//
//  ViewController.m
//  SQEasyTableViewTemplateCreater
//
//  Created by sunqi on 2018/9/18.
//  Copyright © 2018年 sunqi. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Extension.h"

@interface ViewController ()

@property (weak) IBOutlet NSTextField *productNametextField;
@property (weak) IBOutlet NSTextField *userNametextField;
@property (weak) IBOutlet NSTextField *moduleNametextField;
@property (weak) IBOutlet NSTextField *organizationNametextField;
@property (weak) IBOutlet NSTextField *directoryNametextField;

@property (weak) IBOutlet NSButton *searchButton;

@property (weak) IBOutlet NSButton *modelAndViewCheckbox;

@property (weak) IBOutlet NSButton *ViewModelAndControllerCheckbox;

@property (weak) IBOutlet NSButton *allCheckbox;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (assign) SEL sel;

@property (copy) NSString *desktopPath;

@property (copy) NSString *templatePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.sel = @selector(createAll);
    
    NSString *path = self.fileManager.currentDirectoryPath;
    self.desktopPath = [path stringByAppendingString:@"/Desktop"];
    self.templatePath = [self.desktopPath stringByAppendingString:@"/SQEasyTableViewTemplateCreater/SQEasyTableViewTemplateCreater/Template"];
    
    self.searchButton.enabled = NO;
    
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if (![self.productNametextField.stringValue isEmptyString] && ![self.moduleNametextField.stringValue isEmptyString] && ![self.organizationNametextField.stringValue isEmptyString]) {
        if (!self.searchButton.enabled) {
            self.searchButton.enabled = YES;
        }
    } else {
        if (self.searchButton.enabled) {
            self.searchButton.enabled = NO;
        }
    }
}


- (IBAction)search:(NSButton *)sender {
    if (!self.moduleNametextField.stringValue) {

    } else {
        [self performSelector:self.sel];
    }
}

- (IBAction)createModelAndCell:(NSButton *)sender {
    self.allCheckbox.state = NSControlStateValueOff;
    self.ViewModelAndControllerCheckbox.state = NSControlStateValueOff;
    self.sel = @selector(createCellAndModel);
}

- (IBAction)createViewModelAndController:(NSButton *)sender {
    self.modelAndViewCheckbox.state = NSControlStateValueOff;
    self.allCheckbox.state = NSControlStateValueOff;
    self.sel = @selector(createViewModelAndController);
}

- (IBAction)createAll:(NSButton *)sender {
    self.modelAndViewCheckbox.state = NSControlStateValueOff;
    self.ViewModelAndControllerCheckbox.state = NSControlStateValueOff;
    self.sel = @selector(createAll);
}

- (void)createCellAndModel {
    [self createTemplateWithPredicte:^BOOL(NSString *condition) {
        return ([condition containsString:@"Cell"] || (![condition containsString:@"ViewModel"] && [condition containsString:@"Model"]))  ;
    }];
}

- (void)createViewModelAndController {
    [self createTemplateWithPredicte:^BOOL(NSString *condition) {
        return [condition containsString:@"ViewModel"] || [condition containsString:@"Controller"];
    }];
}

- (void)createAll {
    [self createTemplateWithPredicte:^BOOL(NSString *condition) {
        return YES;
    }];
}

- (void)createTemplateWithPredicte:(BOOL(^)(NSString *condition))predicte {
    NSString *desktopPath = [NSString stringWithFormat:@"/Users/%@/Desktop", NSUserName()];
    NSString *templatePath = [desktopPath stringByAppendingPathComponent:self.directoryName];
    
    NSError *error  = nil;
    BOOL success = [self.fileManager createDirectoryAtPath:templatePath withIntermediateDirectories:YES attributes:nil error:&error];
    
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *sourcePath = [bundlePath stringByAppendingString:@"/Contents/Resources/Template/"];
    NSArray *files = [self.fileManager contentsOfDirectoryAtPath:sourcePath error:nil];
    
    for (NSString *file in files) {
        if (predicte(file)) {
            NSString *fileFrom = [sourcePath stringByAppendingPathComponent:file];
            
            NSString *newFileName = [file stringByReplacingOccurrencesOfString:@"Template" withString:self.moduleNametextField.stringValue];
            NSString *fileTo = [templatePath stringByAppendingPathComponent:newFileName];
            [self.fileManager copyItemAtPath:fileFrom toPath:fileTo error:&error];
            if (error) {
                
            }
            else {
                [self renameFileContent:fileTo];
            }
        }
    }
}

- (void)renameFileContent:(NSString *)file {
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    content = [content stringByReplacingOccurrencesOfString:@"Template" withString:self.moduleNametextField.stringValue];
    content = [content stringByReplacingOccurrencesOfString:@"___PROJECTNAME___" withString:self.productNametextField.stringValue];
    content = [content stringByReplacingOccurrencesOfString:@"___PROJECTNAME___" withString:self.productNametextField.stringValue];
    content = [content stringByReplacingOccurrencesOfString:@"___ORGANIZATIONNAME___" withString:self.organizationNametextField.stringValue];
    content = [content stringByReplacingOccurrencesOfString:@"___FULLUSERNAME___" withString:self.userName];
    content = [content stringByReplacingOccurrencesOfString:@"___DATE___" withString:[self currentDate:[NSDate date]]];
    content = [content stringByReplacingOccurrencesOfString:@"___YEAR___" withString:[self currentYear:[NSDate date]]];
    
    NSError *error = nil;
    [content writeToFile:file atomically:false encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        
    } else {
        
    }
}

- (NSString*)currentDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate:date];
}

- (NSString*)currentYear:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:date];
}

#pragma mark -
- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = NSFileManager.defaultManager;
    }
    return _fileManager;
}

- (NSString *)directoryName {
    if (![self.directoryNametextField.stringValue isEmptyString]) {
        return self.directoryNametextField.stringValue;
    } else {
        return @"template";
    }
}

- (NSString *)userName {
    if (![self.userNametextField.stringValue isEmptyString]) {
        return self.userNametextField.stringValue;
    } else {
        return NSUserName();
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
