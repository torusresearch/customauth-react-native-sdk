#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(RNCustomAuthSdk, NSObject)

_RCT_EXTERN_REMAP_METHOD(init, initialize: (NSDictionary)params, false)

RCT_EXTERN_METHOD(
                  initialize: (NSDictionary)params
                  )

RCT_EXTERN_METHOD(
                  triggerLogin: (NSDictionary)params
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
                  )

RCT_EXTERN_METHOD(
                  triggerAggregateLogin: (NSDictionary)params
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
                  )

RCT_EXTERN_METHOD(
                  handle: (NSString)url
                  )

RCT_EXTERN_METHOD(
                  getTorusKey: (NSString)verifier
                  verifierId: (NSString)verifierid
                  verifierParams: (NSDictionary)verifierParams
                  idToken: (NSString)idToken
                  extraParams: (NSDictionary)extraParams
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
                  )

RCT_EXTERN_METHOD(
                  getAggregateTorusKey: (NSString)verifier
                  verifierId: (NSString)verifierid
                  subVerifierInfoArray: (NSArray)subVerifierInfoArray
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject
                  )

@end

