//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Some
//*============================================================================*

@dynamicMemberLookup @frozen public struct Some<each Input, Output>: CustomTestStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let input: (repeat each Input)
    public let output: Output
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ input: repeat each Input, yields output: Output) {
        self.input  = (repeat each input)
        self.output = (output)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var testDescription: String {
        "\(self.input) → \(self.output)"
    }
    
    @inlinable public subscript<T>(dynamicMember keyPath: KeyPath<(repeat each Input), T>) -> T {
        self.input[keyPath: keyPath]
    }
}
