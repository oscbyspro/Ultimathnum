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
// MARK: * Double Int x Token
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializes
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: BitCastable<UX.BitPattern> {
        let low  = Low (load: UX(bitPattern: source))
        let high = High(load: UX(bitPattern: source) >> Low.bitWidth.load(as: UX.self))
        self.init(low: low, high: high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        let low  = self.low .load(as: UX.self)
        let high = self.high.load(as: UX.self) << Low.bitWidth.load(as: UX.self)
        return T.init(bitPattern: low |  high)
    }
}
