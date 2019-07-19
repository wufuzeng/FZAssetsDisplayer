//
//  FZViewController.m
//  FZFilePreviewer
//
//  Created by wufuzeng on 07/19/2019.
//  Copyright (c) 2019 wufuzeng. All rights reserved.
//

#import "FZViewController.h"

#import <FZFilePreviewer/FZFilePreviewer.h>

@interface FZViewController ()

@property (nonatomic,strong) FZFilePreviewView *previewView;

@end

@implementation FZViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    FZFilePreviewModel *model = [FZFilePreviewModel new];
    model.image = [UIImage imageNamed:@"picture.jpeg"];
    model.fileType = FZFilePreviewTypePicture;
    
    FZFilePreviewModel *model2 = [FZFilePreviewModel new];
    model2.image = [UIImage imageNamed:@"picture.jpeg"];
    model2.fileType = FZFilePreviewTypePicture;
    
    [self.previewView preview:@[model,model2,model,model]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- Lazy Func --

-(FZFilePreviewView *)previewView{
    if (_previewView == nil) {
        _previewView = [[FZFilePreviewView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        
        [self.view addSubview:_previewView];
    }
    return _previewView;
}

@end
