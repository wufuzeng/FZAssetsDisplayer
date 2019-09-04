//
//  FZViewController.m
//  FZFilePreviewer
//
//  Created by wufuzeng on 07/19/2019.
//  Copyright (c) 2019 wufuzeng. All rights reserved.
//

#import "FZViewController.h"

#import "FZFilePreviewer.h"

@interface FZViewController ()
<FZFilePreviewViewDelegate>

@property (nonatomic,strong) FZFilePreviewView *previewView;

@end

@implementation FZViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    FZFilePreviewModel *model1 = [FZFilePreviewModel new];
    model1.link = [[NSBundle mainBundle] pathForResource:@"picture" ofType:@".png"];
    model1.fileType = FZFilePreviewTypePicture;
    
    
    FZFilePreviewModel *model2 = [FZFilePreviewModel new];
    //model2.link = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"mov"];
    model2.link = @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/CommunityFile%2FUserUpLoadFile%2FVideo%2F20190723092138770-1435_video.mp4";
    model2.fileType = FZFilePreviewTypeVideo;
   
    FZFilePreviewModel *model3 = [FZFilePreviewModel new];
    
    NSArray * links = @[
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/1.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/2.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/3.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/4.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/5.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/6.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/7.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/8.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/9.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/10.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/11.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/12.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/13.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/14.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/15.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/16.jpg",
                        @"https://mlboos.oss-cn-hangzhou.aliyuncs.com/ProductDynamicImage/Mark/17.jpg"
                        ];
    
//    NSMutableArray * images = [NSMutableArray array];
//    for (int i = 0; i < links.count; i ++) {
//
//        NSString *urlString = links[i];
//        NSError *error;
//        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString] options:NSDataReadingMappedIfSafe error:&error];
//        UIImage * image = [UIImage imageWithData:responseData];
//        [images addObject:image];
//    }
    
    model3.sceneModel.links = links;
    model3.fileType = FZFilePreviewTypeScene;
    
    FZFilePreviewModel *model4 = [FZFilePreviewModel new];
    //model4.image = [UIImage imageNamed:@"GifQRCode.gif"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GifQRCode" ofType:@"gif"];
    
    model4.link = path;
    model4.fileType = FZFilePreviewTypeGif;
    
    FZFilePreviewModel *model5 = [FZFilePreviewModel new];
    model5.link = @"http://img.soogif.com/9W36qhRbGtHIBdGakmdq6dvYU5l2r7wG.gif";
    model5.fileType = FZFilePreviewTypeGif;
    
    FZFilePreviewModel *model6 = [FZFilePreviewModel new];
    model6.link = @"http://img.soogif.com/HUIXurw2Rk4tKdfxIk8rdmvsNP9AWCPh.gif";
    model6.fileType = FZFilePreviewTypeGif;
    
    
    model1.contentMode = UIViewContentModeScaleAspectFill;
    model2.contentMode = UIViewContentModeScaleAspectFill;
    model3.contentMode = UIViewContentModeScaleAspectFill;
    //model4.contentMode = UIViewContentModeScaleAspectFill;
    model5.contentMode = UIViewContentModeScaleAspectFill;
    model6.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.previewView preview:@[
                                model1,
                                model2,
                                model3,
                                //model4,
                                model5,
                                model6
                                ]];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- FZFilePreviewViewDelegate --

-(void)previewView:(FZFilePreviewView *)previewView scrollToIndex:(NSInteger)index{
    NSLog(@"----%ld",index);
}

-(void)previewView:(FZFilePreviewView *)previewView clickedIndex:(NSInteger)index{
    NSLog(@"====%ld",index);
}


#pragma mark -- Lazy Func --

-(FZFilePreviewView *)previewView{
    if (_previewView == nil) {
        _previewView = [[FZFilePreviewView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        _previewView.delegate = self;
        
        [self.view addSubview:_previewView];
    }
    return _previewView;
}

@end
