//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit

//*============================================================================*
// MARK: * Chunked
//*============================================================================*

/// A sequence that chunks elements of an un/signed source.
///
/// ```swift
/// for word: UX in Chunked(source, isSigned: false, count: nil) { ... }
/// for byte: U8 in Chunked(source, isSigned: false, count: nil) { ... }
/// ```
///
/// ### Bit Sequence
///
/// You can create a bit sequence by chunking as `UMNBitInt`.
///
/// ```swift
/// for bit: U1 in Chunked(normalizing: base, isSigned: false).reversed() {
///     double()
///
///     if  bit == 1 {
///         increment()
///     }
/// }
/// ```
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its elements from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
/// ```swift
/// [1, 2, 3, 4] == Array(Chunked(([0x0201, 0x0403] as [U16]),            as: U8.self))
/// [2, 1, 4, 3] == Array(Chunked(([0x0201, 0x0403] as [U16]).reversed(), as: U8.self).reversed())
/// [3, 4, 1, 2] == Array(Chunked(([0x0201, 0x0403] as [U16]).reversed(), as: U8.self))
/// [4, 3, 2, 1] == Array(Chunked(([0x0201, 0x0403] as [U16]),            as: U8.self).reversed())
/// ```
///
/// ```swift
/// [0x0201, 0x0403] == Array(Chunked(([1, 2, 3, 4] as [U8]),            as: U16.self))
/// [0x0102, 0x0304] == Array(Chunked(([1, 2, 3, 4] as [U8]).reversed(), as: U16.self).reversed())
/// [0x0403, 0x0201] == Array(Chunked(([1, 2, 3, 4] as [U8]),            as: U16.self).reversed())
/// [0x0304, 0x0102] == Array(Chunked(([1, 2, 3, 4] as [U8]).reversed(), as: U16.self))
/// ```
///
@frozen public struct Chunked<Base, Element>: RandomAccessCollection where
Element: SystemInteger, Base: RandomAccessCollection, Base.Element: SystemInteger {
    
    public typealias Base = Base
    
    /// A namespace for Element.bitWidth \> Base.Element.bitWidth.
    @frozen @usableFromInline enum Major { }
    
    /// A namespace for Element.bitWidth \< Base.Element.bitWidth.
    @frozen @usableFromInline enum Minor { }
    
    /// A namespace for Element.bitWidth == Base.Element.bitWidth.
    @frozen @usableFromInline enum Equal { }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The un/signed source.
    public let base: Base
    
    /// The sign extension of the un/signed source.
    public let sign:  Element
    
    /// The length of this sequence.
    public let count: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type from an un/signed source.
    ///
    /// - Parameters:
    ///   - base: The base sequence viewed through this sequence.
    ///   - isSigned: The signedness of the base sequence.
    ///   - count: An optionally chosen number of elements to view.
    ///   - element: The type of element produced by this sequence.
    ///
    @inlinable public init(_ base: Base, isSigned: Bool, count: Int? = nil, as element: Element.Type = Element.self) {
        let bit = Bit(isSigned && (base.last ?? 0) & .msb != 0)
        let count = count ?? Self.count(of: base)
        self.init(base, repeating: bit, count: count)
    }
    
    /// Creates a normalized bit sequence from an un/signed source.
    ///
    /// - Parameters:
    ///   - base: The base sequence viewed through this sequence.
    ///   - isSigned: The signedness of the base sequence.
    ///   - element: The type of element produced by this sequence.
    ///
    @inlinable public init(normalizing base: Base, isSigned: Bool, as element: Element.Type = Element.self) {
        let bit = Bit(isSigned && (base.last ?? 0) & .msb != 0)
        let count = Self.count(normalizing: base, repeating: bit)
        self.init(base, repeating: bit, count: count)
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable internal init(_ base: Base, repeating bit: Bit, count: Int, as element: Element.Type = Element.self) {
        self.base  = base
        self.sign  = Self.Element(repeating: bit)
        self.count = count
        precondition(self.count >= 0 as Int)
        Swift.assert(Self.Element.bitWidth.count(1, option: .all) == 1)
        Swift.assert(Base.Element.bitWidth.count(1, option: .all) == 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: Base) -> Int {
        if  UX(Self.Element.bitWidth) > UX(Base.Element.bitWidth) {
            return Major.count(of:  base)
        }   else if UX(Self.Element.bitWidth) < UX(Base.Element.bitWidth) {
            return Minor.count(of:  base)
        }   else {
            return Equal.count(of:  base)
        }
    }
    
    @inlinable internal static func count(normalizing base: Base, repeating bit: Bit) -> Int {
        if  UX(Self.Element.bitWidth) > UX(Base.Element.bitWidth) {
            return Major.count(normalizing: base, repeating: bit)
        }   else if UX(Self.Element.bitWidth) < UX(Base.Element.bitWidth) {
            return Minor.count(normalizing: base, repeating: bit)
        }   else {
            return Equal.count(normalizing: base, repeating: bit)
        }
    }
    
    @inlinable internal static func element(_ index: Int, base: Base, sign: Element) -> Element {
        if  UX(Self.Element.bitWidth) > UX(Base.Element.bitWidth) {
            return Major.element(index, base: base, sign: sign)
        }   else if UX(Self.Element.bitWidth) < UX(Base.Element.bitWidth) {
            return Minor.element(index, base: base, sign: sign)
        }   else {
            return Equal.element(index, base: base, sign: sign)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Sendable
//=----------------------------------------------------------------------------=

extension Chunked: Sendable where Base: Sendable { }

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension Chunked.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: Int {
        let major = Element.bitWidth
        let minor = Element.Magnitude(truncating: Base.Element.bitWidth)
        return (major / minor).load(as: Int.self)
    }
    
    @inlinable static func count(of base: some Collection<Base.Element>) -> Int {
        try! IX(base.count).divided(by: IX(self.ratio)).ceil().stdlib
    }
    
    @inlinable static func count(normalizing base: Base, repeating bit: Bit) -> Int {
        let sign = Base.Element(repeating: bit)
        return Swift.max(1, self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign })))
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        var major = 0 as Element
        var shift = 0 as Element.Magnitude
        let minor = self.ratio * index
        
        if  minor < base.count {
            var   baseIndex = base.index(base.startIndex, offsetBy: minor)
            while baseIndex < base.endIndex, shift < Element.bitWidth {
                major = major | Element(truncating: Base.Element.Magnitude(bitPattern: base[baseIndex])) &<< Element(bitPattern: shift)
                shift = shift + Element.Magnitude(load: Base.Element.bitWidth.load(as: Word.self))
                base.formIndex(after: &baseIndex)
            }
        }
        
        return shift >= Element.bitWidth ? major : major | sign &<< Element(bitPattern: shift)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension Chunked.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: Int {
        let major = Base.Element.bitWidth
        let minor = Base.Element.Magnitude(truncating: Element.bitWidth)
        return (major / minor).load(as: Int.self)
    }
    
    @inlinable static func count(of base: some Collection<Base.Element>) -> Int {
        base.count *  self.ratio
    }
    
    @inlinable static func count(normalizing base: Base, repeating bit: Bit) -> Int {
        let sign = Base.Element(repeating: bit)
        let majorSuffix = base.reversed().prefix(while:{ $0 == sign })
        let minorSuffix = base.dropLast(majorSuffix.count).last?.count(bit, option: Bit.Selection.descending) ?? (0000)
        let totalSuffix = majorSuffix.count * Base.Element.bitWidth.load(as: Int.self) + minorSuffix.load(as: Int.self)
        return Swift.max(1, self.count(of: base) - totalSuffix / Element.bitWidth.load(as: Int.self))
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        precondition(index >= 0 as Int, .indexOutOfBounds())
        let  (quotient, remainder) = index.quotientAndRemainder(dividingBy: self.ratio)
        guard quotient < base.count else { return sign }
        let major: Base.Element = base[base.index(base.startIndex, offsetBy: quotient)]
        let shift: Base.Element = Base.Element(truncating: IX(remainder)) &* Base.Element(truncating: Element.bitWidth)
        return Element(truncating: major &>> shift) // truncating shift means truncating multiplication is fine
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equal
//=----------------------------------------------------------------------------=

extension Chunked.Equal {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func count(of base: some Collection<Base.Element>) -> Int {
        base.count
    }
    
    @inlinable static func count(normalizing base: Base, repeating bit: Bit) -> Int {
        let sign = Base.Element(repeating: bit)
        return Swift.max(1, self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign })))
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        guard  index < base.count else { return  sign }
        return Element(truncating: base[base.index(base.startIndex, offsetBy: index)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension Chunked {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        0 as Int
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
    @inlinable public var indices: Range<Int> {
        0 as Int ..< self.count
    }
    
    /// Returns the element at the given index.
    ///
    /// The elements are ordered from least significant to most, with infinite sign extension.
    ///
    @inlinable public subscript(index: Int) -> Element {
        Self.element(index, base: self.base, sign: self.sign)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        index + 1 as Int
    }
    
    @inlinable public func index(before index: Int) -> Int {
        index - 1 as Int
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        index + distance
    }
}
