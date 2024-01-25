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
/// - TODO: Consider using this model to replace `SuccintInt`.
///
@frozen public struct SequenceInt<Base, Element>: RandomAccessCollection  where
Element: SystemsInteger & UnsignedInteger, Base:  RandomAccessCollection, Base.Element: SystemsInteger & UnsignedInteger {
    
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
    
    /// Creates a sequence of the given type from a bit pattern source.
    ///
    /// - Parameters:
    ///   - base: The source viewed through this sequence.
    ///   - bit:  The bit which extends the base sequence.
    ///   - element: The type of element produced by this sequence.
    ///
    @inlinable public init(_ base: Base, repeating bit: Bit, as element: Element.Type = Element.self) {
        self.init(base, repeating: Bit.Extension(repeating: bit), count: Self.count(of: base))
    }
    
    /// Creates a sequence of the given type from a bit pattern source.
    ///
    /// - Parameters:
    ///   - base: The source viewed through this sequence.
    ///   - element: The element which extends the base sequence.
    ///   - count: The number of prefixing elements to view.
    ///
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
    
    @inlinable public func chunked<Other>(as type: Other.Type = Other.self) -> SequenceInt<Base, Other> where Element == Base.Element {
        CoreKit.SequenceInt(self.base, repeating: self.extension.bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Sendable
//=----------------------------------------------------------------------------=

extension SequenceInt: Sendable where Base: Sendable { }
