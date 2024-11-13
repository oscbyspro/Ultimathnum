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
// MARK: * Indexacci
//*============================================================================*

@frozen public struct Indexacci<Element>: CustomStringConvertible, Hashable, Recoverable, Sendable where Element: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func fibonacci() -> Self {
        Self(tuple: Tupleacci.fibonacci(), index: Element.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var tuple: Tupleacci<Element>
    public var index: Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(tuple: consuming Tupleacci<Element>, index: consuming Element) {
        self.tuple = tuple
        self.index = index
    }
    
    @inlinable public init(minor: consuming Element, major: consuming Element, index: consuming Element) {
        self.init(tuple: Tupleacci(minor: minor, major: major), index: index)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func components() -> (tuple: Tupleacci<Element>, index: Element) {
        (tuple: self.tuple, index: self.index)
    }
}
