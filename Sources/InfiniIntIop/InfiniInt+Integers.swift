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
// MARK: * Infini Int x Integers x Stdlib
//*============================================================================*

extension InfiniInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
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
    
    @inlinable public init<Other: Swift.BinaryInteger>(truncatingIfNeeded source: Other) {
        self = Namespace.withUnsafeBufferPointerOrCopy(of: source.words) {
            $0.withMemoryRebound(to: UX.self) {
                let appendix = Bit(Other.isSigned && $0.last?.msb == Bit.one)
                return Self(Base(load: DataInt($0, repeating: appendix)!))
            }
        }
    }
}
