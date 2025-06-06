//
//  AWXRedirectActionProvider.m
//  Airwallex
//
//  Created by Victor Zhu on 2021/8/24.
//  Copyright © 2021 Airwallex. All rights reserved.
//

#import "AWXRedirectActionProvider.h"
#import "AWXAnalyticsLogger.h"
#import "AWXPaymentIntentResponse.h"
#import "AWXUtils.h"
#import "NSObject+Logging.h"

@implementation AWXRedirectActionProvider

- (void)handleNextAction:(AWXConfirmPaymentNextAction *)nextAction {
    if ([self.delegate respondsToSelector:@selector(provider:shouldPresentViewController:forceToDismiss:withAnimation:)]) {
        [self.delegate provider:self shouldPresentViewController:nil forceToDismiss:YES withAnimation:YES];
    }

    NSURL *url = [NSURL URLWithString:nextAction.url];
    if (url) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                     if (success) {
                                         [self handleRedirectionSuccess:url];
                                     } else {
                                         NSURL *fallbackUrl = [NSURL URLWithString:nextAction.fallbackUrl];
                                         if (fallbackUrl) {
                                             [[UIApplication sharedApplication] openURL:fallbackUrl
                                                 options:@{}
                                                 completionHandler:^(BOOL fallbackSuccess) {
                                                     if (fallbackSuccess) {
                                                         [self handleRedirectionSuccess:fallbackUrl];
                                                     } else {
                                                         [self handleRedirectionFail:fallbackUrl];
                                                     }
                                                 }];
                                         } else {
                                             [self handleRedirectionFail:url];
                                         }
                                     }
                                 }];
    }
}

- (void)confirmPaymentIntentWithPaymentMethodName:(NSString *)paymentMethodName {
    [self confirmPaymentIntentWithPaymentMethodName:paymentMethodName additionalInfo:nil flow:AWXPaymentMethodFlowApp];
}

- (void)confirmPaymentIntentWithPaymentMethodName:(NSString *)paymentMethodName additionalInfo:(NSDictionary<NSString *, NSString *> *)additionalInfo {
    [self confirmPaymentIntentWithPaymentMethodName:paymentMethodName additionalInfo:additionalInfo flow:AWXPaymentMethodFlowApp];
}

- (void)confirmPaymentIntentWithPaymentMethodName:(NSString *)paymentMethodName flow:(AWXPaymentMethodFlow)flow {
    [self confirmPaymentIntentWithPaymentMethodName:paymentMethodName additionalInfo:nil flow:flow];
}

- (void)confirmPaymentIntentWithPaymentMethodName:(NSString *)paymentMethodName
                                   additionalInfo:(NSDictionary<NSString *, NSString *> *_Nullable)additionalInfo
                                             flow:(AWXPaymentMethodFlow)flow {
    AWXPaymentMethod *paymentMethod = [[AWXPaymentMethod alloc] init];
    paymentMethod.type = paymentMethodName;
    paymentMethod.additionalParams = additionalInfo;
    [self confirmPaymentIntentWithPaymentMethod:paymentMethod paymentConsent:nil flow:flow];
}

#pragma mark - Private methods

- (void)handleRedirectionSuccess:(NSURL *)url {
    [self.delegate provider:self didCompleteWithStatus:AirwallexPaymentStatusInProgress error:nil];
    [self log:@"Delegate: %@, provider:didCompleteWithStatus:error:  %lu", self.delegate.class, AirwallexPaymentStatusInProgress];
    [[AWXAnalyticsLogger shared] logPageViewWithName:@"payment_redirect" additionalInfo:@{@"url": url.absoluteString}];
}

- (void)handleRedirectionFail:(NSURL *)url {
    NSDictionary *info = @{
        NSLocalizedDescriptionKey: @"Redirect to app failed.",
        NSURLErrorKey: url.absoluteString
    };
    NSError *error = [NSError errorWithDomain:AWXSDKErrorDomain
                                         code:-1
                                     userInfo:info];
    [self.delegate provider:self didCompleteWithStatus:AirwallexPaymentStatusFailure error:error];
    [self log:@"Delegate: %@, provider:didCompleteWithStatus:error:  %lu  %@", self.delegate.class, AirwallexPaymentStatusFailure, error.description];
    [[AWXAnalyticsLogger shared] logErrorWithName:@"payment_redirect" additionalInfo:info];
}

@end
