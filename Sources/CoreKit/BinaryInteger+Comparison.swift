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
    
    /// Indicates the role of the `appendix` bit.
    ///
    /// ```
    ///            ┌───────────────┬───────────────┐
    ///            │ appendix == 0 │ appendix == 1 |
    /// ┌──────────┼───────────────┤───────────────┤
    /// │   Signed │     self >= 0 │     self <  0 │
    /// ├──────────┼───────────────┤───────────────┤
    /// │ Unsigned │     self <  ∞ │     self >= ∞ │
    /// └──────────┴───────────────┴───────────────┘
    /// ```
    ///
    @inlinable public static var isSigned: Bool {
        Self.mode == .signed
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this value is greater than all finite values.
    ///
    /// - Note: It checks `isSigned` first, which is preferred in inlinable generic code.
    ///
    @inlinable public var isInfinite: Bool {
        !Self.isSigned && Bool(self.appendix)
    }
    
    /// Indicates whether this value is less than zero.
    ///
    /// - Note: It checks `isSigned` first, which is preferred in inlinable generic code.
    ///
    @inlinable public var isNegative: Bool {
        Self.isSigned && Bool(self.appendix)
    }
    
    /// Indicates whether this value is equal to zero.
    ///
    /// - Note: Big integers evaluate it in place, cf. `compared(to: 0)`.
    ///
    @inlinable public var isZero: Bool {
        if !Self.size.isInfinite {
            return self == Self.zero
            
        }   else {
            return self.withUnsafeBinaryIntegerElements {
                $0.isZero
            }
        }
    }
    
    /// Performs a three-way comparison of `self` versus `zero`.
    ///
    /// - Note: Big integers evaluate it in place, cf. `compared(to: 0)`.
    ///
    @inlinable public borrowing func signum() -> Signum {
        if !Self.size.isInfinite {
            return self.compared(to: Self.zero)
            
        }   else {
            return self.withUnsafeBinaryIntegerElements {
                DataInt.signum(of: $0, isSigned: Self.isSigned)
            }
        }
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
            if  Self.isSigned == Other.isSigned {
                if  lhsSize < rhsSize {
                    return Other(load: self).compared(to: other)
                }   else {
                    return self.compared(to: Self(load: other))
                }
                
            }   else if Self.isSigned {
                if  lhsSize > rhsSize {
                    return self.compared(to: Self(load: other))
                }   else {
                    return self.isNegative ? Signum.less : Other(load: self).compared(to: other)
                }
                
            }   else /* if Other.isSigned */ {
                if  lhsSize < rhsSize {
                    return Other(load: self).compared(to: other)
                }   else {
                    return other.isNegative ? Signum.more : self.compared(to: Self(load: other))
                }
            }
            
        }   else if UX(size: Self.Element.Magnitude.self) <= UX(size: Other.Element.Magnitude.self) {
            return self.withUnsafeBinaryIntegerElements { lhs in
                (other).withUnsafeBinaryIntegerElements(as: Self.Element.Magnitude.self) { rhs in
                    DataInt.compare(
                        lhs: lhs, lhsIsSigned: Self .isSigned,
                        rhs: rhs, rhsIsSigned: Other.isSigned
                    )
                }
            }
            
        }   else {
            return self.withUnsafeBinaryIntegerElements(as: Other.Element.Magnitude.self) { lhs in
                (other).withUnsafeBinaryIntegerElements { rhs in
                    DataInt.compare(
                        lhs: lhs, lhsIsSigned: Self .isSigned,
                        rhs: rhs, rhsIsSigned: Other.isSigned
                    )
                }
            }
        }
    }
}
