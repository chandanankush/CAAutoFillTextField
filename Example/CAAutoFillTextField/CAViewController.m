//
//  CAViewController.m
//  CAAutoFillTextField
//
//  Created by chandanankush on 05/22/2018.
//  Copyright (c) 2018 chandanankush. All rights reserved.
//

#import "CAViewController.h"
#import "CAAutoFillTextField.h"
#import "CAAutoCompleteObject.h"

@interface CAViewController ()<CAAutoFillDelegate>

@property(nonatomic, weak) IBOutlet CAAutoFillTextField *myTextField;

@end

@implementation CAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        CAAutoCompleteObject *object = [[CAAutoCompleteObject alloc] initWithObjectName:[NSString stringWithFormat:@"drop down %d", i] AndID:i];
        [tempArray addObject:object];
    }
    _myTextField.dataSourceArray = tempArray;
    _myTextField.delegate = self;
}

- (void)CAAutoTextFillBeginEditing:(CAAutoFillTextField *)textField {
}

- (void)CAAutoTextFillEndEditing:(CAAutoFillTextField *)textField {
}

- (BOOL)CAAutoTextFillWantsToEdit:(CAAutoFillTextField *)textField {
    return YES;
}
@end
