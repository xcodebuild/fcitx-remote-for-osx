//
//  main.m
//  fcitx-remote
//
//  Created by codefalling on 15/11/2.
//  Copyright (c) 2015 codefalling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <unistd.h>
#include <fcntl.h>
#include <poll.h>
#include <limits.h>

#define INACTIVE 1
#define ACTIVE 2

#define INACTIVE_STR "1"
#define ACTIVE_STR "2"

#define CMD_GET_STATUS 0
#define CMD_INACTIVATE_ACTIVATE 1
#define CMD_SWITCH_BETWEEN 3
#define CMD_SWITCH_TO 4

#ifndef US_KEYBOARD_LAYOUT
    #define US_KEYBOARD_LAYOUT @"com.apple.keylayout.US"
#endif

#ifndef CHINNESE_KEYBOARD_LAYOUT
    #define CHINNESE_KEYBOARD_LAYOUT @"com.sogou.inputmethod.sogou.pinyin"
#endif


int create_socket(const char *name)
{
    int fd;
    int r;
    struct sockaddr_un uds_addr;
    fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) {
        return fd;
    }
    /* setup address struct */
    memset(&uds_addr, 0, sizeof(uds_addr));
    uds_addr.sun_family = AF_UNIX;
    strcpy(uds_addr.sun_path, name);
    r = connect(fd, (struct sockaddr *) & uds_addr, sizeof(uds_addr));
    if (r < 0) {
        return r;
    }
    return fd;
}


void switch_to(NSString* imId){
    NSDictionary *filter = [NSDictionary dictionaryWithObject:imId forKey:(NSString *) kTISPropertyInputSourceID];
    CFArrayRef keyboards = TISCreateInputSourceList((__bridge CFDictionaryRef) filter, false);
    if (keyboards) {
        TISInputSourceRef selected = (TISInputSourceRef) CFArrayGetValueAtIndex(keyboards, 0);
        TISSelectInputSource(selected);
        CFRelease(keyboards);
    }
}

void active(){
    switch_to(CHINNESE_KEYBOARD_LAYOUT);
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
                    "\t-c\t\tinactivate input method\n"
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
        char *socketfile = NULL;
        int socket_fd;

        asprintf(&socketfile, "/tmp/fcitx-socket-:%d", 1);
        socket_fd = create_socket(socketfile);
        if (socket_fd < 0) {
            fprintf(stderr, "Can't open socket %s: %s\n", socketfile, strerror(errno));
            free(socketfile);
            return 1;
        }
        free(socketfile);

        if (argc > 1) {
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
                printf("%s", get_current_imname().cString);
            }
        } else {
            print_status(get_status());
        }



        return 0;

    }


}