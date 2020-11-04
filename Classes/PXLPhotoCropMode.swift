//
//  PXLPhotoCropMode.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 09. 21..
//

import AVFoundation
import UIKit

public enum PXLPhotoCropMode {
    case centerFill // Preserve aspect ratio; fill layer bounds.
    case centerFit // Preserve aspect ratio; fit within layer bounds.
    case resize // Stretch to fill layer bounds.

    public var asImageContentMode: UIView.ContentMode {
        switch self {
        case .centerFill:
            return UIView.ContentMode.scaleAspectFill
        case .centerFit:
            return UIView.ContentMode.scaleAspectFit
        case .resize:
            return UIView.ContentMode.scaleToFill
        }
    }

    public var asVideoContentMode: AVLayerVideoGravity {
        switch self {
        case .centerFill:
            return AVLayerVideoGravity.resizeAspectFill
        case .centerFit:
            return AVLayerVideoGravity.resizeAspect
        case .resize:
            return AVLayerVideoGravity.resize
        }
    }
}
