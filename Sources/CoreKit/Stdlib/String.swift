//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * String
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Errors
//=----------------------------------------------------------------------------=

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// A message describing the location of a broken invariant.
    @inlinable package static func brokenInvariant(
        function: StaticString = #function,
        file: StaticString = #file,
        line: UInt = #line
    )   -> String { 
        "broken invariant in \(function) at \(file):\(line)"
    }
    
    /// A message describing the location of an out-of-bounds error.
    @inlinable package static func indexOutOfBounds(
        function: StaticString = #function, 
        file: StaticString = #file,
        line: UInt = #line
    )   -> String { 
        "index out of bounds in \(function) at \(file):\(line)"
    }
    
    /// A message describing the location of an overflow error.
    @inlinable package static func overflow(
        function: StaticString = #function, 
        file: StaticString = #file,
        line: UInt = #line
    )   -> String {
        "overflow in \(function) at \(file):\(line)"
    }
}
