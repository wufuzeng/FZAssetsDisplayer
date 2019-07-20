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

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray <FZFilePreviewModel *> *files;

@end

@implementation FZFilePreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.collectionView.frame = nFrame;
        [self setupViews];
    }
    return self;
}

#pragma mark -- UI ----
-(void)setupViews{
    
}

-(void)preview:(NSArray <FZFilePreviewModel *>*)files{
    
    self.files = files;
    [self.collectionView reloadData];
    
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
        cell.imageView.image = model.image;
        
        
        if (indexPath.row % 2 == 0) {
            cell.imageView.backgroundColor = [UIColor cyanColor];
        }else{
            cell.imageView.backgroundColor = [UIColor yellowColor];
        }
        
        
        return cell;
    } else if (model.fileType == FZFilePreviewTypeGif) {
        FZFilePreviewGifCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewGifCell class]) forIndexPath:indexPath];
        cell.gifImageView.image = model.image;
        cell.gifImageView.data = model.data;
        return cell;
    } else if (model.fileType == FZFilePreviewTypeScene) {
        FZFilePreviewSceneCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewSceneCell class]) forIndexPath:indexPath];
        cell.images = model.images;
        
        return cell;
    } else if (model.fileType == FZFilePreviewTypeLive) {
        FZFilePreviewLiveCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewLiveCell class]) forIndexPath:indexPath];
        
        return cell;
    } else if (model.fileType == FZFilePreviewTypeVideo) {
        FZFilePreviewVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewVideoCell class]) forIndexPath:indexPath];
        
        cell.URL = model.URL;
        //[cell stopPlay];
        return cell;
    } else   {
        FZFilePreviewVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FZFilePreviewVideoCell class]) forIndexPath:indexPath];
        
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);{
    FZFilePreviewModel *model = self.files[indexPath.row];
    if (model.fileType == FZFilePreviewTypeScene){
        FZFilePreviewSceneCell * CELL = (FZFilePreviewSceneCell*)cell;
        [CELL startWaggle];
    } else if (model.fileType == FZFilePreviewTypeGif) {
        FZFilePreviewGifCell * CELL = (FZFilePreviewGifCell *)cell;
        [CELL.gifImageView startAnimating];
    } else if (model.fileType == FZFilePreviewTypeVideo) {
        FZFilePreviewVideoCell * CELL = (FZFilePreviewVideoCell *)cell;
        [CELL startPlay];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);{
    FZFilePreviewModel *model = self.files[indexPath.row];
    if (model.fileType == FZFilePreviewTypeScene){
        FZFilePreviewSceneCell * CELL = (FZFilePreviewSceneCell*)cell;
        [CELL stopWaggle];
    } else if (model.fileType == FZFilePreviewTypeGif) {
        FZFilePreviewGifCell * CELL = (FZFilePreviewGifCell *)cell;
        [CELL.gifImageView stopGifAnimating];
    } else if (model.fileType == FZFilePreviewTypeVideo) {
        FZFilePreviewVideoCell * CELL = (FZFilePreviewVideoCell *)cell;
        [CELL stopPlay];
    }
}


#pragma mark -- UICollectionViewDelegate ---
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
 
    
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


#pragma mark -- Lazy Func ----

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowFayout = [UICollectionViewFlowLayout new];
        flowFayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowFayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
 
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
