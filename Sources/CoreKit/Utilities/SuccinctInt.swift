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

/// A succinct binary integer.
///
/// ### Comparison
///
/// You can use this model to compare arbitrary untyped binary integers.
///
/// ```swift
/// SuccintInt(UX.max.words[...], isSigned: true ).compated(to: SuccintInt(UX.max.words[...], isSigned: true )) //  0
/// SuccintInt(UX.max.words[...], isSigned: true ).compated(to: SuccintInt(UX.max.words[...], isSigned: false)) // -1
/// SuccintInt(UX.max.words[...], isSigned: false).compated(to: SuccintInt(UX.max.words[...], isSigned: true )) //  1
/// SuccintInt(UX.max.words[...], isSigned: false).compated(to: SuccintInt(UX.max.words[...], isSigned: false)) //  0
/// ```
///
@frozen public struct SuccinctInt<Base>: Comparable where
Base: RandomAccessCollection, Base.Element: UnsignedInteger & SystemsInteger {
    
    public enum Error: Swift.Error { case validation }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let body: Base
    public let sign: Base.Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unchecked body: Base, sign: Base.Element) {
        Swift.assert(Self.validate(body, sign: sign))
        
        self.body = body
        self.sign = sign
    }
    
    @inlinable public init(exactly body: Base, sign: Base.Element) throws {
        if  Self.validate(body, sign: sign) {
            self.body = body
            self.sign = sign
        }   else {
            throw Error.validation
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func validate(_ body: Base, sign: Base.Element) -> Bool {
        body.last != sign && (sign &+ 1 < 2)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Trimming
//=----------------------------------------------------------------------------=

extension SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Base, isSigned: Bool) where Base == Base.SubSequence {
        let isLessThanZero = SBISS.isLessThanZero(source, isSigned: isSigned)
        let sign = Base.Element.init(repeating: Bit.init(isLessThanZero))
        self.init(unchecked: source.dropLast(while:{ $0 == sign }), sign: sign)
    }
    
    @inlinable public init<T>(_ source: Base, isSigned: Bool) where Base == UnsafeBufferPointer<T> {
        self.init(rebasing: CoreKit.SuccinctInt(source[...], isSigned: isSigned))
    }
    
    @inlinable public init<T>(_ source: Base, isSigned: Bool) where Base == UnsafeMutableBufferPointer<T> {
        self.init(rebasing: CoreKit.SuccinctInt(source[...], isSigned: isSigned))
    }
    
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
    @inlinable package func compared<T>(toSameSignUnchecked other: SuccinctInt<T>) -> Signum where T.Element == Base.Element {
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
    @inlinable package func compared<T>(toSameSignSameSizeUnchecked other: SuccinctInt<T>) -> Signum where T.Element == Base.Element {
        //=--------------------------------------=
        Swift.assert(self.sign == other.sign)
        Swift.assert(self.body.count == other.body.count)
        //=--------------------------------------=
        // UX By UX, Back To Front
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
