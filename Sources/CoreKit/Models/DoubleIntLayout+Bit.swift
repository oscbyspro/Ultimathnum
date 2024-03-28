//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Double Int Layout x Bit
//*============================================================================*

extension DoubleIntLayout: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming DoubleIntLayout<Base.Magnitude>) {
        self.init(low: bitPattern.low, high: Base(bitPattern: bitPattern.high))
    }
    
    @inlinable public var bitPattern: DoubleIntLayout<Base.Magnitude> {
        consuming get {
            .init(low: self.low, high: Base.Magnitude(bitPattern: self.high))
        }
    }
}
