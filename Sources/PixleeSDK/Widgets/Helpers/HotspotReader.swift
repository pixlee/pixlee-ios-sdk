//
//  HotspotReader.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 5/20/21.
//

import Foundation
import UIKit
class HotspotsReader {
    let imageScaleType: PXLPhotoCropMode
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let contentWidth: CGFloat
    let contentHeight: CGFloat
    
    let topPadding: CGFloat
    let leftPadding: CGFloat
    let contentScreenWidth: CGFloat
    let contentScreenHeight: CGFloat

    public init(imageScaleType: PXLPhotoCropMode, screenWidth: CGFloat, screenHeight: CGFloat, contentWidth: CGFloat, contentHeight: CGFloat) {
        self.imageScaleType = imageScaleType
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.contentWidth = contentWidth
        self.contentHeight = contentHeight
        
        let screenRatio = Float(screenHeight) / Float(screenWidth)
        let viewRatio = Float(contentHeight) / Float(contentWidth)

        // calculate content's with and height based on ImageSaleType and the ratios of the screen and content
        if ((imageScaleType == PXLPhotoCropMode.centerFit && viewRatio < screenRatio) ||
                (imageScaleType == PXLPhotoCropMode.centerFill && viewRatio > screenRatio)) {
            // content's ratio is shorter than screen's ratio.
            contentScreenWidth = screenWidth
            contentScreenHeight = CGFloat(Float(screenWidth) * viewRatio)
        } else {
            // content's ratio is taller than screen's ratio.
            contentScreenWidth = CGFloat(Float(screenHeight) * (Float(contentWidth) / Float(contentHeight)))
            contentScreenHeight = screenHeight
        }

        // calculate paddings
        topPadding = (screenHeight - contentScreenHeight) / 2
        leftPadding = (screenWidth - contentScreenWidth) / 2
    }

    func getHotspotsPosition(pxlBoundingBoxProduct: BoundingBoxProduct) -> HotspotPosition {
        // Pixlee photos draw Hotspot at 1/3 position of the bounding_box's with and height
        let leftThird = pxlBoundingBoxProduct.width / 3
        let topThird = pxlBoundingBoxProduct.height / 3

        // convert the [x, y] to be displayed inside the content size of the screen
        let x = contentScreenWidth * (CGFloat(pxlBoundingBoxProduct.x) + (CGFloat(leftThird))) / contentWidth
        let y = contentScreenHeight * (CGFloat(pxlBoundingBoxProduct.y) + (CGFloat(topThird))) / contentHeight

        // return it with paddings
        return HotspotPosition(
            x: Float(x + leftPadding),
            y: Float(y + topPadding)
        )
    }
}


class HotspotPosition {
    let x: Float
    let y: Float

    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}
