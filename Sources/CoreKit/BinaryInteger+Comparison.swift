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
    /// - Note: Big integers evaluate it in place, cf. `compared(to: 0)`.
    ///
    @inlinable public var isNegative: Bool {
        Self.isSigned && Bool(self.appendix)
    }
    
    /// Indicates whether this value is greater than zero.
    ///
    /// - Note: Big integers evaluate it in place, cf. `compared(to: 0)`.
    ///
    @inlinable public var isPositive: Bool {
        if !Self.isArbitrary {
            return self > Self.zero
            
        }   else if Bool(self.appendix) {
            return !Self.isSigned
            
        }   else {
            return self.withUnsafeBinaryIntegerBody {
                !$0.isZero
            }
        }
    }
    
    /// Indicates whether this value is equal to zero.
    ///
    /// - Note: Big integers evaluate it in place, cf. `compared(to: 0)`.
    ///
    @inlinable public var isZero: Bool {
        if !Self.isArbitrary {
            return self == Self.zero
            
        }   else {
            return self.withUnsafeBinaryIntegerElements {
                $0.isZero
            }
        }
    }
    
    /// Indicates whether this value is a power of `2`
    @inlinable public var isPowerOf2: Bool {
        if  Self.size == Element.size {
            return self.isPositive && (self & (self &- 1)).isZero
            
        }   else {
            return self.withUnsafeBinaryIntegerElements {
                $0.isPowerOf2
            }
        }
    }
    
    /// Performs a three-way comparison of `self` versus `zero`.
    ///
    /// - Note: Big integers evaluate it in place, cf. `compared(to: 0)`.
    ///
    @inlinable public borrowing func signum() -> Signum {
        if !Self.isArbitrary {
            return self.compared(to: Self.zero)
            
        }   else {
            return self.withUnsafeBinaryIntegerElements {
                DataInt.signum(of: $0, mode: Self.mode)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Hashes the normalized 8-bit data integer elements of `self`.
    ///
    /// ```swift
    /// #expect(random.hashValue == IXL(load: random).hashValue)
    /// #expect(random.hashValue == UXL(load: random).hashValue)
    /// ```
    ///
    @inlinable public borrowing func hash(into hasher: inout Swift.Hasher) {
        self.withUnsafeBinaryIntegerElements(as: U8.self) {
            let normalized: DataInt<U8> = $0.normalized()
            hasher.combine(bytes: normalized.body.bytes())
            hasher.combine(normalized.appendix)
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
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing some BinaryInteger) -> Bool {
        Namespace.compare(lhs, to: rhs, using: Namespace.IsSame())
    }
    
    @inlinable public static func !=(lhs: borrowing Self, rhs: borrowing some BinaryInteger) -> Bool {
        !(lhs == rhs)
    }
    
    @inlinable public static func < (lhs: borrowing Self, rhs: borrowing some BinaryInteger) -> Bool {
        Namespace.compare(lhs, to: rhs, using: Namespace.IsLess())
    }
    
    @inlinable public static func >=(lhs: borrowing Self, rhs: borrowing some BinaryInteger) -> Bool {
        !(lhs <  rhs)
    }
    
    @inlinable public static func > (lhs: borrowing Self, rhs: borrowing some BinaryInteger) -> Bool {
        ((rhs <  lhs))
    }
    
    @inlinable public static func <=(lhs: borrowing Self, rhs: borrowing some BinaryInteger) -> Bool {
        !(lhs >  rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs a three-way comparison of `self` versus `other`.
    @inlinable public borrowing func compared(to other: borrowing some BinaryInteger) -> Signum {
        Namespace.compare(self, to: other, using: Namespace.Compare())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Generic x Code Block
//=----------------------------------------------------------------------------=

extension Namespace {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// Each specialization can be reduced to `1` or `2` of its many branches.
    ///
    @inline(__always) @inlinable internal static func compare<LHS, RHS, Algorithm>(
        _  lhs: /*borrowing*/ LHS,
        to rhs: /*borrowing*/ RHS,
        using comparator: Algorithm
    ) -> Algorithm.Result where LHS: BinaryInteger, RHS: BinaryInteger, Algorithm: Comparator {
        
        if !LHS.isArbitrary, !RHS.isArbitrary {
            switch LHS.mode {
            case   RHS.mode:
                
                if  LHS.size < RHS.size {
                    comparator.compare(RHS(load: lhs), to: rhs)
                    
                }   else {
                    comparator.compare(lhs, to: LHS(load: rhs))
                }
                
            case Signedness.signed:
                
                if  LHS.size > RHS.size {
                    comparator.compare(lhs, to: LHS(load: rhs))
                    
                }   else if lhs.isNegative {
                    comparator.resolve(Signum.negative)
                    
                }   else {
                    comparator.compare(RHS(load: lhs), to: rhs)
                }
                
            case Signedness.unsigned:
                
                if  LHS.size < RHS.size {
                    comparator.compare(RHS(load: lhs), to: rhs)
                    
                }   else if rhs.isNegative {
                    comparator.resolve(Signum.positive)
                    
                }   else {
                    comparator.compare(lhs, to: LHS(load: rhs))
                }
            }
            
        }   else {
            lhs.withUnsafeBinaryIntegerElements { lhs in
                rhs.withUnsafeBinaryIntegerElements { rhs in
                    comparator.resolve(DataInt.compare(lhs: lhs, mode: LHS.mode, rhs: rhs, mode: RHS.mode))
                }
            }
        }
    }
}
