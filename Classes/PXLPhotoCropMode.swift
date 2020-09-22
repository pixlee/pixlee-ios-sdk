//
//  PXLPhotoCropMode.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 21..
//

import AVFoundation
import UIKit

public enum PXLPhotoCropMode {
    case centerFill
    case centerFit
    case resizeAspect

    public var asImageContentMode: UIView.ContentMode {
        switch self {
        case .centerFill:
            return UIView.ContentMode.scaleAspectFill
        case .centerFit:
            return UIView.ContentMode.scaleAspectFit
        case .resizeAspect:
            return UIView.ContentMode.scaleToFill
        }
    }

    public var asVideoContentMode: AVLayerVideoGravity {
        switch self {
        case .centerFill:
            return AVLayerVideoGravity.resizeAspectFill
        case .centerFit:
            return AVLayerVideoGravity.resize
        case .resizeAspect:
            return AVLayerVideoGravity.resizeAspect
        }
    }
}
