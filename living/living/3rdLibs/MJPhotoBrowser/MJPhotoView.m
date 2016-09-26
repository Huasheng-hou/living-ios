//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface MJPhotoView ()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
}

@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;

		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
		
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    if (_photo.firstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
        _photo.srcImageView.image = nil;
        
        // 不是gif，就马上开始下载
        if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
            __unsafe_unretained MJPhotoView *photoView = self;
            __unsafe_unretained MJPhoto *photo = _photo;
            
            [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:
             ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                 photo.image = image;
                 [photoView adjustFrame];
             }];
        }
    } else {
        [self photoStartLoad];
    }

    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        
        self.scrollEnabled = NO;
        
        __unsafe_unretained MJPhotoView *photoView = self;
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.srcImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [photoView photoDidFinishLoadWithImage:image];
        }];
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	self.maximumZoomScale = 2.0;
	self.minimumZoomScale = 1.0;
    
    CGRect imageFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [self setZoomScale:1.0];
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - Determine maximum scale
- (CGFloat)calculateZoomScale
{
    if (_imageView.image) {
        
        CGFloat scale   = kScreenHeight / kScreenWidth;
        
        if (_imageView.image.size.width == 0 || _imageView.image.size.height == 0) {
            return 2;
        }
        
        if (_imageView.image.size.height / _imageView.image.size.width >= scale) {
            

        } else {
            
            
        }
    }
    
    return 2;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}
- (void)hide
{
    if (_doubleTap) return;
    
    // 缩放回正常大小
    if (self.zoomScale > self.minimumZoomScale) {
        
        [self setZoomScale:self.minimumZoomScale animated:NO];
    }
    
    // 清空底部的小图
    _photo.srcImageView.image = nil;
    
    CGFloat         duration = 0.3;
    UIImageView     *transitionImageView;
    
    CGFloat scale   = kScreenHeight / kScreenWidth;
    CGRect  frame   = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    if (_imageView.image.size.height < kScreenHeight && _imageView.image.size.width < kScreenWidth) {
        
        frame           = CGRectMake(ceil((kScreenWidth - _imageView.image.size.width) / 2.0),
                                     ceil((kScreenHeight - _imageView.image.size.height) / 2.0),
                                     _imageView.image.size.width, _imageView.image.size.height);
    }
    if (_imageView.image.size.height / _imageView.image.size.width >= scale) {
        
        CGFloat width   = _imageView.image.size.width / _imageView.image.size.height * kScreenHeight;
        frame           = CGRectMake(ceil((kScreenWidth - width) / 2.0), 0, width, kScreenHeight);
        
    } else {
        
        CGFloat height  = _imageView.image.size.height / _imageView.image.size.width * kScreenWidth;
        frame           = CGRectMake(0, ceil((kScreenHeight - height) / 2.0), kScreenWidth, height);
    }
    
    transitionImageView = [[UIImageView alloc] initWithFrame:frame];
    transitionImageView.image           = _imageView.image;
    transitionImageView.contentMode     = _photo.srcImageView.contentMode;
    transitionImageView.clipsToBounds   = _photo.srcImageView.clipsToBounds;
    
    [self addSubview:transitionImageView];
    
    [UIView animateWithDuration:duration animations:^{
        
        _imageView.frame            = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        transitionImageView.frame   = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        // gif图片仅显示第0张
        if (_imageView.image.images) {
            _imageView.image = _imageView.image.images[0];
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }

    } completion:^(BOOL finished) {
        
        // 设置底部的小图片
        if (_imageView.image) {
            _photo.srcImageView.image = _imageView.image;
        } else {
            _photo.srcImageView.image = _photo.placeholder;
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)handleLongPress
{
    if (self.photoViewDelegate && [self.photoViewDelegate respondsToSelector:@selector(photoViewLongPressed)]) {
        [self.photoViewDelegate photoViewLongPressed];
    }
}

@end
