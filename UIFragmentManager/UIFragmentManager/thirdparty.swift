//
//  thirdparty.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/11/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import Foundation

typealias FragmentData = (x: Int, y: Int, deltaX: Int, deltaY: Int, height: Int , width: Int)

public enum Side {
    case left
    case right
    case bottom
    case top
}

public enum Effect {
    case blur
    case blackout
    case without
}

public enum Action {
    case show
    case hide
}

public enum MessageStyle {
    case standart
    case rounded
    case bottomRounded
    case strict
}


