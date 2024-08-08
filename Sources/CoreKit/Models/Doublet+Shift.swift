//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Shift
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 2
    //=------------------------------------------------------------------------=

    /// Performs an ascending shift.
    ///
    /// - Parameter distance: A shift in the range of `0 ..< Base.size`.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public consuming func up(_ distance: Shift<Base.Magnitude>) -> Self {
        //  TODO: await consuming fixes
        if  let nondistance = distance.inverse() {
            var high = self.high.up(distance)
            high    |= High(raw: self.low.down(nondistance))
            let low  = self.low .up(distance)
            return Self(low: low, high: high)
        }
        
        return self // as Self as Self as Self
    }
    
    /// Performs a descending shift.
    ///
    /// - Parameter distance: A shift in the range of `0 ..< Base.size`.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public consuming func down(_ distance: Shift<Base.Magnitude>) -> Self {
        //  TODO: await consuming fixes
        if  let nondistance = distance.inverse() {
            var low  = self.low .down(distance)
            low     |= Low(raw: self.high.up(nondistance))
            let high = self.high.down(distance)
            return Self(low: low, high: high)
        }
        
        return self // as Self as Self as Self
    }
}
