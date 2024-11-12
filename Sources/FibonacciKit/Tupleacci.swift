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
// MARK: * Tupleacci
//*============================================================================*

@frozen public struct Tupleacci<Element>: CustomStringConvertible, Equatable, Recoverable where Element: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func fibonacci() -> Self {
        Self(minor: 0, major: 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var minor: Element
    public var major: Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(minor: Element, major: Element) {
        self.minor = minor
        self.major = major
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func swapped() -> Self {
        Self(minor: self.major, major: self.minor)
    }
    
    @inlinable public consuming func components() -> (minor: Element, major: Element) {
        (minor: self.minor, major: self.major)
    }
}
