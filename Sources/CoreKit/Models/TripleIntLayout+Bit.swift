//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triple Int Layout x Bit
//*============================================================================*

extension TripleIntLayout: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming TripleIntLayout<Base.Magnitude>) {
        self.init(
            low:  bitPattern.low,
            mid:  bitPattern.mid,
            high: Base(bitPattern: bitPattern.high)
        )
    }
    
    @inlinable public var bitPattern: TripleIntLayout<Base.Magnitude> {
        consuming get {
            TripleIntLayout<Base.Magnitude>(
                low:  self.low,
                mid:  self.mid,
                high: Base.Magnitude(bitPattern: self.high)
            )
        }
    }
}
