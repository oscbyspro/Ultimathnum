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
// MARK: * Fibonacci x Toggle
//*============================================================================*

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sequence pair reflected about `-1/2`, or `nil`.
    ///
    /// ### Fibonacci
    ///
    /// - Note: It produces `nil` of the operation is `lossy`.
    ///
    /// ### Development
    ///
    /// - Todo: Measure versus `components()` approach.
    ///
    @inlinable public consuming func toggled() -> Optional<Self> {
        Self.toggled(self.base).map(Self.init(unsafe:)).optional()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Fibonacci {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable package static func toggled(
        _ value: consuming Indexacci<Element>
    )   -> Fallible<Indexacci<Element>> {
        
        var (error) = false
        value.tuple = Self.toggled(value.tuple, index: value.index.lsb).sink(&error)
        value.index = ((value)).index.toggled()
        return value.veto(error)
    }
    
    @inlinable package static func toggled(
        _ value: consuming Tupleacci<Element>, index: Bit
    )   -> Fallible<Tupleacci<Element>> {
        
        if  Bool(index) {
            value.major.negate().discard()
        }   else {
            value.minor.negate().discard()
        }
        
        return value.swapped().veto(!Element.isSigned)
    }
}
