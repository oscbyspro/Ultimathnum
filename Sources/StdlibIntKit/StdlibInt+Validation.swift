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
        self.init(exactly: source.rounded(.towardZero))!
    }
    
    @inlinable public init?<T>(exactly source: T) where T: Swift.BinaryFloatingPoint {
        if  source.isZero {
            self.init()
            
        }   else if source.isNaN || source.isInfinite || source != source.rounded() {
            return nil
            
        }   else {
            let exponent = Swift.Int(source.exponent)
            let fraction = Self(source.significandBitPattern)
            Swift.assert(exponent >= .zero)
            
            self = Self(1) << exponent | fraction << (exponent - T.significandBitCount)
            
            if  source.sign == .plus {
                Swift.assert(source.floatingPointClass == .positiveNormal)
            }   else {
                self.negate()
                Swift.assert(source.floatingPointClass == .negativeNormal)
            }
        }
    }
}
