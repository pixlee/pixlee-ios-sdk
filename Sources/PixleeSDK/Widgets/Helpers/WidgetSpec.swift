//
//  WidgetSpec.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 4/19/21.
//

import Foundation
import UIKit

public enum MosaicSpan{
    case three
    case four
    case five;
}

public enum WidgetSpec {
    open class List {
        public init(cellHeight: CGFloat, isVideoMutted: Bool, autoVideoPlayEnabled: Bool, loadMore: LoadMore) {
            self.isVideoMutted = isVideoMutted
            self.autoVideoPlayEnabled = autoVideoPlayEnabled
            self.loadMore = loadMore
            self.cellHeight = cellHeight
        }
        
        let isVideoMutted: Bool
        let autoVideoPlayEnabled: Bool
        let loadMore: LoadMore
        let cellHeight: CGFloat
    }
    
    open class Grid {
        public init(cellHeight: CGFloat, cellPadding: CGFloat, loadMore: LoadMore, header: Header?) {
            self.cellPadding = cellPadding
            self.loadMore = loadMore
            self.header = header
            self.cellHeight = cellHeight
        }
        
        let header: Header?
        let cellPadding: CGFloat
        let loadMore: LoadMore
        let cellHeight: CGFloat
    }

    
    open class Mosaic {
        public init(mosaicSpan: MosaicSpan, cellPadding: CGFloat, loadMore: LoadMore) {
            self.mosaicSpan = mosaicSpan
            self.cellPadding = cellPadding
            self.loadMore = loadMore
        }
        
        let mosaicSpan: MosaicSpan
        let cellPadding: CGFloat
        let loadMore: LoadMore
    }

    // Foot UI: LoadMore Button with an IndicatorView
    open class LoadMore {
        public init(cellHeight: CGFloat, cellPadding: CGFloat, text: String, textColor: UIColor, textFont: UIFont, loadingStyle: UIActivityIndicatorView.Style) {
            self.cellHeight = cellHeight
            self.cellPadding = cellPadding
            self.text = text
            self.textColor = textColor
            self.textFont = textFont
            self.loadingStyle = loadingStyle
        }

        let cellHeight: CGFloat
        let cellPadding: CGFloat
        let text:String
        let textColor: UIColor
        let textFont: UIFont
        let loadingStyle: UIActivityIndicatorView.Style
    }

    // Header UI
    public enum Header {
        case text(Text)
        case image(Image)
        
        open class HeaderDefault {
            public init(headerHeight: CGFloat, headerContentMode: UIView.ContentMode) {
                self.headerHeight = headerHeight
                self.headerContentMode = headerContentMode
            }
            
            let headerHeight: CGFloat
            let headerContentMode: UIView.ContentMode
        }

        // Text Header
        open class Text: HeaderDefault {
            public init(headerHeight: CGFloat, headerContentMode: UIView.ContentMode, headerTitle: String?, headerTitleFont: UIFont, headerTitleColor: UIColor) {
                self.headerTitle = headerTitle
                self.headerTitleFont = headerTitleFont
                self.headerTitleColor = headerTitleColor
                super.init(headerHeight: headerHeight, headerContentMode: headerContentMode)
            }
            
            let headerTitle: String?
            let headerTitleFont: UIFont
            let headerTitleColor: UIColor
        }

        // Image Header
        public enum Image {
            case localPath(LocalPath)
            case remotePath(RemotePath)

            open class LocalPath: HeaderDefault {
                public init(headerHeight: CGFloat, headerContentMode: UIView.ContentMode, headerGifName: String?) {
                    self.headerGifName = headerGifName
                    super.init(headerHeight: headerHeight, headerContentMode: headerContentMode)
                }
                
                let headerGifName: String?
            }
            open class RemotePath: HeaderDefault {
                public init(headerHeight: CGFloat, headerContentMode: UIView.ContentMode, headerGifUrl: String?) {
                    self.headerGifUrl = headerGifUrl
                    super.init(headerHeight: headerHeight, headerContentMode: headerContentMode)
                }
                
                let headerGifUrl: String?
            }
        }
    }
    case list(List)
    case grid(Grid)
    case mosaic(Mosaic)
}
