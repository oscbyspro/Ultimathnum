//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Integer
//*============================================================================*

/// A view of some integer's in-memory data.
///
/// - Warning: Its operations are unchecked by default.
///
public protocol DataInteger<Element> {
    
    associatedtype Body: BodyInteger<Element>
    
    associatedtype Element: SystemsInteger & UnsignedInteger
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var body: Body { get }
    
    @inlinable var appendix: Bit { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ start: Body, repeating appendix: Bit)
}
