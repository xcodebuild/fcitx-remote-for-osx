//
//  main.m
//  fcitx-remote
//
//  Created by codefalling on 15/11/2.
//  Copyright (c) 2015 codefalling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>


#define INACTIVE 1

#define ACTIVE 2

#define INACTIVE_STR "1"
#define ACTIVE_STR "2"

#ifndef US_KEYBOARD_LAYOUT
#define US_KEYBOARD_LAYOUT @"com.apple.keylayout.US"
#endif

#ifndef CHINESE_KEYBOARD_LAYOUT
#define CHINESE_KEYBOARD_LAYOUT @"GENERAL"
#endif

#define GENERAL_KEYBOARD_LAYOUT @"GENERAL"

static inline void pressKeyWithFlags(CGKeyCode virtualKey, CGEventFlags flags) {
    CGEventRef event = CGEventCreateKeyboardEvent(NULL, virtualKey, true);
    CGEventSetFlags(event, flags);
    CGEventPost(kCGSessionEventTap, event);
    CFRelease(event);
    
    event = CGEventCreateKeyboardEvent(NULL, virtualKey, false);
    CGEventSetFlags(event, flags);
    CGEventPost(kCGSessionEventTap, event);
    CFRelease(event);
}

void switch_to(NSString* imId){
    if ([imId isEqualToString:GENERAL_KEYBOARD_LAYOUT]) {
        // use cmd-alt-space to change input method
        pressKeyWithFlags(kVK_Space, kCGEventFlagMaskCommand | kCGEventFlagMaskAlternate);
        return;
    }
    NSDictionary *filter = [NSDictionary dictionaryWithObject:imId forKey:(NSString *) kTISPropertyInputSourceID];
    CFArrayRef keyboards = TISCreateInputSourceList((__bridge CFDictionaryRef) filter, false);
    if (keyboards) {
        TISInputSourceRef selected = (TISInputSourceRef) CFArrayGetValueAtIndex(keyboards, 0);
        TISSelectInputSource(selected);
        CFRelease(keyboards);
    }
}

void active(){
    switch_to(CHINESE_KEYBOARD_LAYOUT);
}

void inactive(){
    switch_to(US_KEYBOARD_LAYOUT);
}

NSString* get_current_imname(){
    TISInputSourceRef current = TISCopyCurrentKeyboardInputSource();
    return (__bridge NSString *) (TISGetInputSourceProperty(current, kTISPropertyInputSourceID));
}

int get_status(){
    NSString *sourceId = get_current_imname();
    if([sourceId isEqualToString:US_KEYBOARD_LAYOUT]){
        return INACTIVE;
    }else{
        return ACTIVE;
    }
}

void print_status(int status){
    if(status == INACTIVE){
        puts(INACTIVE_STR);
    }else if(status == ACTIVE){
        puts(ACTIVE_STR);
    }
}

void switch_between_active_inactive(){
    if(get_status() == ACTIVE){
        inactive();
    }else{
        active();
    }
}

void print_help(){
    printf("Usage: fcitx-remote [OPTION]\n"
            "\t-c\t\tdeactivate input method\n"
            "\t-o\t\tactivate input method\n"
            "\t-t\t\tswitch Active/Inactive\n"
            "\t-s <imname>\tswitch to the input method uniquely identified by <imname>\n"
            "\t[no option]\tdisplay fcitx state, %d for inactive, %d for acitve\n"
            "\t-h\t\tdisplay this help and exit\n"
            "\t-n\t\tdisplay current imname\n",
            INACTIVE, ACTIVE);
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc> 1) {
            NSString *method = [NSString stringWithUTF8String:argv[1]];
            if([method isEqualToString:@"-o"]){
                active();
            }else if([method isEqualToString:@"-c"]){
                inactive();
            }else if([method isEqualToString:@"-t"]){
                switch_between_active_inactive();
            }else if([method isEqualToString:@"-s"]){
                switch_to([NSString stringWithUTF8String:argv[2]]);
            }else if([method isEqualToString:@"-h"]){
                print_help();
            }else if([method isEqualToString:@"-n"]){
                printf("%s\n", get_current_imname().UTF8String);
            }
        } else {
            print_status(get_status());
        }

    }

    return 0;
}
