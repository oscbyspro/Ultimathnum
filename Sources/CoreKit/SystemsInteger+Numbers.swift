//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Numbers
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        isSigned ? msb : 0
    }
    
    @inlinable public static var max: Self {
        ~(min)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(clamping source: some BinaryInteger) {
        if  let instance = Self.exactly(source).optional() {
            self = instance
        }   else {
            self = source.isNegative ? Self.min : Self.max
        }
    }
}
