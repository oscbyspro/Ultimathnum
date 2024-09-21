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
    
    @inlinable public init<Other>(truncatingIfNeeded source: Other) where Other: Swift.BinaryInteger {
        self = Namespace.withUnsafeBufferPointerOrCopy(of: source.words) {
            $0.withMemoryRebound(to: UX.self) {
                Self(Base(load: DataInt($0, repeating: Bit(Other.isSigned && $0.last?.msb == Bit.one))!))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Swift.BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some Swift.BinaryFloatingPoint) {
        self.init(Base(source))
    }
    
    @inlinable public init?(exactly source: some Swift.BinaryFloatingPoint) {
        guard let base = Base.exactly(source) else { return nil }
        self.init(base)
    }
}
