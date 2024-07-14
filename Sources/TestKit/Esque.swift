//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Esque
//*============================================================================*

/// A source of common values or values with known behaviors.
public struct Esque<T> { }

//=----------------------------------------------------------------------------=
// MARK: + Binary Integer
//=----------------------------------------------------------------------------=

extension Esque where T: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// - Note: The infinite case must be greater than all finite cases.
    @inlinable public static var shl: T {
        (T.size.isInfinite ? 511 : T(IX(size: T.self)! - 1))
    }
    
    @inlinable public static var min: T {
        (T.isSigned ? T(repeating: 1) << shl : T.zero)
    }
    
    @inlinable public static var max: T {
        (T.isSigned ? min.toggled() : T(repeating: 1))
    }
    
    @inlinable public static var lsb: T {
        (T.lsb)
    }
    
    @inlinable public static var msb: T {
        (T.isSigned ? T(repeating: 1) : 1) << shl
    }
    
    @inlinable public static var bot: T {
        (T.isSigned ? msb.toggled() : msb - 1)
    }
}
