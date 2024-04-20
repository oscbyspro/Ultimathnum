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
// MARK: * Double x Shift
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func upshift(unchecked distance: Base.Magnitude) -> Self {
        //=--------------------------------------=
        Swift.assert(distance < Base.size &<< 2 &- 1, String.brokenInvariant())
        //=--------------------------------------=
        if  distance.load(as: UX.self) >= UX(size: Base.self) {
            self.high     = Base(bitPattern: self.low &<< Shift(unchecked: distance &- Base.size))
            self.low      = Base.Magnitude(repeating: Bit(false))
        }   else if distance != Base.Magnitude() {
            self.high  &<<= Shift(unchecked: Base(bitPattern: distance))
            self.high    |= Base(bitPattern: self.low &>> Shift(unchecked: Base.size &- distance))
            self.low   &<<= Shift(unchecked: distance)
        }
        
        return self as Self as Self as Self
    }
    
    @inlinable package consuming func downshift(unchecked distance: Base.Magnitude) -> Self {
        //=--------------------------------------=
        Swift.assert(distance < Base.size &<< 2 &- 1, String.brokenInvariant())
        //=--------------------------------------=
        if  distance.load(as: UX.self) >= UX(size: Base.self) {
            self.low      = Base.Magnitude(bitPattern: self.high &>> Shift(unchecked: Base(bitPattern: distance &- Base.size)))
            self.high     = Base(repeating: Bit(self.high.isNegative))
        }   else if distance != Base.Magnitude() {
            self.low   &>>= Shift(unchecked: distance)
            self.low     |= Base.Magnitude(bitPattern: self.high &<< Shift(unchecked: Base(bitPattern: Base.size &- distance)))
            self.high  &>>= Shift(unchecked: Base(bitPattern: distance))
        }
        
        return self as Self as Self as Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable package consuming func upshift(unchecked distance: Self) -> Self {
        //=--------------------------------------=
        Swift.assert(distance.high == 0, String.brokenInvariant())
        //=--------------------------------------=
        return self.upshift(unchecked: distance.low)
    }
    
    @inlinable package consuming func downshift(unchecked distance: Self) -> Self {
        //=--------------------------------------=
        Swift.assert(distance.high == 0, String.brokenInvariant())
        //=--------------------------------------=
        return self.downshift(unchecked: distance.low)
    }
}
