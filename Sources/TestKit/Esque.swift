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

/// A source of common values or values with common behaviors.
public struct Esque<T> { }

//=----------------------------------------------------------------------------=
// MARK: + Binary Integer
//=----------------------------------------------------------------------------=

extension Esque where T: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// An ascending shift distance.
    ///
    /// - Note: The infinite case must be greater than all finite cases.
    ///
    @inlinable public static var shl: T {
        if  T.size.isInfinite {
            return 511
            
        }   else {
            return T(IX(size: T.self)! - 1)
        }
    }
    
    @inlinable public static var min: T {
        if  T.isSigned {
            return T(repeating: 1) << shl
            
        }   else {
            return T(repeating: 0)
        }
    }
    
    @inlinable public static var max: T {
        always: do {
            return min.toggled()
        }
    }
    
    @inlinable public static var lsb: T {
        always: do {
            return T.lsb
        }
    }
    
    @inlinable public static var msb: T {
        if  T.isSigned {
            return min
            
        }   else {
            return lsb << shl
        }
    }
    
    @inlinable public static var bot: T {
        if  T.isSigned {
            return msb.toggled()
            
        }   else {
            return msb - 1
        }
    }
}
