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
    @inlinable public consuming func up(_ distance: Shift<Base>) -> Self {
        if  let nondistance = distance.inverse() {
            self.high  = self.high.up(distance)
            self.high |= High(raw: self.low.down(nondistance.magnitude()))
            self.low   = self.low .up(distance.magnitude())
        }
        
        return self // as Self as Self as Self
    }
    
    /// Performs a descending shift.
    ///
    /// - Parameter distance: A shift in the range of `0 ..< Base.size`.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public consuming func down(_ distance: Shift<Base>) -> Self {
        if  let nondistance = distance.inverse() {
            self.low   = self.low .down(distance.magnitude())
            self.low  |= Low(raw: self.high.up(nondistance))
            self.high  = self.high.down(distance)
        }
        
        return self // as Self as Self as Self
    }
}
