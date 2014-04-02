//
//  SoundsUtil.m
//  Suitcase
//
//  Created by 罗若峰 on 13-11-8.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "SoundsUtil.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ConfigUtil.h"

@implementation SoundsUtil

static SoundsUtil *soundsUtil = nil;
SystemSoundID mysound;
+ (id)shareSoundsUtil
{
    @synchronized(self)
    {
        if(!soundsUtil)
        {
            soundsUtil = [[SoundsUtil alloc] init];
        }
        return soundsUtil;
    }
}

- (void)playSounds:(NSString*)sounds
{
    if(![[ConfigUtil shareConfigUtil] getBoolValueWithKey:SOUNDS_VALUES])
    {
        return;
    }
    
    NSString *sndpath = [[NSBundle mainBundle] pathForResource:sounds ofType:@"wav"];
	CFURLRef baseURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndpath];
	
	// Identify it as not a UI Sound
    AudioServicesCreateSystemSoundID(baseURL, &mysound);
	AudioServicesPropertyID flag = 0;  // 0 means always play
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &mysound, sizeof(AudioServicesPropertyID), &flag);
    [self playSound];

//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playSound
{
    if ([MPMusicPlayerController iPodMusicPlayer].playbackState ==  MPMusicPlaybackStatePlaying)
		AudioServicesPlayAlertSound(mysound);
	else
		AudioServicesPlaySystemSound(mysound);
}

@end
