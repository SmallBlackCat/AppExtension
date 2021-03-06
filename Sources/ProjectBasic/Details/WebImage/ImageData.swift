//
//  ImageData.swift
//  SNKit
//
//  Created by ZJaDe on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
#if canImport(RxOptional)
import RxOptional
extension ImageData: Occupiable {}
#endif
public enum ImageData: Codable {
    case image(UIImage?)
    case url(ImageURLProtocol?)

    public var urlData: String? {
        switch self {
        case .url(let imageData):
            return imageData?.url?.absoluteString
        case .image:
            return nil
        }
    }
    public var image: UIImage? {
        switch self {
        case .url:
            return nil
        case .image(let image):
            return image
        }
    }
    public var isEmpty: Bool {
        self.image == nil && self.urlData == nil
    }
    // MARK: - Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.urlData)
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(URL.self) {
            self = .url(value)
        } else if let value = try? container.decode(String.self) {
            if value.hasPrefix("ic_") {
                self = .image(UIImage(named: value, in: Bundle.main, compatibleWith: nil))
            } else {
                self = .url(value)
            }
            self = .url(value)
        } else {
            self = .url(nil)
        }
    }
}
extension ImageData: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .url(value)
    }
}
extension ImageData {
    public static var userDefault: UIImage = {
        UIImage(named: "ic_default_userImg") ?? ImageData.default
    }()
    public static var userFailure: UIImage = {
        UIImage(named: "ic_default_userImg") ?? ImageData.failure
    }()
    public static var failure: UIImage = {
        UIImage(named: "ic_default_image_failure") ?? ImageData.default
    }()
    public static var `default`: UIImage = {
        UIImage(named: "ic_default_image")!
    }()
}
