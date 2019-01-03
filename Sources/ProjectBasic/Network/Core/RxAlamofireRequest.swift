//
//  RxAlamofireResponse.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
protocol RxAlamofireRequest {
    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void)
    func resume()
    func cancel()
}
protocol RxAlamofireResponse {
    var error: Error? {get}
}

extension DefaultDataResponse: RxAlamofireResponse {}
extension DefaultDownloadResponse: RxAlamofireResponse {}

extension DataRequest: RxAlamofireRequest {
    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
        response { (response) in
            completionHandler(response)
        }
    }
}
extension DownloadRequest: RxAlamofireRequest {
    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
        response { (response) in
            completionHandler(response)
        }
    }
}
