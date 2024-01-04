//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Overflow
//*============================================================================*

/// - TODO: Make this an error type when typed throws are introduced.
@frozen public struct Overflow<Value> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var value: Value
    public var overflow: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: Value,  overflow: Bool) {
        self.value = value; self.overflow = overflow
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func unwrapped(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Value {
        precondition(!self.overflow, UMN.callsiteOverflowInfo(function: function, file: file, line: line), file: file, line: line)
        return self.value as Value
    }
}
