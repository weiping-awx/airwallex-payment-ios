//
//  AWXCardCVCViewController.h
//  Airwallex
//
//  Created by Victor Zhu on 2020/1/16.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import "AWXDefaultProvider.h"
#import "AWXPaymentResultDelegate.h"
#import "AWXViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AWXCardCVCViewController` provides a confirm button for user to finish checkout flow with payment consent.
 */
@interface AWXCardCVCViewController : AWXViewController

/**
 A delegate which handles confirmed payment intent.
 */
@property (nonatomic, weak) id<AWXPaymentResultDelegate> delegate;

/**
 A payment consent.
 */
@property (nonatomic, strong) AWXPaymentConsent *paymentConsent;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
