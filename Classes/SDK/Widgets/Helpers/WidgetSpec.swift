//
//  WidgetSpec.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 4/19/21.
//

import Foundation
public enum WidgetSpec {
    open class WidgetDefault {
        public init(cellHeight: CGFloat) {
            self.cellHeight = cellHeight
        }
        
        let cellHeight: CGFloat
    }
    
    open class List:WidgetDefault {
        public init(cellHeight: CGFloat, isVideoMutted: Bool, autoVideoPlayEnabled: Bool, loadMore: LoadMore) {
            self.isVideoMutted = isVideoMutted
            self.autoVideoPlayEnabled = autoVideoPlayEnabled
            self.loadMore = loadMore
            super.init(cellHeight: cellHeight)
        }
        
        let isVideoMutted: Bool
        let autoVideoPlayEnabled: Bool
        let loadMore: LoadMore
    }
    
    open class Grid: WidgetDefault {
        public init(cellHeight: CGFloat, cellPadding: CGFloat, loadMore: LoadMore, header: Header?) {
            self.cellPadding = cellPadding
            self.loadMore = loadMore
            self.header = header
            super.init(cellHeight: cellHeight)
        }
        
        let header: Header?
        //func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto)
        //func cellsHighlighted(cells: [PXLGridViewCell])
        //func onPhotoClicked(photo: PXLPhoto)
        //func scrollViewDidScroll(_ scrollView: UIScrollView)
        //func onPhotoButtonClicked(photo: PXLPhoto)
        let cellPadding: CGFloat
        let loadMore: LoadMore
    }

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
}
