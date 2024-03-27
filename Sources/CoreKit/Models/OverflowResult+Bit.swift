//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Overflow Result x Bit
//*============================================================================*

extension Overflow.Result: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Overflow<Value.BitPattern>.Result) {
        self.init(Value(bitPattern: bitPattern.value), overflow: bitPattern.overflow)
    }
    
    @inlinable public var bitPattern: Overflow<Value.BitPattern>.Result {
        consuming get {
            Overflow<Value.BitPattern>.Result(Value.BitPattern(bitPattern: self.value), overflow: self.overflow)
        }
    }
}
