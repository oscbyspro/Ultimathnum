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
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<UX.BitPattern> {
        //=--------------------------------------=
        let low  = Low (load: source)
        let high = High(load: source >> Low.bitWidth.load(as: T.self))
        //=--------------------------------------=
        self.init(low: low, high: high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        //=--------------------------------------=
        let low  = self.low .load(as: T.self)
        let high = self.high.load(as: T.self) << Low.bitWidth.load(as: T.self)
        //=--------------------------------------=
        return T.init(bitPattern: low | high)
    }
}
