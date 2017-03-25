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
#define CHINESE_KEYBOARD_LAYOUT @"com.sogou.inputmethod.sogou.pinyin"
#endif

#define GENERAL_KEYBOARD_LAYOUT @"GENERAL"

void runScript(NSString* scriptText)
{
    NSDictionary *error = nil;
    NSAppleEventDescriptor *appleEventDescriptor;
    NSAppleScript *appleScript;
    appleScript = [[NSAppleScript alloc] initWithSource:scriptText];
    appleEventDescriptor = [appleScript executeAndReturnError:&error];
}

NSString* get_current_imname(){
    TISInputSourceRef current = TISCopyCurrentKeyboardInputSource();
    return (__bridge NSString *) (TISGetInputSourceProperty(current, kTISPropertyInputSourceID));
}

void switch_to(NSString* imId){
    if ([GENERAL_KEYBOARD_LAYOUT isEqualToString:CHINESE_KEYBOARD_LAYOUT]) {
        if ([get_current_imname() isEqualToString:imId]) {
            return;
        }
        // use ctrl-shift-z to change input method
        // slow but ensure to work
        runScript(@"tell application \"System Events\" to keystroke \"z\" using {shift down, control down}");
        return;
        
        // faster but not reliable
        /*
        CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
        CGEventRef down = CGEventCreateKeyboardEvent(source, kVK_ANSI_Z, true);
        CGEventRef up = CGEventCreateKeyboardEvent(source, kVK_ANSI_Z, false);
        
        int flag = kCGEventFlagMaskShift | kCGEventFlagMaskControl;
        CGEventSetFlags(down, flag);
        CGEventSetFlags(up, flag);
        CGEventPost(kCGHIDEventTap, down);
        CGEventPost(kCGHIDEventTap, up);
        return;
         */
    }
    
    // slow but ensure to work
    // Idea from https://github.com/noraesae/kawa/blob/master/kawa/InputSourceManager.swift#L55
    CFArrayRef keyboards = TISCreateInputSourceList(nil, false);
    if (keyboards) {
        NSArray *array = CFBridgingRelease(keyboards);
        NSArray *filteredArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
            TISInputSourceRef inputSource = (__bridge TISInputSourceRef)(object);
            CFStringRef category = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceCategory);
            CFBooleanRef selectable = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceIsSelectCapable);
            return CFEqual(category, kTISCategoryKeyboardInputSource) && CFBooleanGetValue(selectable);
        }]];
        int index = 0,i = 0, us = 0;
        for (id object in filteredArray) {
            TISInputSourceRef inputSource = (__bridge TISInputSourceRef)(object);
            NSString *name = (__bridge NSString*)TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID);
            NSLog(@"%@", name);
            if ([name isEqualTo: imId]) {
                index = i;
            }
            if ([name isEqualTo: US_KEYBOARD_LAYOUT]) {
                us = i;
            }
            i++;
        }
        
        NSString *current = get_current_imname();
        if (![current isEqualTo: US_KEYBOARD_LAYOUT]) {
            TISInputSourceRef inputSource = (__bridge TISInputSourceRef)filteredArray[us];
            NSString *name = (__bridge NSString*)TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID);
            NSLog(@"%d %@", us, name);
            TISSelectInputSource((__bridge TISInputSourceRef)filteredArray[index]);

        }
        
        int diff = (us - index + i) % i;
        for (int j = 0;j < diff;j++) {
            CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
            CGEventRef down = CGEventCreateKeyboardEvent(source, kVK_Space, true);
            CGEventRef up = CGEventCreateKeyboardEvent(source, kVK_Space, false);
            
            int flag = kCGEventFlagMaskAlternate | kCGEventFlagMaskControl;
            CGEventSetFlags(down, flag);
            CGEventSetFlags(up, flag);
            CGEventPost(kCGHIDEventTap, down);
            CGEventPost(kCGHIDEventTap, up);
            
            [NSThread sleepForTimeInterval:0.05f];
        }
    }
}

void active(){
    switch_to(CHINESE_KEYBOARD_LAYOUT);
}

void inactive(){
    switch_to(US_KEYBOARD_LAYOUT);
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
                if (argc > 2) {
                    switch_to([NSString stringWithUTF8String:argv[2]]);
                } else {
                    print_help();
                }
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
