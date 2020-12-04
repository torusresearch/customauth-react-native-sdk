#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE (RNSubVerifierDetails, NSObject)

RCT_EXTERN_METHOD(
                  init2: (NSString)loginType
                  loginProvider: (NSString)loginProvider
                  clientId: (NSString)clientId
                  subverifierId: (NSString)subverifierId
                  redirectURL: (NSString)redirectURL
                  extraQueryParams: (NSDictionary<NSString *, NSString *>)extraQueryParams
                  jwtParams: (NSDictionary<NSString *, NSString *>)jwtParams
                  )
@end

@interface RCT_EXTERN_MODULE(RNTorusSwiftDirectSDK, NSObject)

RCT_EXTERN_METHOD(
                  addSubverifier: (NSString)loginType
                  loginProvider: (NSString)loginProvider
                  clientId: (NSString)clientId
                  subverifierId: (NSString)subverifierId
                  redirectURL: (NSString)redirectURL
                  extraQueryParams: (NSDictionary)extraQueryParams
                  jwtParams: (NSDictionary)jwtParams
                  )

RCT_EXTERN_METHOD(
                  init2: (NSString)aggregateVerifierType
                  aggregateVerifierName: (NSString)aggregateVerifierName
                  loglevel: (NSInteger)loglevel
                  )

RCT_EXTERN_METHOD(
                  triggerLogin: (RCTResponseSenderBlock)callback
                  )

RCT_EXTERN_METHOD(
                  handle: (NSString)url
                  )

@end


