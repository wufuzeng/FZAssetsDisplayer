//
//  FZFilePreviewPictureCell.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import "FZFilePreviewPictureCell.h"

@interface FZFilePreviewPictureCell ()
<
UIScrollViewDelegate
>
//@property(nonatomic,strong) UITapGestureRecognizer *tap;
@property(nonatomic,strong) UILongPressGestureRecognizer *longTap;
@property (nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) FZFilePreviewPicModel *picModel;

@end

@implementation FZFilePreviewPictureCell

-(void)configWithModel:(FZFilePreviewModel *)model{
    self.picModel = model.picModel;
    self.imageView.contentMode = model.contentMode;
    if (model.picModel.image) {
        self.imageView.image = model.picModel.image;
    }else{
        if([model.link hasPrefix:@"http"]){
            NSURL *url = [NSURL URLWithString:model.link];
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                NSError *error;
                NSData *responseData = [NSData dataWithContentsOfURL:url
                                                             options:NSDataReadingMappedIfSafe
                                                               error:&error];
                UIImage * image = [UIImage imageWithData:responseData];
                if (error == nil && image != nil) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.picModel.image = image;
                        self.imageView.image = image;
                    });
                }
            });
        }else if (model.link){
            UIImage *image = [UIImage imageNamed:model.link];
            if(image){
                self.picModel.image = image;
                self.imageView.image = image;
            }else{
                image = [UIImage imageWithContentsOfFile:model.link];
                self.picModel.image = image;
                self.imageView.image = image;
            } 
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.scrollView.frame = nFrame;
        self.scrollView.contentSize = nFrame.size;
        self.imageView.frame = nFrame;
        
        [self setupViews];
    }
    return self;
}


#pragma mark -- UI ----
-(void)setupViews{
//    [self tap];
    [self longTap];
}


#pragma mark -- UIScrollViewDelegate --

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


#pragma mark –- Gesture Func  --
//-(void)tapAction:(UITapGestureRecognizer *)sender{
//    NSLog(@"单击");
//}
-(void)longTapAction:(UILongPressGestureRecognizer *)sender{
    NSLog(@"长按");
    
    if (self.imageView.image == nil) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否保存相册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveTosystemAlbumWithPhoto:self.imageView.image];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- Save Picture To Album ------



-(void)saveTosystemAlbumWithPhoto:(UIImage*)photo{
    
    UIImageWriteToSavedPhotosAlbum(photo,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   (__bridge void *)self);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error){
        NSLog(@"保存失败");
    } else {
        NSLog(@"保存成功");
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


-(void)setCanZoom:(BOOL)canZoom{
    _canZoom = canZoom;
    self.scrollView.userInteractionEnabled = canZoom;
}

#pragma mark -- Lazy Func --
/*
-(UITapGestureRecognizer *)tap{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        //[self addGestureRecognizer:_tap];
    }
    return _tap;
}
*/

-(UILongPressGestureRecognizer *)longTap{
    if (_longTap == nil) {
        _longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
        [self addGestureRecognizer:_longTap];
    }
    return _longTap;
}


-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = YES;
        [self.contentView addSubview:_scrollView];
    }
    return _scrollView;
}


-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

@end
