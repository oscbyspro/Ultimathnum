//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Integer x Body
//*============================================================================*

/// A view of some integer's in-memory body.
///
/// - Warning: Its operations are unchecked by default.
///
public protocol DataIntegerBody<Element>: BitCountable where BitCount == IX {
    
    associatedtype Address: Strideable<Int>
    
    associatedtype Buffer: RandomAccessCollection<Element>
    
    associatedtype Element: SystemsInteger & UnsignedInteger
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var start: Address { get }
    
    @inlinable var count: IX { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable init?(_ buffer: Buffer)
    
    @inlinable init(_ start: Address, count: IX)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func buffer() -> Buffer
    
    @inlinable consuming func reader() -> DataInt<Element>.Body
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(unchecked index:   IX) -> Element { get }
    
    @inlinable subscript(unchecked index: Void) -> Element { get }
}
