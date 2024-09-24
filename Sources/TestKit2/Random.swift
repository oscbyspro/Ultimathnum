//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit

//*============================================================================*
// MARK: * Random x Randomness
//*============================================================================*

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Generates an `index` in `0 ..< size` then a pattern through `index`.
    ///
    /// - Note: Use the `unsigned` mode to reject `infinite` values.
    ///
    @inlinable public mutating func sizewise<T>(
        size: IX = IX(size: T.self) ?? 256,
        mode: Signedness =  T.mode
    )   -> T where T: BinaryInteger {
        
        let index = Count(IX.random(in: IX.zero ..< size, using: &self)!)
        switch mode {
        case Signedness  .signed: return T(raw: T.Signitude.random(through: Shift(index), using: &self))
        case Signedness.unsigned: return T(raw: T.Magnitude.random(through: Shift(index), using: &self))
        }
    }
}
