//
//  SugarMarcos.m

#import "SugarMarcos.h"
#import "AppDelegate.h"

UIWindow *AppWindow(void) {
    @autoreleasepool {
        return ((AppDelegate *) UIApplication.sharedApplication.delegate).window;
    };
}

CGFloat ScreenWidth(void) {
    @autoreleasepool {
        return UIScreen.mainScreen.bounds.size.width;
    };
}

CGFloat ScreenHeight(void) {
    @autoreleasepool {
        return UIScreen.mainScreen.bounds.size.height;
    };
};

CGFloat StatusBarHeight(void) {
    @autoreleasepool {
        return UIApplication.sharedApplication.statusBarFrame.size.height;
    };
}

CGFloat NavigationBarHeight(void) {
    @autoreleasepool {
        return StatusBarHeight() + 44;
    };
}

CGFloat SafeBottomHeight(void) {
    @autoreleasepool {
        return AppWindow().safeAreaInsets.bottom;
    };
}

CGFloat KSize(CGFloat length) {
    @autoreleasepool {
        return @(length * ScreenWidth() / 375).floatValue;
    };
}

UIFont *Font(CGFloat fontSize) {
    @autoreleasepool {
        return [UIFont systemFontOfSize:fontSize];
    };
}

void dispatch_main_async(dispatch_block_t asyncBlock) {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), asyncBlock);
    };
}
