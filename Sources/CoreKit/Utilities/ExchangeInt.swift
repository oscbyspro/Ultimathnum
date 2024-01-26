//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int
//*============================================================================*

/// A sequence that chunks elements of an un/signed source.
///
/// ```swift
/// for word: UX in ExchangeInt(base, isSigned: false).source() { ... }
/// for byte: U8 in ExchangeInt(base, isSigned: false).source() { ... }
/// ```
///
/// ### Bit Sequence
///
/// You can create a bit sequence by chunking as `1-bit` integers.
///
/// ```swift
/// for bit: U1 in ExchangeInt(base, isSigned: false).succinct().reversed() {
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
/// [1, 2, 3, 4] == Array(ExchangeInt(([0x0201, 0x0403] as [U16]),            as: U8.self).source())
/// [2, 1, 4, 3] == Array(ExchangeInt(([0x0201, 0x0403] as [U16]).reversed(), as: U8.self).source().reversed())
/// [3, 4, 1, 2] == Array(ExchangeInt(([0x0201, 0x0403] as [U16]).reversed(), as: U8.self).source())
/// [4, 3, 2, 1] == Array(ExchangeInt(([0x0201, 0x0403] as [U16]),            as: U8.self).source().reversed())
/// ```
///
/// ```swift
/// [0x0201, 0x0403] == Array(ExchangeInt(([1, 2, 3, 4] as [U8]),            as: U16.self).source())
/// [0x0102, 0x0304] == Array(ExchangeInt(([1, 2, 3, 4] as [U8]).reversed(), as: U16.self).source().reversed())
/// [0x0403, 0x0201] == Array(ExchangeInt(([1, 2, 3, 4] as [U8]),            as: U16.self).source().reversed())
/// [0x0304, 0x0102] == Array(ExchangeInt(([1, 2, 3, 4] as [U8]).reversed(), as: U16.self).source())
/// ```
///
@frozen public struct ExchangeInt<Base, Element>: BitCastable, Comparable where
Element: SystemsInteger, Base: RandomAccessCollection, Base.Element: SystemsInteger & UnsignedInteger {
    
    public typealias Base = Base
    
    public typealias Index = Int
    
    public typealias Element = Element
    
    /// A namespace for Element.bitWidth \> Base.Element.bitWidth.
    @frozen @usableFromInline enum Major { }
    
    /// A namespace for Element.bitWidth \< Base.Element.bitWidth.
    @frozen @usableFromInline enum Minor { }
    
    /// A namespace for Element.bitWidth == Base.Element.bitWidth.
    @frozen @usableFromInline enum Equal { }
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// Indicate whether this type is signed or unsigned.
    @inlinable public static var isSigned: Bool {
        Element.isSigned
    }
    
    /// Indicates whether this type produces larger, smaller or similar chunks.
    @inlinable public static var comparison: Signum {
        Element.bitWidth.load(as: UX.self).compared(to: Base.Element.bitWidth.load(as: UX.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The un/signed source.
    public let `base`: Base
    
    /// The bit extension of the un/signed source.
    public let `extension`: Bit.Extension<Element>
    
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
        self.init(base, repeating: Bit.Extension(repeating: bit))
    }
    
    /// Creates a sequence of the given type from a bit pattern source.
    ///
    /// - Parameters:
    ///   - base: The source viewed through this sequence.
    ///   - element: The element which extends the base sequence.
    ///   - count: The number of prefixing elements to view.
    ///
    @inlinable public init(_ base: Base, repeating element: Bit.Extension<Element>) {
        //=--------------------------------------=
        self.base = base
        self.extension = element
        //=--------------------------------------=
        Swift.assert(Self.Element.bitWidth.count(1, option: .all) == 1)
        Swift.assert(Base.Element.bitWidth.count(1, option: .all) == 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func chunked<Other>(as type: Other.Type = Other.self) -> ExchangeInt<Base, Other> {
        CoreKit.ExchangeInt(self.base, repeating: self.extension.bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Sendable
//=----------------------------------------------------------------------------=

extension ExchangeInt: Sendable where Base: Sendable { }
