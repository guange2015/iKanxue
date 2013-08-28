//
//  Api.m
//  iRuby
//
//  Created by xiaoguang huang on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Api.h"

@implementation Api
+(int)hashCode:(NSString*)str{
	if(str==NULL){
		return 0;
	}
	int len=[str length];
	int r=0;
	for(int i=0;i<len;i++){
		int c=[str characterAtIndex:i]&0xFFFF;
		r=r*31+c;
	}
	return r;
}

@end
