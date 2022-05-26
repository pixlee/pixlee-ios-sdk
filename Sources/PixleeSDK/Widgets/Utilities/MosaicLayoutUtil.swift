//
//  MosaicLayoutUtil.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 5/23/22.
//

import Foundation

class MosaicLayoutUtil {
    var layout: UICollectionViewCompositionalLayout? = nil
    
    func create (mosaicSpan: MosaicSpan? = .four, cellPadding: CGFloat) -> UICollectionViewLayout {
        let isLandscape = mosaicSpan == nil
        let list: [MosaicInfo] = {
            if isLandscape {
                return get1SpanHorizontalList(cellPadding: cellPadding)
            } else {
                switch(mosaicSpan!) {
                case .three:
                    return get3SpanList(cellPadding: cellPadding)
                case .four:
                    return get4SpanList(cellPadding: cellPadding)
                case .five:
                    return get5SpanList(cellPadding: cellPadding)
                }
            }
        }()
        
        
        var array = [NSCollectionLayoutGroup]()
        
        var heightRatio: CGFloat = 0
        
        for i in 0...(list.count * 2) {
            if let item = list.randomElement() {
                heightRatio = heightRatio + item.heightRatio
                print("===== item.heightRatio: \(item.heightRatio)")
                array.append(item.collectionLayoutGroup)
            }
        }
        
        let megaGroup: NSCollectionLayoutGroup = {
            if isLandscape {
                return NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(heightRatio), heightDimension: .fractionalHeight(1)),
                    subitems: array)
            } else {
                return NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(heightRatio)),
                    subitems: array)
            }
        }()
        
        
        let section = NSCollectionLayoutSection(group: megaGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let headerFooterSize: NSCollectionLayoutSize = {
            if isLandscape {
                return NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
            } else {
                return NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
            }
        }()
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: {
                if isLandscape{
                    return NSRectAlignment.trailing
                } else {
                    return NSRectAlignment.bottom
                }
            }()
        )
        
        section.boundarySupplementaryItems = [footer]
        
        
        if layout == nil {
            layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
                return section
            }
        }
        
        if isLandscape {
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.scrollDirection = .horizontal
            layout?.configuration = config
        }
        
        return layout!
        
    }
    
    func generateMosaicInfo(heightRatio: CGFloat, subItems: [NSCollectionLayoutItem]) -> MosaicInfo {
        return MosaicInfo(heightRatio: heightRatio , collectionLayoutGroup: NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(heightRatio)),
            subitems: subItems))
    }
    
    func get1SpanHorizontalList(cellPadding: CGFloat) -> [MosaicInfo] {
        let originalSizeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1)))
        originalSizeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        return [
            MosaicInfo(heightRatio: 1 , collectionLayoutGroup: NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1)),
                subitems: [originalSizeItem])),
        ]
    }
    
    func get3SpanList(cellPadding: CGFloat) -> [MosaicInfo] {
        let fractionalSize1 = CGFloat(1.0) / CGFloat(3.0)
        let fractionalSize2 = CGFloat(1.0) / CGFloat(3.0) * CGFloat(2.0)
        let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize2), heightDimension: .fractionalWidth(fractionalSize2)))
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let originalSizeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        originalSizeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize1), heightDimension: .fractionalWidth(fractionalSize1)))
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let twoVerticalItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize1), heightDimension: .fractionalWidth(fractionalSize2)),
                                                                subitems: [originalSizeItem])
        
        return [
            generateMosaicInfo(heightRatio: fractionalSize1, subItems: [smallItem]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [twoVerticalItems, largeItem]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [largeItem, twoVerticalItems]),
        ]
    }
    
    func get4SpanList(cellPadding: CGFloat) -> [MosaicInfo] {
        let halfSizeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
        halfSizeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let originalSizeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        originalSizeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let twoItemsHorizontal = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5)),
                                                                    subitems: [smallItem])
        
        let fourItemsHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.25)),
                                                                          subitems: [smallItem])
        
        let twoVerticalItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalWidth(0.5)),
                                                                subitems: [originalSizeItem])
        
        return [
            generateMosaicInfo(heightRatio: 1.5, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.5)),
                                                                                             subitems: [originalSizeItem, originalSizeItem, originalSizeItem]),
                                                            NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.5)),
                                                                                             subitems: [twoItemsHorizontal, originalSizeItem, originalSizeItem, twoItemsHorizontal])]),
            
            generateMosaicInfo(heightRatio: 1.5, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.5)),
                                                                                             subitems: [originalSizeItem, originalSizeItem, originalSizeItem]),
                                                            NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.5)),
                                                                                             subitems: [twoItemsHorizontal, originalSizeItem, originalSizeItem, twoItemsHorizontal])]),
            
            generateMosaicInfo(heightRatio: 0.25, subItems: [fourItemsHorizontalGroup]),
            generateMosaicInfo(heightRatio: 0.75, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.75)),
                                                                                              subitems: [originalSizeItem, twoItemsHorizontal]),
                                                             NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.75)),
                                                                                               subitems: [twoItemsHorizontal, originalSizeItem])]),
            generateMosaicInfo(heightRatio: 0.75, subItems: [NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.75)),
                                                                                               subitems: [twoItemsHorizontal, originalSizeItem]),
                                                             NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.75)),
                                                                                              subitems: [originalSizeItem, twoItemsHorizontal])]),
            generateMosaicInfo(heightRatio: 1, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1)),
                                                                                           subitems: [originalSizeItem, originalSizeItem]),
                                                          NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1)),
                                                                                            subitems: [twoItemsHorizontal, originalSizeItem, twoItemsHorizontal])]),
            generateMosaicInfo(heightRatio: 1, subItems: [NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1)),
                                                                                            subitems: [twoItemsHorizontal, originalSizeItem, twoItemsHorizontal]),
                                                          NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1)),
                                                                                           subitems: [originalSizeItem, originalSizeItem])]),
            generateMosaicInfo(heightRatio: 1.25, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.25)),
                                                                                              subitems: [originalSizeItem, originalSizeItem, twoItemsHorizontal]),
                                                             NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.25)),
                                                                                               subitems: [twoItemsHorizontal, originalSizeItem, originalSizeItem])]),
            generateMosaicInfo(heightRatio: 0.25, subItems: [fourItemsHorizontalGroup, fourItemsHorizontalGroup]),
            generateMosaicInfo(heightRatio: 0.5, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)),
                                                                                             subitems: [originalSizeItem])]),
            generateMosaicInfo(heightRatio: 1.0, subItems: [NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1)),
                                                                                             subitems: [originalSizeItem])]),
            generateMosaicInfo(heightRatio: 0.5, subItems: [twoVerticalItems, halfSizeItem, twoVerticalItems]),
            generateMosaicInfo(heightRatio: 0.5, subItems: [twoVerticalItems, twoVerticalItems, halfSizeItem]),
            generateMosaicInfo(heightRatio: 0.5, subItems: [halfSizeItem, twoVerticalItems, twoVerticalItems]),
        ]
    }
    
    func get5SpanList(cellPadding: CGFloat) -> [MosaicInfo] {
        let fractionalSize1 = CGFloat(1.0) / CGFloat(5.0)
        let fractionalSize2 = CGFloat(1.0) / CGFloat(5.0) * CGFloat(2.0)
        let fractionalSize3 = CGFloat(1.0) / CGFloat(5.0) * CGFloat(3.0)
        let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize2), heightDimension: .fractionalWidth(fractionalSize2)))
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let originalSizeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        originalSizeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize1), heightDimension: .fractionalWidth(fractionalSize1)))
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        _ = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fractionalSize1)),
                                                                           subitems: [smallItem])
        
        let twoVerticalItems = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize1), heightDimension: .fractionalWidth(fractionalSize2)),
                                                                subitems: [originalSizeItem])
        
        let halfSizeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
        halfSizeItem.contentInsets = NSDirectionalEdgeInsets(top: cellPadding, leading: cellPadding, bottom: cellPadding, trailing: cellPadding)
        
        let twoHorizontalItems = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5)),
                                                                subitems: [halfSizeItem])
        
        return [
            generateMosaicInfo(heightRatio: fractionalSize1, subItems: [smallItem]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [twoVerticalItems, largeItem, largeItem]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [largeItem, largeItem, twoVerticalItems]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [largeItem, twoVerticalItems, largeItem]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [largeItem, twoVerticalItems, twoVerticalItems, twoVerticalItems]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [twoVerticalItems, largeItem, twoVerticalItems, twoVerticalItems]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [twoVerticalItems, twoVerticalItems, largeItem, twoVerticalItems]),
            generateMosaicInfo(heightRatio: fractionalSize2, subItems: [twoVerticalItems, twoVerticalItems, twoVerticalItems, largeItem]),
            generateMosaicInfo(heightRatio: fractionalSize3, subItems: [
                NSCollectionLayoutGroup.vertical( layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize2), heightDimension: .fractionalWidth(fractionalSize3)),
                                                                                                          subitems: [originalSizeItem, twoHorizontalItems]),
                NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize2), heightDimension: .fractionalWidth(fractionalSize3)),
                                                                                           subitems: [twoHorizontalItems, originalSizeItem]),
                NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalSize1), heightDimension: .fractionalWidth(fractionalSize3)),
                                                 subitems: [originalSizeItem]),
           ])
        ]
    }
}
