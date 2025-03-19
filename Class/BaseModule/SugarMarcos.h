//
//  SugarMarcos.h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

CGFloat ScreenWidth(void);
CGFloat ScreenHeight(void);

CGFloat StatusBarHeight(void);
CGFloat NavigationBarHeight(void);
CGFloat SafeBottomHeight(void);

CGFloat KSize(CGFloat length);
UIFont *Font(CGFloat fontSize);

void dispatch_main_async(dispatch_block_t asyncBlock);

#define kWeakS(ws)                  __weak __typeof(self) ws           = self;
#define kStrongS(ss)                __strong __typeof(ws)ss            = ws;
