//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Proper Binary Integer x Comparison x Systems
//*============================================================================*

extension Namespace.ProperBinaryInteger where Base: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func compare(_ lhs: Base, to rhs: some SystemsInteger) -> Signum {
        self.compareIsLessThan(lhs, to: rhs) ? -1 : self.compareIsEqual(lhs, to: rhs) ? 0 : 1
    }
    
    @inlinable package static func compareIsNotEqual(_ lhs: Base, to rhs: some SystemsInteger) -> Bool {
        PBI.compareIsEqual(rhs, to: lhs) == false
    }
    
    @inlinable package static func compareIsMoreThan(_ lhs: Base, to rhs: some SystemsInteger) -> Bool {
        PBI.compareIsLessThan(rhs, to: lhs)
    }
    
    @inlinable package static func compareIsLessThanOrEqual(_ lhs: Base, to rhs: some SystemsInteger) -> Bool {
        PBI.compareIsMoreThan(lhs, to: rhs) == false
    }
    
    @inlinable package static func compareIsMoreThanOrEqual(_ lhs: Base, to rhs: some SystemsInteger) -> Bool {
        PBI.compareIsLessThan(lhs, to: rhs) == false
    }
    
    @inlinable package static func compareIsEqual<Other: SystemsInteger>(_ lhs: Base, to rhs: Other) -> Bool {
        if  Base.isSigned == Other.isSigned {
            
            if  Base.bitWidth.load(as: UX.self) >= Other.bitWidth.load(as: UX.self) {
                return lhs == Base(truncating: rhs)
            }   else {
                return Other(truncating: lhs) == rhs
            }
            
        }   else if Base.isSigned {
            
            if  Base.bitWidth.load(as: UX.self) >  Other.bitWidth.load(as: UX.self) {
                return lhs == Base(truncating: rhs)
            }   else {
                return lhs >= 0 && Other(truncating: lhs) == rhs
            }
            
        }   else {
            
            if  Base.bitWidth.load(as: UX.self) <  Other.bitWidth.load(as: UX.self) {
                return Other(truncating: lhs) == rhs
            }   else {
                return rhs >= 0 && lhs == Base(truncating: rhs)
            }
            
        }
    }
    
    @inlinable package static func compareIsLessThan<Other: SystemsInteger>(_ lhs: Base, to rhs: Other) -> Bool {
        if  Base.isSigned == Other.isSigned {
            
            if  Base.bitWidth.load(as: UX.self) >= Other.bitWidth.load(as: UX.self) {
                return lhs < Base(truncating: rhs)
            }   else {
                return Other(truncating: lhs) < rhs
            }
            
        }   else if Base.isSigned {
            
            if  Base.bitWidth.load(as: UX.self) >  Other.bitWidth.load(as: UX.self) {
                return lhs < Base(truncating: rhs)
            }   else {
                return lhs < 0 || Other(truncating: lhs) < rhs
            }
            
        }   else {
            
            if  Base.bitWidth.load(as: UX.self) <  Other.bitWidth.load(as: UX.self) {
                return Other(truncating: lhs) < rhs
            }   else {
                return rhs > 0 && lhs < Base(truncating: rhs)
            }
            
        }
    }
}
