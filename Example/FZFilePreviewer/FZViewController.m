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
	
    FZFilePreviewModel *model1 = [FZFilePreviewModel new];
    model1.image = [UIImage imageNamed:@"picture"];
    model1.fileType = FZFilePreviewTypePicture;
    
    FZFilePreviewModel *model2 = [FZFilePreviewModel new];
     NSURL *URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Test" ofType:@"mov"]];
    model2.URL = URL;
    model2.fileType = FZFilePreviewTypeVideo;
   
    FZFilePreviewModel *model3 = [FZFilePreviewModel new];
    model3.images = @[[UIImage imageNamed:@"picture1.jpg"],
                      [UIImage imageNamed:@"picture2.jpg"],
                      [UIImage imageNamed:@"picture3.jpg"]
                      ];
    model3.fileType = FZFilePreviewTypeScene;
    
    FZFilePreviewModel *model4 = [FZFilePreviewModel new];
    //model4.image = [UIImage imageNamed:@"GifQRCode.gif"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GifQRCode" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    model4.data = data;
    model4.fileType = FZFilePreviewTypeGif;
    
    [self.previewView preview:@[model1,model4,model2,model3]];
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
