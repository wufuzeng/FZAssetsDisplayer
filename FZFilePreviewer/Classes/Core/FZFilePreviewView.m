//
//  FZFilePreviewView.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import "FZFilePreviewView.h"

#import "FZFilePreviewPictureCell.h"
#import "FZFilePreviewGifCell.h"
#import "FZFilePreviewSceneCell.h"
#import "FZFilePreviewLiveCell.h"
#import "FZFilePreviewVideoCell.h"


@interface FZFilePreviewView ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray <FZFilePreviewModel *> *files;

@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation FZFilePreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.collectionView.frame = nFrame;
        self.currentIndex = 0;
        [self setupViews];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect labelRect = CGRectMake(
                                  CGRectGetWidth(self.frame)-30-20,
                                  20,
                                  30,
                                  30);
    self.label.frame = labelRect;
    
}

#pragma mark -- UI ----
-(void)setupViews{
    [self collectionView];
    [self label];
}

-(void)preview:(NSArray <FZFilePreviewModel *>*)files{
    
    self.files = files;
    [self updatePageNumber];
    [self.collectionView reloadData];
    
}
 
-(void)updatePageNumber{
    if (self.showPageControl) {
        self.label.hidden = !self.files.count;
    }
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex+1,(long)self.files.count];
}

-(void)startCurrentPageActivity{
    if(!self.files.count) return;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if ([cell isKindOfClass:[FZFilePreviewGifCell class]]) {
        FZFilePreviewGifCell* CELL = (FZFilePreviewGifCell *)cell;
        [CELL.gifImageView startGifAnimating];
    }else if ([cell isKindOfClass:[FZFilePreviewSceneCell class]]) {
        FZFilePreviewSceneCell* CELL = (FZFilePreviewSceneCell *)cell;
        [CELL startWaggle];
    }if ([cell isKindOfClass:[FZFilePreviewVideoCell class]]) {
        FZFilePreviewVideoCell* CELL = (FZFilePreviewVideoCell *)cell;
        [CELL startPlay];
    }
}

-(void)stopCurrentPageActivity{
    if(!self.files.count) return;
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if ([cell isKindOfClass:[FZFilePreviewGifCell class]]) {
        FZFilePreviewGifCell* CELL = (FZFilePreviewGifCell *)cell;
        [CELL.gifImageView stopGifAnimating];
    }else if ([cell isKindOfClass:[FZFilePreviewSceneCell class]]) {
        FZFilePreviewSceneCell* CELL = (FZFilePreviewSceneCell *)cell;
        [CELL stopWaggle];
    }if ([cell isKindOfClass:[FZFilePreviewVideoCell class]]) {
        FZFilePreviewVideoCell* CELL = (FZFilePreviewVideoCell *)cell;
        [CELL stopPlay];
    }
}

#pragma mark -- UICollectionViewDataSource ---

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.files.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FZFilePreviewModel *model = self.files[indexPath.row];
    if (model.fileType == FZFilePreviewTypePicture) {
        FZFilePreviewPictureCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewPictureCell class]) forIndexPath:indexPath];
        [cell configWithModel:model];
        cell.canZoom = self.canZoomPic;
        return cell;
    } else if (model.fileType == FZFilePreviewTypeGif) {
        FZFilePreviewGifCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewGifCell class]) forIndexPath:indexPath];
        
        [cell configWithModel:model];
        
        return cell;
    } else if (model.fileType == FZFilePreviewTypeScene) {
        FZFilePreviewSceneCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewSceneCell class]) forIndexPath:indexPath];
        [cell configWithModel:model];
        
        return cell;
    } else if (model.fileType == FZFilePreviewTypeLive) {
        FZFilePreviewLiveCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewLiveCell class]) forIndexPath:indexPath];
        
        return cell;
    } else if (model.fileType == FZFilePreviewTypeVideo) {
        FZFilePreviewVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewVideoCell class]) forIndexPath:indexPath];
        cell.contentMode = model.contentMode;
        cell.url = model.link;
        return cell;
    } else   {
        FZFilePreviewVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewVideoCell class]) forIndexPath:indexPath];
        return cell;
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);{
//    FZFilePreviewModel *model = self.files[indexPath.row];
//    if (model.fileType == FZFilePreviewTypeScene){
//        FZFilePreviewSceneCell * CELL = (FZFilePreviewSceneCell*)cell;
//        [CELL stopWaggle];
//    } else if (model.fileType == FZFilePreviewTypeGif) {
//        FZFilePreviewGifCell * CELL = (FZFilePreviewGifCell *)cell;
//        [CELL.gifImageView stopGifAnimating];
//    } else if (model.fileType == FZFilePreviewTypeVideo) {
//        FZFilePreviewVideoCell * CELL = (FZFilePreviewVideoCell *)cell;
//        [CELL stopPlay];
//    }
//}

#pragma mark -- UIScrellViewDelegate --

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopCurrentPageActivity];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.currentIndex = pageIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageNumber];
    [self startCurrentPageActivity];
    if ([self.delegate respondsToSelector:@selector(previewView:scrollToIndex:)]) {
        [self.delegate previewView:self scrollToIndex:self.currentIndex];
    }
}




#pragma mark -- UICollectionViewDelegate ---
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
    if ([self.delegate respondsToSelector:@selector(previewView: clickedIndex:)]) {
        [self.delegate previewView:self clickedIndex:indexPath.row];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  0.000001f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  0.000001f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size;
}


#pragma mark -- Set,Get Func ---

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.collectionView.frame = frame;
    [self.collectionView layoutIfNeeded];
}

-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _label.hidden = !showPageControl;
}

#pragma mark -- Lazy Func ----

- (UILabel *)label{
    if (_label == nil) {
        _label = [UILabel new];
        _label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        _label.hidden = YES;
        _label.layer.cornerRadius = 15;
        _label.layer.masksToBounds = YES;
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:13];
        [self addSubview:_label];
    }
    return _label;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowFayout = [UICollectionViewFlowLayout new];
        flowFayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowFayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
 
        [_collectionView registerClass:[FZFilePreviewPictureCell class] forCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewPictureCell class])];
        [_collectionView registerClass:[FZFilePreviewGifCell class] forCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewGifCell class])];
        [_collectionView registerClass:[FZFilePreviewSceneCell class] forCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewSceneCell class])];
        [_collectionView registerClass:[FZFilePreviewLiveCell class] forCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewLiveCell class])];
        [_collectionView registerClass:[FZFilePreviewVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewVideoCell class])];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


@end
