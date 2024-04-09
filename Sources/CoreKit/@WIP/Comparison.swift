//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Comparison
//*============================================================================*

@inlinable public func compare<LHS, RHS>(_ lhs: LHS, to rhs: RHS) -> Signum where LHS: BinaryInteger, RHS: BinaryInteger {
    if !LHS.bitWidth.isInfinite, !RHS.bitWidth.isInfinite {
        
        switch UX(load: LHS.bitWidth).compared(to: UX(load: RHS.bitWidth)) {
        case Signum.same:
            
            if  LHS.isSigned == RHS.isSigned {
                
                return lhs.compared(to: LHS(load: rhs))
                
            }   else if lhs.isLessThanZero {
                
                return Signum.less
                                
            }   else if rhs.isLessThanZero {
                
                return Signum.more
                
            }   else {
                
                return lhs.compared(to: LHS(load: rhs))
                
            }
            
        case Signum.less:
            
            return RHS(load: lhs).compared(to: rhs)
            
        case Signum.more:
            
            return lhs.compared(to: LHS(load: rhs))
            
        }
        
    }   else {
        
        if  RHS.Element.Magnitude.memoryCanBeRebound(to: LHS.Element.Magnitude.self) {
            
            return lhs.withUnsafeBinaryIntegerMemory { lhs in
                rhs.withUnsafeBinaryIntegerMemoryAs(unchecked: LHS.Element.Magnitude.self) { rhs in
                    MemoryInt.compare(
                        lhs: lhs, lhsIsSigned: LHS.isSigned,
                        rhs: rhs, rhsIsSigned: RHS.isSigned
                    )
                }
            }
            
        }   else if LHS.Element.Magnitude.memoryCanBeRebound(to:  RHS.Element.Magnitude.self) {
            
            return lhs.withUnsafeBinaryIntegerMemoryAs(unchecked: RHS.Element.Magnitude.self) { lhs in
                rhs.withUnsafeBinaryIntegerMemory { rhs in
                    MemoryInt.compare(
                        lhs: lhs, lhsIsSigned: LHS.isSigned,
                        rhs: rhs, rhsIsSigned: RHS.isSigned
                    )
                }
            }
            
        }   else {
            
            Swift.fatalError(String.unreachable())
            
        }
    }
}
