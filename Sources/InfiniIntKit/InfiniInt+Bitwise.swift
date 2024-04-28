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
// MARK: * Infini Int x Bitwise
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        instance.storage.withUnsafeMutableBinaryIntegerBody({ $0.toggle() })
        instance.storage.appendix.toggle()
        return instance
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        let count: IX = switch (Bool(lhs.appendix), Bool(rhs.appendix)) {
        case (false, false): Swift.min(lhs.storage.count, rhs.storage.count)
        case (false, true ): lhs.storage.count
        case (true,  false): rhs.storage.count
        case (true,  true ): Swift.max(lhs.storage.count, rhs.storage.count)
        }
        
        lhs.storage.resize(count)
        lhs.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            rhs.storage.withUnsafeBinaryIntegerBody { rhs in
                for index in 0 ..< Swift.min(lhs.count, rhs.count) {
                    lhs[unchecked: index] &= rhs[unchecked: index]
                }
            }
        }
        
        lhs.storage.appendix &= rhs.storage.appendix
        lhs.storage.normalize()
        return lhs
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        let count: IX = switch (Bool(lhs.appendix), Bool(rhs.appendix)) {
        case (false, false): Swift.max(lhs.storage.count, rhs.storage.count)
        case (false, true ): rhs.storage.count
        case (true,  false): lhs.storage.count
        case (true,  true ): Swift.min(lhs.storage.count, rhs.storage.count)
        }
        
        lhs.storage.resize(count)
        lhs.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            rhs.storage.withUnsafeBinaryIntegerBody { rhs in
                for index in 0 ..< Swift.min(lhs.count, rhs.count) {
                    lhs[unchecked: index] |= rhs[unchecked: index]
                }
            }
        }
        
        lhs.storage.appendix |= rhs.storage.appendix
        lhs.storage.normalize()
        return lhs
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        lhs.storage.resize(minCount: rhs.storage.count)
        lhs.storage.withUnsafeMutableBinaryIntegerBody { lhs in
            rhs.withUnsafeBinaryIntegerElements { rhs in
                for index in lhs.indices {
                    lhs[unchecked: index] ^= rhs[UX(raw: index)]
                }
            }
        }
        
        lhs.storage.appendix ^= rhs.storage.appendix
        lhs.storage.normalize()
        return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        self.storage.withUnsafeMutableBinaryIntegerBody {
            increment = $0.toggle(carrying: increment)
        }
        
        if !(copy increment) {
            self.storage.appendix.toggle()
            self.storage.normalize()
        }   else if Bool(self.appendix) {
            increment.toggle()
            self.storage.body.append(1)
            self.storage.appendix.toggle()
        }
        
        Swift.assert(self.storage.isNormal, String.brokenInvariant())
        return self.combine(!Self.isSigned && increment)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: Bit.Selection) -> Magnitude {
        var count = Magnitude()
        
        switch selection {
        case Bit.Selection.anywhere:
            let contrast = self.appendix.toggled()
            self.storage.withUnsafeBinaryIntegerBody {
                count = Magnitude(load: $0.count(contrast, where: selection))
                if  contrast != bit {
                    count.toggle()
                }
            }
            
        case Bit.Selection.ascending:
            let bitIsAppendix = self.appendix == bit
            self.storage.withUnsafeBinaryIntegerBody {
                let ascending =  $0.count(bit,where: selection)                
                if  ascending == $0.count(Bit.self), bitIsAppendix {
                    count = Magnitude.size
                }   else {
                    count = Magnitude(load: ascending)
                }
            }
            
        case Bit.Selection.descending:
            if  self.appendix == bit {
                self.withUnsafeBinaryIntegerBody {
                    count = Self.size - Magnitude(load: $0.count(.nondescending(bit)))
                }
            }
        }
        
        return count as Magnitude
    }
}
