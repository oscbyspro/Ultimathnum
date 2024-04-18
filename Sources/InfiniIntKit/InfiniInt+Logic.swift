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
// MARK: * Infini Int x Logic
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        instance.storage.withUnsafeMutableBinaryIntegerBody({ $0.toggle() })
        instance.storage.appendix.toggle()
        return instance
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        let count: IX = switch (Bool(lhs.appendix), Bool(rhs.appendix)) {
        case (false, false): Swift.min(lhs.storage.count, rhs.storage.count)
        case (false, true ): lhs.storage.count
        case (true,  false): rhs.storage.count
        case (true,  true ): Swift.max(lhs.storage.count, rhs.storage.count)
        }
        
        lhs.storage.resize(count)
        lhs.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            rhs.storage.withUnsafeBinaryIntegerBody { rhs in
                for index in 0 ..< Swift.min(lhs.count, rhs.count) {
                    lhs[unchecked: index] &= rhs[unchecked: index]
                }
            }
        }
        
        lhs.storage.appendix &= rhs.storage.appendix
        lhs.storage.normalize()
        return lhs
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        let count: IX = switch (Bool(lhs.appendix), Bool(rhs.appendix)) {
        case (false, false): Swift.max(lhs.storage.count, rhs.storage.count)
        case (false, true ): rhs.storage.count
        case (true,  false): lhs.storage.count
        case (true,  true ): Swift.min(lhs.storage.count, rhs.storage.count)
        }
        
        lhs.storage.resize(count)
        lhs.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            rhs.storage.withUnsafeBinaryIntegerBody { rhs in
                for index in 0 ..< Swift.min(lhs.count, rhs.count) {
                    lhs[unchecked: index] |= rhs[unchecked: index]
                }
            }
        }
        
        lhs.storage.appendix |= rhs.storage.appendix
        lhs.storage.normalize()
        return lhs
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.storage.resize(minCount: rhs.storage.count)
        lhs.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            rhs.withUnsafeBinaryIntegerElements { rhs in
                for index in lhs.indices {
                    lhs[unchecked: index] ^= rhs[UX(bitPattern: index)]
                }
            }
        }
        
        lhs.storage.appendix ^= rhs.storage.appendix
        lhs.storage.normalize()
        return lhs
    }
}
