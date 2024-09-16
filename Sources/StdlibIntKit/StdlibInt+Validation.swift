//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int x Validation
//*============================================================================*

extension StdlibInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Swift.BinaryInteger
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some Swift.BinaryInteger) {
        self.init(truncatingIfNeeded: source)
    }
    
    @inlinable public init(clamping source: some Swift.BinaryInteger) {
        self.init(truncatingIfNeeded: source)
    }
    
    @inlinable public init?(exactly source: some Swift.BinaryInteger) {
        self.init(truncatingIfNeeded: source)
    }
    
    @inlinable public init<T>(truncatingIfNeeded source: T) where T: Swift.BinaryInteger {
        let appendix = Bit(T.isSigned && source < T.zero)
        let body = source.words.lazy.map(UX.init(raw:))
        self.init(Base(consume body, repeating: appendix))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Swift.BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some Swift.BinaryFloatingPoint) {
        self.init(Base.leniently(source)!.value)
    }
    
    @inlinable public init?<T>(exactly source: T) where T: Swift.BinaryFloatingPoint {
        guard let base = Base.exactly(source) else { return nil }
        self.init(base)
    }
}
