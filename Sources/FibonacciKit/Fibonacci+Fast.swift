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
// MARK: * Fibonacci x Fast
//*============================================================================*

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the sequence pair at `index`, or `nil`.
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    @inlinable public init?(_ index: consuming Element) {
        let base = Self.exactly(index, as: Indexacci.self)
        guard let base =  base?.optional() else { return nil }
        self.init(unsafe: base)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=s
    
    @inlinable package static func exactly(
        _ index: consuming Element,
        as type: Indexacci<Element>.Type = Indexacci<Element>.self
    )   -> Optional<Fallible<Indexacci<Element>>> {
        
        guard let tuple: Fallible<Tupleacci> = Self.exactly(index) else {
            return nil
        }
        
        return Indexacci(tuple: tuple.value, index: index).veto(tuple.error)
    }
    
    @inlinable package static func exactly(
        _ index: borrowing Element,
        as type: Tupleacci<Element>.Type = Tupleacci<Element>.self
    )   -> Optional<Fallible<Tupleacci<Element>>> {
        
        if  index.isInfinite {
            return nil
        }
        
        var value = Tupleacci<Element>.fibonacci()
        var error = false
        let limit = UX(raw: index.nondescending(index.appendix))
        let minus = U8(Bit( index.isNegative))
        
        index.withUnsafeBinaryIntegerBody(as: U8.self) {
            for count in (0 ..< limit).reversed() {
                value = Self.doubled(value).sink(&error)
                
                if  $0[unchecked: IX(raw: count) &>> 3] &>> U8(load: count) & 1 != minus {
                    value = value.incremented().sink(&error)
                }
            }
        }
        
        if !minus.isZero {
            value = Self.toggled(value, index: index.lsb.toggled()).sink(&error)
        }
        
        return value.veto(error)
    }
}
