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
                DataInt.signum(of: $0, mode: Self.mode)
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
    
    @inlinable public static func !=<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) != Signum.same
    }
    
    @inlinable public static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) == Signum.less
    }
    
    @inlinable public static func >=<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) != Signum.less
    }
    
    @inlinable public static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) == Signum.more
    }
    
    @inlinable public static func <=<Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger {
        lhs.compared(to: rhs) != Signum.more
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public func compared<Other>(to other: Other) -> Signum where Other: BinaryInteger {
        if !Self.size.isInfinite, !Other.size.isInfinite {
            if  Self.isSigned == Other.isSigned {
                if  Self.size < Other.size {
                    return Other(load: self).compared(to: other)
                }   else {
                    return self.compared(to: Self(load: other))
                }
                
            }   else if Self.isSigned {
                if  Self.size > Other.size {
                    return self.compared(to: Self(load: other))
                }   else {
                    return self.isNegative ? Signum.less : Other(load: self).compared(to: other)
                }
                
            }   else /* if Other.isSigned */ {
                if  Self.size < Other.size {
                    return Other(load: self).compared(to: other)
                }   else {
                    return other.isNegative ? Signum.more : self.compared(to: Self(load: other))
                }
            }
            
        }   else if Self.Element.Magnitude.size <= Other.Element.Magnitude.size {
            return self.withUnsafeBinaryIntegerElements { lhs in
                (other).withUnsafeBinaryIntegerElements(as: Self.Element.Magnitude.self) { rhs in
                    DataInt.compare(
                        lhs: lhs, mode: Self .mode,
                        rhs: rhs, mode: Other.mode
                    )
                }
            }
            
        }   else {
            return self.withUnsafeBinaryIntegerElements(as: Other.Element.Magnitude.self) { lhs in
                (other).withUnsafeBinaryIntegerElements { rhs in
                    DataInt.compare(
                        lhs: lhs, mode: Self .mode,
                        rhs: rhs, mode: Other.mode
                    )
                }
            }
        }
    }
}
