//
//  WeatherLayout.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit

final class WeatherLayout: UICollectionViewFlowLayout {

    // Public Properties

    static let forecastBackgroundKind = "forecastBackgroundKind"

    var forecastIndices: IndexSet = [] {
        didSet {
            invalidateLayout()
        }
    }

    // Private Properties

    var cachedAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    override func invalidateLayout() {
        super.invalidateLayout()
        cachedAttributes = [:]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrs = super.layoutAttributesForElements(in: rect) else {
            cachedAttributes = [:]
            return nil
        }

        for attr in attrs {
            cachedAttributes[attr.indexPath] = attr
        }

        guard let decorationAttr = layoutAttributesForDecorationView(
            ofKind: WeatherLayout.forecastBackgroundKind,
            at: IndexPath(item: 0, section: 0)) else {
                return attrs
        }

        return attrs + [decorationAttr]
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == WeatherLayout.forecastBackgroundKind {
            var firstForecastAttrs: UICollectionViewLayoutAttributes = {
                let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath())
                attr.frame = .zero
                return attr
            }()
            var foundCandidateFirstForecastAttrs = false

            var lastForecastAttrs: UICollectionViewLayoutAttributes = {
                let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath())
                attr.frame = CGRect(x: .greatestFiniteMagnitude, y: 0, width: 1.0, height: 1.0)
                return attr
            }()
            var foundCandidateLastForecastAttrs = false

            for attr in cachedAttributes.values {
                if forecastIndices.contains(attr.indexPath.item) {
                    if attr.frame.minX >= firstForecastAttrs.frame.minX {
                        firstForecastAttrs = attr
                        foundCandidateFirstForecastAttrs = true
                    }

                    if attr.frame.maxX <= lastForecastAttrs.frame.maxX {
                        lastForecastAttrs = attr
                        foundCandidateLastForecastAttrs = true
                    }
                }
            }

            guard foundCandidateFirstForecastAttrs, foundCandidateLastForecastAttrs else {
                return nil
            }

            let boundingFrame = firstForecastAttrs.frame.union(lastForecastAttrs.frame)

            let backgroundAttr = UICollectionViewLayoutAttributes(forDecorationViewOfKind: WeatherLayout.forecastBackgroundKind, with: indexPath)
            backgroundAttr.frame = boundingFrame
            backgroundAttr.zIndex = -1
            return backgroundAttr
        }
        else {
            preconditionFailure()
        }
    }

}
