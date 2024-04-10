//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Comparison
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public var isInfinite: Bool {
        !Self.isSigned && Bool(self.appendix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func signum() -> Signum {
        self.compared(to: 0)
    }
    
    /// Returns whether this value is less than zero.
    ///
    /// It checks `isSigned` first which is preferred in inlinable generic code.
    ///
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && Bool(self.appendix)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Generic
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    #warning("TEST")
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) == Signum.same
    }
    
    @inlinable public static func !=<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger  {
        lhs.compared(to: rhs) != Signum.same
    }
    
    @inlinable public static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public static func >=<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger  {
        lhs.compared(to: rhs) != Signum.less
    }
    
    @inlinable public static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger  {
        lhs.compared(to: rhs) == Signum.more
    }
    
    @inlinable public static func <=<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger  {
        lhs.compared(to: rhs) != Signum.more
    }
    
    #warning("TEST")
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared<Other>(to other: Other) -> Signum where Other: BinaryInteger {
        if !Self.bitWidth.isInfinite, !Other.bitWidth.isInfinite {
            
            if  UX(load: Self.bitWidth) < UX(load: Other.bitWidth) {
                
                return Other(load: self).compared(to: other)
                
            }   else if UX(load: Self.bitWidth) > UX(load: Other.bitWidth) {
                
                return self .compared(to: Self(load: other))
                
            }   else if Self.isSigned, !Other.isSigned {
                
                return self .isLessThanZero ? Signum.less : Other(load: self).compared(to: other)
                
            }   else if !Self.isSigned, Other.isSigned {
                
                return other.isLessThanZero ? Signum.more : self.compared(to: Self(load:  other))
                
            }   else {
                
                return self .compared(to: Self(load: other))
                
            }
            
        }   else {
            
            #warning("TODO: check from SystemsInteger to BinaryInteger")
            
            if  Other.Section.Magnitude.memoryCanBeRebound(to: Self.Section.Magnitude.self) {
                return self.withUnsafeBinaryIntegerMemory{ lhs in
                    (other).withUnsafeBinaryIntegerMemory(as:  Self.Section.Magnitude.self) { rhs in
                        MemoryInt.compare(
                            lhs: lhs, lhsIsSigned: Self .isSigned,
                            rhs: rhs, rhsIsSigned: Other.isSigned
                        )
                    }!
                }
                
            }   else if Self.Section.Magnitude.memoryCanBeRebound(to: Other.Section.Magnitude.self) {
                return self.withUnsafeBinaryIntegerMemory(as: Other.Section.Magnitude.self) { lhs in
                    (other).withUnsafeBinaryIntegerMemory { rhs in
                        MemoryInt.compare(
                            lhs: lhs, lhsIsSigned: Self .isSigned,
                            rhs: rhs, rhsIsSigned: Other.isSigned
                        )
                    }
                }!
                
            }   else if Other.Section.Magnitude.memoryCanBeRebound(to: Self.Element.Magnitude.self) {
                return self.withUnsafeBinaryIntegerMemory(as: Self.Element.Magnitude.self) { lhs in
                    (other).withUnsafeBinaryIntegerMemory(as: Self.Element.Magnitude.self) { rhs in
                        MemoryInt.compare(
                            lhs: lhs, lhsIsSigned: Self .isSigned,
                            rhs: rhs, rhsIsSigned: Other.isSigned
                        )
                    }!
                }!
                
            }   else if Self.Section.Magnitude.memoryCanBeRebound(to: Other.Element.Magnitude.self) {
                return self.withUnsafeBinaryIntegerMemory(as: Other.Element.Magnitude.self) { lhs in
                    (other).withUnsafeBinaryIntegerMemory(as: Other.Element.Magnitude.self) { rhs in
                        MemoryInt.compare(
                            lhs: lhs, lhsIsSigned: Self .isSigned,
                            rhs: rhs, rhsIsSigned: Other.isSigned
                        )
                    }!
                }!
                
            }   else {
                
                Swift.fatalError(String.unreachable())
                
            }
        }
    }
}
