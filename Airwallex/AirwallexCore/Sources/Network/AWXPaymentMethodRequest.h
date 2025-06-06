//
//  AWXPaymentMethodRequest.h
//  Airwallex
//
//  Created by Victor Zhu on 2020/2/4.
//  Copyright © 2020 Airwallex. All rights reserved.
//

#import "AWXAPIClient.h"
#import "AWXConstants.h"
#import "AWXPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `AWXGetPaymentMethodsRequest` includes all of the parameters needed to get payment methods.
 */
@interface AWXGetPaymentMethodsRequest : AWXRequest

/**
 Customer ID.
 */
@property (nonatomic, copy, nullable) NSString *customerId;

/**
 Page number starting from 0.
 */
@property (nonatomic) NSInteger pageNum;

/**
 Number of payment methods to be listed per page.
 */
@property (nonatomic) NSInteger pageSize;

/**
 Payment method type.
 */
@property (nonatomic, copy, nullable) NSString *methodType;

/**
 Card type.
 */
@property (nonatomic, copy, nullable) NSString *cardType;

/**
 The start time of created_at in ISO8601 format.
 */
@property (nonatomic, copy, nullable) NSString *fromCreatedAt;

/**
 The end time of created_at in ISO8601 format
 */
@property (nonatomic, copy, nullable) NSString *toCreatedAt;

@end

/**
 `AWXGetPaymentMethodTypesRequest` includes all of the parameters needed to get payment method types.
 */
@interface AWXGetPaymentMethodTypesRequest : AWXRequest

/**
 active .
 */
@property (nonatomic) BOOL active;
/**
 Page number starting from 0.
 */
@property (nonatomic) NSInteger pageNum;

/**
 Number of payment methods to be listed per page.
 */
@property (nonatomic) NSInteger pageSize;

/**
 A currency code.
 */
@property (nonatomic, copy, nullable) NSString *transactionCurrency;

/**
 Transaction code.
 */
@property (nonatomic, copy, nullable) NSString *transactionMode;

/**
 Country code.
 */
@property (nonatomic, copy, nullable) NSString *countryCode;

/**
 Whether it requres resources
 */
@property (nonatomic) BOOL resources;

/**
 Lang
 */
@property (nonatomic, copy, nullable) NSString *lang;

/**
 Filter payment methods for a specific flow. Defaults to inapp.
 */
@property (nonatomic, copy, nullable) NSString *flow;

@end

/**
 `AWXGetPaymentMethodTypeRequest` includes all of the parameters needed to get payment method type.
 */
@interface AWXGetPaymentMethodTypeRequest : AWXRequest

/**
 Name of the payment method type
 */
@property (nonatomic, copy) NSString *name;

/**
 Flow.
 */
@property (nonatomic, copy, nullable) NSString *flow;

/**
 Transaction code.
 */
@property (nonatomic, copy, nullable) NSString *transactionMode;

/**
 Lang
 */
@property (nonatomic, copy, nullable) NSString *lang;

@end

/**
 `AWXGetPaymentMethodTypeRequest` includes all of the parameters needed to get payment method type.
 */
@interface AWXGetAvailableBanksRequest : AWXRequest

/**
 Name of the payment method type
 */
@property (nonatomic, copy) NSString *paymentMethodType;

/**
 Flow.
 */
@property (nonatomic, copy, nullable) NSString *countryCode;

/**
 Lang
 */
@property (nonatomic, copy, nullable) NSString *lang;

@end

/**
 `AWXCreatePaymentMethodRequest` includes all of the parameters needed to create a payment method.
 */
@interface AWXCreatePaymentMethodRequest : AWXRequest

/**
 Payment method object.
 */
@property (nonatomic, strong) AWXPaymentMethod *paymentMethod;

@end

/**
 `AWXDisablePaymentMethodRequest` disable a payment method.
 */
@interface AWXDisablePaymentConsentRequest : AWXRequest

/**
 Payment method id.
 */
@property (nonatomic, strong) NSString *Id;

@end

NS_ASSUME_NONNULL_END
