//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Countable
//*============================================================================*


/// A collection of bits that can be counted.
///
/// ```swift
/// U8(11).size()                // 8
/// U8(11).count(  .anywhere(0)) // 5
/// U8(11).count(  .anywhere(1)) // 3
/// U8(11).count( .ascending(0)) // 0
/// U8(11).count( .ascending(1)) // 2
/// U8(11).count(.descending(0)) // 4
/// U8(11).count(.descending(1)) // 0
/// ```
///
public protocol BitCountable {
    
    associatedtype BitCount: BinaryInteger
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var appendix: Bit { borrowing get }
    
    @inlinable borrowing func size() -> BitCount
            
    @inlinable borrowing func count(_ bit: Bit, where selection: Bit  .Anywhere<Self>.Type) -> BitCount
    
    @inlinable borrowing func count(_ bit: Bit, where selection: Bit .Ascending<Self>.Type) -> BitCount
    
    @inlinable borrowing func count(_ bit: Bit, where selection: Bit.Descending<Self>.Type) -> BitCount
}
