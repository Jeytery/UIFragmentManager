//
//  UIFragmentParameters.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/11/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class UIFragmentParameters {

    public var fragmentData: FragmentData = (x: 0, y: 0, deltaX: 0, deltaY: 0, height: 0, width: 0)

    public let screenSize = UIScreen.main.bounds.size

    public var edges: (bottom: Int, top: Int, left: Int, right: Int) = (bottom: 0, top: 0, left: 0, right: 0)

    public var intend: Int = 100

    public lazy var effect: UIFragmentEffect = BlackoutEffect(intensity: 0)

    public var layer: Int = 1

    public var gesture: UIFragmentGesture = UIFragmentGesture()

    public var side: Side = .bottom

    public var cornersCurves: (corners: UIRectCorner, radius: Float) = (corners: [], radius: 0)

    public var maxHeight: Int = 2000

    public var maxWidth: Int = 2000
    
    public var presentType: PresentType = .topVC

    public var fragmentDiaposon: ClosedRange<Float> {
        get {
            switch side {
            case .bottom:
                return Float(screenSize.height - (screenSize.height - CGFloat(intend)))...Float(screenSize.height) // for minY
            case .top:
                return Float(0)...Float(screenSize.height - CGFloat(intend)) // for maxY
            case .left:
                return Float(0)...Float(screenSize.width - CGFloat(intend)) // for maxX
            case .right:
                return Float(intend)...Float(screenSize.width) // for maxX
            }
        }
        /* F - fragment, a - fragment diaposon
            -___-                        
           |     |
           |     |
           |     |
           |-----| <- a
           |  F  |
            -----  <-
        */
    }

    //MARK: - private functions
    private func checkMaxFrameValue() {
        if fragmentData.height > maxHeight {
            let delta = maxHeight - fragmentData.height
            fragmentData.height = maxHeight
            fragmentData.y -= delta
            fragmentData.deltaY -= delta
        }

        if fragmentData.width > maxWidth {
            let delta = fragmentData.width - maxWidth
            fragmentData.width = maxWidth
            fragmentData.x += delta / 2
            fragmentData.deltaX += delta / 2
        }
    }

    //MARK: - public fucntions
    public init() {
    
    }

    public init(side: Side, intend: Int, edges: (bottom: Int, top: Int, left: Int, right: Int), layer: Int, effect: UIFragmentEffect, gesture: UIFragmentGesture, cornersCurves: (corners: UIRectCorner, radius: Float), presentType: PresentType) {
        self.side = side
        self.intend = intend
        self.edges = edges
        self.layer = layer
        self.effect = effect
        self.gesture = gesture
        self.cornersCurves = cornersCurves
        self.presentType = presentType
        updateFragmentFrameData()
    }

    public func setSide(side: Side) {
        self.side = side
        updateFragmentFrameData()
    }

    public func setIntend(intend: Int) {
        self.intend = intend
        updateFragmentFrameData()
    }

    public func setEdges(edges: (bottom: Int, top: Int, left: Int, right: Int) ) {
        self.edges = edges
        updateFragmentFrameData()
    }

    public func updateFragmentFrameData() {
        switch self.side {
        case .bottom:
            self.fragmentData.x = 0 + self.edges.left
            self.fragmentData.y = Int(self.screenSize.height) + self.edges.top
            self.fragmentData.width = Int(screenSize.width - CGFloat(self.edges.left + self.edges.right))
            self.fragmentData.height = Int(self.screenSize.height) - (self.intend + self.edges.top + self.edges.bottom)
            self.fragmentData.deltaX = 0 + self.edges.left
            self.fragmentData.deltaY = Int(self.screenSize.height) - self.fragmentData.height - self.edges.bottom
        case .left:
            self.fragmentData.x = -(Int(self.screenSize.width) - self.intend) + self.edges.left
            self.fragmentData.y = 0 + self.edges.top
            self.fragmentData.width = Int(self.screenSize.width) - self.intend - (self.edges.right + self.edges.left)
            self.fragmentData.height = Int(self.screenSize.height) - (self.edges.top + self.edges.bottom)
            self.fragmentData.deltaX = 0 + self.edges.left
            self.fragmentData.deltaY = 0 + self.edges.top
        case .right:
            self.fragmentData.x = Int( (screenSize.width) )
            self.fragmentData.y = 0 + self.edges.bottom
            self.fragmentData.width = Int(Int(screenSize.width) - self.intend) - (self.edges.left + self.edges.right)
            self.fragmentData.height = Int(self.screenSize.height) - Int(self.edges.top + self.edges.bottom)
            self.fragmentData.deltaX = Int(self.screenSize.width) - self.fragmentData.width - self.edges.right
            self.fragmentData.deltaY = 0 + self.edges.bottom
        case .top:
            self.fragmentData.x = self.edges.left
            self.fragmentData.y = -(Int(screenSize.height) - self.intend) + self.edges.top
            self.fragmentData.width = Int(self.screenSize.width) - (self.edges.left + self.edges.right)
            self.fragmentData.height = Int(screenSize.height) - self.intend - (self.edges.top + self.edges.bottom)
            self.fragmentData.deltaX = self.edges.left
            self.fragmentData.deltaY = self.edges.top
        }
    }
}
