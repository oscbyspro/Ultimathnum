//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int
//*============================================================================*

/// A sequence that chunks elements of an un/signed source.
///
/// ```swift
/// for word: UX in SequenceInt(source, isSigned: false, count: nil) { ... }
/// for byte: U8 in SequenceInt(source, isSigned: false, count: nil) { ... }
/// ```
///
/// ### Bit Sequence
///
/// You can create a bit sequence by chunking as `1-bit` integers.
///
/// ```swift
/// for bit: U1 in SequenceInt(base, isSigned: false).succinct().reversed() {
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
/// [1, 2, 3, 4] == Array(SequenceInt(([0x0201, 0x0403] as [U16]),            as: U8.self))
/// [2, 1, 4, 3] == Array(SequenceInt(([0x0201, 0x0403] as [U16]).reversed(), as: U8.self).reversed())
/// [3, 4, 1, 2] == Array(SequenceInt(([0x0201, 0x0403] as [U16]).reversed(), as: U8.self))
/// [4, 3, 2, 1] == Array(SequenceInt(([0x0201, 0x0403] as [U16]),            as: U8.self).reversed())
/// ```
///
/// ```swift
/// [0x0201, 0x0403] == Array(SequenceInt(([1, 2, 3, 4] as [U8]),            as: U16.self))
/// [0x0102, 0x0304] == Array(SequenceInt(([1, 2, 3, 4] as [U8]).reversed(), as: U16.self).reversed())
/// [0x0403, 0x0201] == Array(SequenceInt(([1, 2, 3, 4] as [U8]),            as: U16.self).reversed())
/// [0x0304, 0x0102] == Array(SequenceInt(([1, 2, 3, 4] as [U8]).reversed(), as: U16.self))
/// ```
///
/// ### Development
///
/// - TODO: Consider `appendix` bit vs current `sign` element.
///
/// - TODO: Consider using this model to replace `EndlessInt` and `SuccintInt`.
///
@frozen public struct SequenceInt<Base, Element>: RandomAccessCollection  where
Element: SystemsInteger & UnsignedInteger, Base: RandomAccessCollection, Base.Element: SystemsInteger & UnsignedInteger {
    
    public typealias Base = Base
    
    public typealias Indices = Range<Int>
        
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
    public let `base`: Base
    
    /// The bit extension of the un/signed source.
    public let `extension`: Bit.Extension<Element>
    
    /// The length of this sequence.
    public var `count`: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type from an un/signed source.
    ///
    /// - Parameters:
    ///   - base: The source viewed through this sequence.
    ///   - isSigned: The signedness of the base sequence.
    ///   - element: The type of element produced by this sequence.
    ///
    @inlinable public init(_ base: Base, isSigned: Bool, as element: Element.Type = Element.self) {
        self.init(base, repeating: Bit(bitPattern: SBISS.isLessThanZero(base, isSigned: isSigned)))
    }
    
    @inlinable public init(_ base: Base, repeating bit: Bit, as element: Element.Type = Element.self) {
        self.init(base, repeating: Bit.Extension(repeating: bit), count: Self.count(of: base))
    }
    
    @inlinable public init(_ base: Base, repeating element: Bit.Extension<Element>, count: Int) {
        //=--------------------------------------=
        self.base  = base
        self.extension = element
        self.count = count
        //=--------------------------------------=
        Swift.assert(count >= Int.zero, String.indexOutOfBounds())
        Swift.assert(Self.Element.bitWidth.count(1, option: .all) == 1)
        Swift.assert(Base.Element.bitWidth.count(1, option: .all) == 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func prefix(_ count: Int) -> Self {
        precondition(count >= 0, String.indexOutOfBounds())
        self.count = count
        return consume self
    }
    
    @inlinable consuming public func prefix(minLength: Int) -> Self {
        self.count = Swift.max(self.count,  minLength)
        return consume self
    }
    
    @inlinable consuming public func prefix(maxLength: Int) -> Self {
        self.count = Swift.min(self.count,  maxLength)
        return consume self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func succinct() -> Self {
        let count = Self.count(trimming: self.base, repeating: self.extension.bit)
        return self.prefix(count) as Self
    }
    
    @inlinable public /* consuming */ func chunked<Other>(as type: Other.Type = Other.self) -> SequenceInt<Base, Other> where Element == Base.Element {
        SequenceInt<Base, Other>(self.base, repeating: self.extension.bit)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func makeIterator() -> Iterator {
        Iterator(self, from: Int.zero)
    }
    
    @inlinable public consuming func makeBinaryIntegerStream() -> BinaryIntegerStream {
        BinaryIntegerStream(self, from: Int.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static var comparison: Signum {
        Self.Element.bitWidth.load(as: UX.self).compared(to: Base.Element.bitWidth.load(as: UX.self))
    }
    
    @inlinable internal static func count(of base: Base) -> Int {
        switch comparison {
        case Signum.less: return Minor.count(of: base)
        case Signum.same: return Equal.count(of: base)
        case Signum.more: return Major.count(of: base)
        }
    }
    
    @inlinable internal static func count(trimming base: Base, repeating bit: Bit) -> Int {
        switch comparison {
        case Signum.less: return Minor.count(trimming: base, repeating: bit)
        case Signum.same: return Equal.count(trimming: base, repeating: bit)
        case Signum.more: return Major.count(trimming: base, repeating: bit)
        }
    }
    
    @inlinable internal static func element(_ index: Int, base: Base, sign: Element) -> Element {
        switch comparison {
        case Signum.less: return Minor.element(index, base: base, sign: sign)
        case Signum.same: return Equal.element(index, base: base, sign: sign)
        case Signum.more: return Major.element(index, base: base, sign: sign)
        }
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    @frozen public struct Iterator: IteratorProtocol {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var instance: SequenceInt
        @usableFromInline var position: SequenceInt.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ instance: SequenceInt, from position: SequenceInt.Index) {
            self.instance = instance
            self.position = position
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            self.instance.distance(from: self.position, to: self.instance.endIndex)
        }
        
        @inlinable mutating public func next() -> Element? {
            guard self.position < self.instance.endIndex else {
                return nil
            }
            
            defer {
                self.instance.formIndex(after: &self.position)
            }
            
            return self.instance[self.position] as Element
        }
    }
    
    //*========================================================================*
    // MARK: * Binary Integer Stream
    //*========================================================================*
    
    @frozen public struct BinaryIntegerStream {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var instance: SequenceInt
        @usableFromInline var position: SequenceInt.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ instance: SequenceInt, from position: SequenceInt.Index) {
            self.instance = instance
            self.position = position
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating public func next() -> Element {
            defer {
                self.position = self.position < self.instance.endIndex ? self.instance.index(after: self.position) : self.position
            }
            
            return self.instance[self.position] as Element
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func succinct() -> Iterator {
            var index: SequenceInt.Index = self.instance.endIndex
                        
            trimming: while self.position < index {
                let predecessorIndex = self.instance.index(before: index)
                guard self.instance[predecessorIndex] == self.instance.extension.element else { break }
                index = predecessorIndex as SequenceInt.Index
            }
            
            return Iterator(self.instance.prefix(index), from: self.position)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Sendable
//=----------------------------------------------------------------------------=

extension SequenceInt: Sendable where Base: Sendable { }

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension SequenceInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let major = Element.bitWidth
        let minor = Element.Magnitude(load: Base.Element.bitWidth.load(as: UX.self))
        return (major &>> minor.count(0, option: .ascending)).load(as: Int.self)
    }
    
    /// ### Development
    ///
    /// - TODO: Division by power of two.
    ///
    @inlinable static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let dividend  = base.count
        let quotient  = dividend &>> self.ratio.trailingZeroBitCount
        let remainder = dividend &  (self.ratio - 1)
        return quotient + (remainder > 0 ? 1 : 0)
    }
    
    @inlinable static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.more, String.unreachable())
        //=--------------------------------------=
        var major = 0 as Element
        var shift = 0 as Element.Magnitude
        let minor = self.ratio * index
        
        if  minor < base.count {
            var   baseIndex = base.index(base.startIndex, offsetBy: minor)
            while baseIndex < base.endIndex, shift < Element.bitWidth {
                major = major | PBI.load(Base.Element.Magnitude(bitPattern: base[baseIndex]), as: Element.self) &<< Element(bitPattern: shift)
                shift = shift + Element.Magnitude(load: Base.Element.bitWidth.load(as: UX.self))
                base.formIndex(after: &baseIndex)
            }
        }
        
        return shift >= Element.bitWidth ? major : major | sign &<< Element(bitPattern: shift)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension SequenceInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        let major = Base.Element.bitWidth
        let minor = Base.Element.Magnitude(load: Element.bitWidth.load(as: UX.self))
        return (major &>> minor.count(0, option: .ascending)).load(as: Int.self)
    }
    
    @inlinable static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        return base.count * self.ratio as Int
    }
    
    @inlinable static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        let majorSuffix = base.reversed().prefix(while:{ $0 == sign })
        let minorSuffix = base.dropLast(majorSuffix.count).last?.count(bit, option: Bit.Selection.descending) ?? (00000)
        let totalSuffix = majorSuffix.count *  Base.Element.bitWidth.load(as: Int.self) + minorSuffix.load(as: Int.self)
        return self.count(of: base) - totalSuffix / Element.bitWidth.load(as: Int.self)
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.less, String.unreachable())
        //=--------------------------------------=
        precondition(index >= 0 as Int, String.indexOutOfBounds())
        let quotient  = index &>> self.ratio.trailingZeroBitCount
        let remainder = index &  (self.ratio - 1)
        //=--------------------------------------=
        if  quotient >= base.count { return sign }
        //=--------------------------------------=
        let major = base[base.index(base.startIndex, offsetBy: quotient)]
        let shift = Base.Element(load: UX(bitPattern: remainder)) &<< Base.Element(load: Element.bitWidth.count(0, option: .ascending).load(as: UX.self))
        return PBI.load(major &>> shift, as: Element.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equal
//=----------------------------------------------------------------------------=

extension SequenceInt.Equal {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func count(of base: some Collection<Base.Element>) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        return base.count as Int as Int as Int
    }
    
    @inlinable static func count(trimming base: Base, repeating bit: Bit) -> Int {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        let sign = Base.Element(repeating: bit)
        return self.count(of: base.reversed().trimmingPrefix(while:{ $0 == sign }))
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        //=--------------------------------------=
        precondition(SequenceInt.comparison == Signum.same, String.unreachable())
        //=--------------------------------------=
        if  index >= base.count { return sign }
        //=--------------------------------------=
        return PBI.bitCastOrLoad(base[base.index(base.startIndex, offsetBy: index)], as: Element.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The element at the given index.
    ///
    /// Its elements are ordered from least significant to most, with infinite sign extension.
    ///
    @inlinable public subscript(index: Int) -> Element {
        Self.element(index, base: self.base, sign: self.extension.element)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
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
