//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Succinct Int
//*============================================================================*

@frozen @usableFromInline package struct SuccinctInt<Base>: Comparable where
Base: RandomAccessCollection, Base.Element: UnsignedInteger & SystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let body: Base
    public let sign: Base.Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T: RandomAccessCollection>(_ source: T, isSigned: Bool) where Base == T.SubSequence {
        let sign = Base.Element(repeating: Bit(isSigned && (source.last ?? Base.Element()) & Base.Element.msb != Base.Element()))
        self.init(unchecked: source.dropLast(while:{ $0 == sign }), sign: sign)
    }
    
    @inlinable public init(unchecked body: Base, sign: Base.Element) {
        Swift.assert(Self.validate(body, sign: sign))
        
        self.body = body
        self.sign = sign
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func validate(_ body: Base, sign: Base.Element) -> Bool {
        body.last != sign && (sign &+ 1 < 2)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an instance using the memory as the given sub sequence.
    @inlinable public init<T>(rebasing other: SuccinctInt<Base.SubSequence>) where Base == UnsafeBufferPointer<T> {
        self.init(unchecked: Base(rebasing: other.body), sign: other.sign)
    }
    
    /// Creates an instance using the memory as the given sub sequence.
    @inlinable public init<T>(rebasing other: SuccinctInt<Base.SubSequence>) where Base == UnsafeMutableBufferPointer<T> {
        self.init(unchecked: Base(rebasing: other.body), sign: other.sign)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Comparison
//=----------------------------------------------------------------------------=

extension SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) ==  0
    }
    
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `self` against `other`.
    @inlinable public func compared<T>(to rhs: SuccinctInt<T>) -> Signum where T.Element == Base.Element {
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  self.sign != rhs.sign {
            return self.sign != 0 ? -1 : 1
        }
        //=---------------------------------------=
        return self.compared(toSameSignUnchecked: rhs)
    }
    
    /// A three-way comparison of `self` against `other`.
    @inlinable public func compared<T>(toSameSignUnchecked other: SuccinctInt<T>) -> Signum where T.Element == Base.Element {
        //=--------------------------------------=
        Swift.assert(self.sign == other.sign)
        //=--------------------------------------=
        // Long & Short
        //=--------------------------------------=
        if  self.body.count != other.body.count {
            return (self.sign != 0) == (self.body.count > other.body.count) ? -1 : 1
        }
        //=--------------------------------------=
        return self.compared(toSameSignSameSizeUnchecked: other)
    }
    
    /// A three-way comparison of `self` against `other`.
    @inlinable public func compared<T>(toSameSignSameSizeUnchecked other: SuccinctInt<T>) -> Signum where T.Element == Base.Element {
        //=--------------------------------------=
        Swift.assert(self.sign == other.sign)
        Swift.assert(self.body.count == other.body.count)
        //=--------------------------------------=
        // Word By Word, Back To Front
        //=--------------------------------------=
        var lhsIndex = self .body.endIndex
        var rhsIndex = other.body.endIndex
        
        backwards: while lhsIndex > self.body.startIndex {
            self .body.formIndex(before: &lhsIndex)
            other.body.formIndex(before: &rhsIndex)
            
            let lhsWord  = self .body[lhsIndex]
            let rhsWord  = other.body[rhsIndex]
            
            if  lhsWord != rhsWord {
                return lhsWord < rhsWord ? -1 : 1
            }
        }
        //=--------------------------------------=
        // Same
        //=--------------------------------------=
        return 0000 as Signum as Signum as Signum
    }
}
