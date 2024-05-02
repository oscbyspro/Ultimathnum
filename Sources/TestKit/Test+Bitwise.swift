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
// MARK: * Test x Bitwise
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func not<T>(
        _ instance: T,
        _ expectation: T
    )   where T: BitOperable & Equatable {
        
        same(~instance, expectation)
        same(~expectation, instance)
        
        same(instance   .toggled(), expectation)
        same(expectation.toggled(),    instance)
        
        same({ var x =    instance; x.toggle(); return x }(), expectation)
        same({ var x = expectation; x.toggle(); return x }(),    instance)
    }
    
    public func and<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: T
    )   where T: BitOperable & Equatable {
        
        same(lhs & rhs, expectation)
        same(rhs & lhs, expectation)
        
        same({ var x = lhs; x &= rhs; return x }(), expectation)
        same({ var x = rhs; x &= lhs; return x }(), expectation)
    }
    
    public func or<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: T
    )   where T: BitOperable & Equatable {
        
        same(lhs | rhs, expectation)
        same(rhs | lhs, expectation)
        
        same({ var x = lhs; x |= rhs; return x }(), expectation)
        same({ var x = rhs; x |= lhs; return x }(), expectation)
    }
    
    public func xor<T>(
        _ lhs: T,
        _ rhs: T,
        _ expectation: T
    )   where T: BitOperable & Equatable {
        
        same(lhs ^ rhs, expectation)
        same(rhs ^ lhs, expectation)
        
        same({ var x = lhs; x ^= rhs; return x }(), expectation)
        same({ var x = rhs; x ^= lhs; return x }(), expectation)
    }
}
