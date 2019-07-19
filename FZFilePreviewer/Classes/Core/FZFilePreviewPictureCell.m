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
@property(nonatomic,strong) UIScrollView *scrollView;



@end

@implementation FZFilePreviewPictureCell

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


-(void)layoutSubviews{
    [super layoutSubviews];
    
//    self.scrollView.frame = self.frame;
//    self.scrollView.contentSize = self.frame.size;
//    self.imageView.frame = self.frame;
}

#pragma mark -- UI ----
-(void)setupViews{
    self.backgroundColor = [UIColor orangeColor];
}


#pragma mark -- UIScrollViewDelegate --

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


#pragma mark -- Lazy Func --

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
