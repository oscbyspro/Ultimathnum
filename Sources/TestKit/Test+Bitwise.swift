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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func complement<T>(_ instance: T, _ increment: Bool, _ expectation: Fallible<T>) where T: BinaryInteger {
        always: do {
            let (result) = instance.complement(increment)
            same(result, expectation, "complement [0]")
        }
        
        if  increment {
            let (result) = instance.complement()
            same(result, expectation.value, "complement [1]")
        }
        
        if !increment {
            var (result) = instance
            result = result.complement(increment).value
            result = result.complement(increment).value
            same(result,   instance, "complement [2]")
        }
        
        if  increment {
            let (result) = instance.toggled().plus(1)
            same(result, expectation, "manual complement [0]")
        }
        
        if !increment {
            let (result) = Fallible(instance.toggled())
            same(result, expectation, "manual complement [1]")
        }
        
        if  instance.isNegative, increment {
            same(T(raw: instance.magnitude()), expectation.value, "magnitude [0]")
        }
        
        if !instance.isNegative {
            same(T(raw: instance.magnitude()), instance, "magnitude [1]")
        }
    }
}
