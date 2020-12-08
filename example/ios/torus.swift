//
//  torus.swift
//  example
//
//  Created by Shubham on 7/12/20.
//

import Foundation
import RNTorusDirectSdk

@available(iOS 11.0, *)
@objc class HandleRedirect: NSObject{
  @objc class func handle(_ string: String){
    RNTorusDirectSdk.handle(string)
  }
}
