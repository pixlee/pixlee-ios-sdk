//
//  HotspotReader.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 5/20/21.
//

import Foundation

class HotspotsReader {
    let imageScaleType: PXLPhotoCropMode
    let screenWidth: Int
    let screenHeight: Int
    let contentWidth: Int
    let contentHeight: Int
    
    let topPadding: Int
    let leftPadding: Int
    let contentScreenWidth: Int
    let contentScreenHeight: Int

    init(imageScaleType: PXLPhotoCropMode, screenWidth: Int, screenHeight: Int, contentWidth: Int, contentHeight: Int) {
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
            contentScreenHeight = Int(Float(screenWidth) * viewRatio)
        } else {
            // content's ratio is taller than screen's ratio.
            contentScreenWidth = Int(Float(screenHeight) * (Float(contentWidth) / Float(contentHeight)))
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
        let x = contentScreenWidth * (pxlBoundingBoxProduct.x + (leftThird)) / contentWidth
        let y = contentScreenHeight * (pxlBoundingBoxProduct.y + (topThird)) / contentHeight

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
