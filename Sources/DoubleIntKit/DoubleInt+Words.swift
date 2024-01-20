//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Words
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializes
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX) {
        let low  = Low (load: source)
        let high = High(load: source >> Low.bitWidth.load(as: UX.self))
        self.init(low: low, high: high)
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        let low  = self.low .load(as: UX.self)
        let high = self.high.load(as: UX.self) << Low.bitWidth.load(as: UX.self)
        return low | high
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: [UX] {
        fatalError("TODO")
    }
}
