//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Double Int x Integers x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some Swift.BinaryInteger) {
        self.init(exactly: source)!
    }
    
    @inlinable public init?(exactly source: some Swift.BinaryInteger) {
        if  source < Self.min {
            return nil
        }   else if source > Self.max {
            return nil
        }   else {
            self.init(truncatingIfNeeded: source)
        }
    }
    
    @inlinable public init(clamping source: some Swift.BinaryInteger) {
        if  source < Self.min {
            self = Self.min
        }   else if source > Self.max {
            self = Self.max
        }   else {
            self.init(truncatingIfNeeded: source)
        }
    }
    
    @inlinable public init(truncatingIfNeeded source: some Swift.BinaryInteger) {
        self.init(Namespace.load(source, as: Base.self))
    }
}

//*============================================================================*
// MARK: * Double Int x Integers x Stdlib x Swift Fixed Width Integer
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Loads the bit pattern of `source` that fits.
    ///
    /// ### Development
    ///
    /// - Note: This is a requirement of `Swift.FixedWidthInteger`.
    ///
    @inlinable public init(_truncatingBits source: Swift.UInt) {
        self.init(Base(load: UX(source)))
    }
}
