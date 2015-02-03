//
//  OLNetworkImageLoader.m
//  Launcher
//
//  Created by Oscar Swanros on 11/14/14.
//  Copyright (c) 2014 OneLogin. All rights reserved.
//

#import "OLNetworkImageLoader.h"

#import "OLFoundation.h"

@interface OLNetworkImageLoader ()
@property (nonatomic) NSCache *imageCache;
@property (nonatomic) NSMapTable *imageToOperationMapTable;
+ (instancetype)sharedInstance;
@end

@interface OLNetworkImageLoadOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic) BOOL didStart;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, weak) UIImageView *weakImageView;
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSURLConnection *connection;
@end

@implementation OLNetworkImageLoadOperation

+ (void)delegateThreadMain:(id)ignored
{
    @autoreleasepool {
        NSThread.currentThread.name = @"OLNetworkImageLoader";
        NSRunLoop *runLoop = NSRunLoop.currentRunLoop;
        [runLoop addPort:NSMachPort.port forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)delegateThread
{
    static NSThread *thread;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(delegateThreadMain:) object:nil];
        [thread start];
    });
    
    return thread;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { self.responseData = [NSMutableData data]; }
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { [self.responseData appendData:data]; }
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { [self cleanUp]; }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (!self.responseData || self.isCancelled) { [self cleanUp]; return; }
    
    __strong UIImageView *imageView = self.weakImageView;
    if (!imageView) { [self cleanUp]; return; }
    
    UIImage *image = [UIImage imageWithData:self.responseData scale:UIScreen.mainScreen.scale];
    if (!image) { [self cleanUp]; return; }
    
    [OLNetworkImageLoader.sharedInstance.imageCache setObject:image forKey:self.URL.absoluteString];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isCancelled) imageView.image = image;
    });
    
    [self cleanUp];
}

- (void)cleanUp
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.connection = nil;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isExecuting
{
    return _didStart && _connection;
}

- (BOOL)isFinished
{
    return _didStart && !_connection;
}

- (void)cancel
{
    [self.connection cancel];
    [self cleanUp];
}

- (void)start
{
    NSThread *delegateThread = self.class.delegateThread;
    if (NSThread.currentThread != delegateThread) {
        [self performSelector:@selector(start) onThread:delegateThread withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (self.isCancelled) {
        _didStart = YES;
        [self cleanUp];
        
        return;
    }
    
    __strong UIImageView *imageViewStillExists = self.weakImageView;
    if (!imageViewStillExists || self.isCancelled) return;
    imageViewStillExists = nil;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:_cachePolicy timeoutInterval:30];
    
    [self willChangeValueForKey:@"isExecuting"];
    self.connection = [NSURLConnection connectionWithRequest:req delegate:self];
    self.didStart = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self.connection scheduleInRunLoop:NSRunLoop.currentRunLoop forMode:NSDefaultRunLoopMode];
    [self.connection start];
}

@end


@implementation OLNetworkImageLoader

+ (instancetype)sharedInstance
{
    static OLNetworkImageLoader *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[OLNetworkImageLoader alloc] init];
    });
    
    return __instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"OLNetworkImageLoader";
        self.maxConcurrentOperationCount = 3;
        self.imageCache = [[NSCache alloc] init];
        self.imageToOperationMapTable = [NSMapTable weakToWeakObjectsMapTable];
    }
    
    return self;
}

+ (void)loadImageAtURL:(NSURL *)url toImageView:(UIImageView *)imageView withPlaceHolderImage:(UIImage *)placeholder
{
    [self loadImageAtURL:url toImageView:imageView withPlaceHolderImage:placeholder cachePolicy:NSURLRequestUseProtocolCachePolicy];
}

+ (void)loadImageAtURL:(NSURL *)url toImageView:(UIImageView *)imageView withPlaceHolderImage:(UIImage *)placeholder cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    UIImage *cachedImage = [OLNetworkImageLoader.sharedInstance.imageCache objectForKey:url.absoluteString];
    if (cachedImage) {
        ol_executeOnMainThread(^{
            imageView.image = cachedImage;
        });
        return;
    }
    
    if (placeholder) {
        ol_executeOnMainThread(^{
            imageView.image = placeholder;
        });
    }
    
    OLNetworkImageLoadOperation *existingOperation = [OLNetworkImageLoader.sharedInstance.imageToOperationMapTable objectForKey:imageView];
    if (existingOperation) {
        if ([existingOperation.URL.absoluteString isEqualToString:url.absoluteString]) return;
        else [existingOperation cancel];
    }
    
    OLNetworkImageLoadOperation *operation = [[OLNetworkImageLoadOperation alloc] init];
    operation.URL = url;
    operation.cachePolicy = cachePolicy;
    operation.weakImageView = imageView;
    [self.sharedInstance addOperation:operation];
    [OLNetworkImageLoader.sharedInstance.imageToOperationMapTable setObject:operation forKey:imageView];
}

+ (void)cancelLoadForImageView:(UIImageView *)imageView
{
    OLNetworkImageLoadOperation *loadOperation = [OLNetworkImageLoader.sharedInstance.imageToOperationMapTable objectForKey:imageView];
    if (loadOperation) {
        [loadOperation cancel];
    }
}


@end
