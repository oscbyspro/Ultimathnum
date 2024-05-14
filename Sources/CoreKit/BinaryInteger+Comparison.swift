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
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type can represent negative values.
    ///
    /// ```
    /// ┌──────┬──────────┬──────┬──────┐
    /// │ type │ isSigned │  min │  max │
    /// ├──────┼──────────┼──────┼──────┤
    /// │ I8   │ true     │ -128 │  127 │
    /// │ U8   │ false    │    0 │  255 │
    /// └──────┴──────────┴──────┴──────┘
    /// ```
    ///
    @inlinable public static var isSigned: Bool {
        Self.mode.matches(signedness: .signed)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this value is is greater than all finite values.
    ///
    /// It checks `isSigned`, which is preferred in inlinable generic code.
    ///
    @inlinable public var isInfinite: Bool {
        !Self.isSigned && Bool(self.appendix)
    }
    
    /// Returns whether this value is less than zero.
    ///
    /// It checks `isSigned`, which is preferred in inlinable generic code.
    ///
    @inlinable public var isNegative: Bool {
        Self.isSigned && Bool(self.appendix)
    }
    
    /// Performs a three-way comparison of `self` versus `zero`.
    @inlinable public borrowing func signum() -> Signum {
        self.compared(to: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Generic
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared<Other>(to other: Other) -> Signum where Other: BinaryInteger {
        if  let lhsSize = UX(size: Self.self), let rhsSize = UX(size: Other.self) {
            if  lhsSize < rhsSize {
                return Other(load: self).compared(to: other)
                
            }   else if lhsSize > rhsSize {
                return self.compared(to: Self(load: other))
                
            }   else if Self.isSigned, !Other.isSigned {
                return self .isNegative ? Signum.less : Other(load: self).compared(to: other)
                
            }   else if !Self.isSigned, Other.isSigned {
                return other.isNegative ? Signum.more : self.compared(to: Self(load:  other))
                
            }   else {
                return self.compared(to: Self(load: other))
            }
            
        }   else {
            //  note that the elements must be rebindable one way or the other
            if  Other.elementsCanBeRebound(to: Self.Element.Magnitude.self) {
                return self.withUnsafeBinaryIntegerElements { lhs in
                    (other).withUnsafeBinaryIntegerElements(as: Self.Element.Magnitude.self) { rhs in
                        DataInt.compare(
                            lhs: lhs, lhsIsSigned: Self .isSigned,
                            rhs: rhs, rhsIsSigned: Other.isSigned
                        )
                    }!
                }
                
            }   else {
                Swift.assert(Self.elementsCanBeRebound(to: Other.Element.Magnitude.self))
                return self.withUnsafeBinaryIntegerElements(as: Other.Element.Magnitude.self) { lhs in
                    (other).withUnsafeBinaryIntegerElements { rhs in
                        DataInt.compare(
                            lhs: lhs, lhsIsSigned: Self .isSigned,
                            rhs: rhs, rhsIsSigned: Other.isSigned
                        )
                    }
                }!
            }
        }
    }
}
