//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Shift
//*============================================================================*

/// A value from zero up to the target's size.
///
/// ### Guarantee
///
/// Validate values with these methods:
///
/// ```swift
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(_:)         // error: precondition
/// init(unchecked:) // error: assert
/// init(unsafe:)    // error: %%%%%%
/// ```
///
@frozen public struct Shift<Target>: Equatable, Guarantee where Target: UnsignedInteger {
    
    public typealias Target = Target
    
    public typealias Value  = Count
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: borrowing Value) -> Bool {
        value < Target.size
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// The minimum bit index of the target binary integer type.
    ///
    /// - Returns: Zero.
    ///
    @inlinable public static var min: Self {
        Self(unchecked: Count.zero)
    }
    
    /// A bit index of `1`.
    ///
    /// - Note: Shifting by `1` is common and the minimum binary integer size is `8`.
    ///
    @inlinable public static var one: Self {
        Self(unchecked: Count(raw: IX.lsb))
    }
    
    /// The maximum bit index of the target binary integer type.
    ///
    ///     ┌──────┬───────────────────────┐
    ///     │ type │ Shift.max             │
    ///     ├──────┼───────────────────────┤
    ///     │ I64  │ 63                    │
    ///     │ IXL  │ log2(UXL.max + 1) - 1 │
    ///     └──────┴───────────────────────┘
    ///
    /// - Note: The `size` of a binary integer is a power of `2`.
    ///
    @inlinable public static var max: Self {
        Self(unchecked: Count(raw: IX(raw: Target.size).decremented().unchecked()))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unsafe value: consuming Value) {
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this value is zero.
    @inlinable public var isZero: Bool {
        self.value.isZero
    }
    
    /// Indicates whether this value is infinite.
    @inlinable public var isInfinite: Bool {
        Target.size.isInfinite && self.value.isInfinite
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the inverse of `self` unless `self` is zero.
    ///
    /// ```swift
    /// Shift(0 as I8).inverse() // nil
    /// Shift(1 as I8).inverse() // 7
    /// Shift(2 as I8).inverse() // 6
    /// Shift(3 as I8).inverse() // 5
    /// Shift(4 as I8).inverse() // 4
    /// Shift(5 as I8).inverse() // 3
    /// Shift(6 as I8).inverse() // 2
    /// Shift(7 as I8).inverse() // 1
    /// ```
    ///
    @inlinable public borrowing func inverse() -> Optional<Self> {
        if  self.isZero {
            return nil
            
        }   else {
            let difference = IX(raw: Target.size).minus(IX(raw: self.value))
            return Self(unchecked: Count(raw: difference.unchecked()))
        }
    }
    
    /// Returns its raw `value` and an `error` indicator.
    ///
    ///     ┌───────────────────────┬───────────────┐
    ///     │ self                  │ value │ error │
    ///     ├───────────────────────┼───────┼───────┤
    ///     │ 0                     │  0    │ false │
    ///     │ 1                     │  1    │ false │
    ///     │ 2                     │  2    │ false │
    ///     ├───────────────────────┼───────┼───────┤
    ///     │ log2(UXL.max + 1) - 2 │ -3    │ true  │
    ///     │ log2(UXL.max + 1) - 1 │ -2    │ true  │
    ///     │ log2(UXL.max + 1)     │ -1    │ true  │
    ///     └───────────────────────┴───────┴───────┘
    ///
    /// - Note: The `error` is set if `self` is infinite.
    ///
    @inlinable public func natural() -> Fallible<IX> {
        Fallible(IX(raw: self.value), error: self.isInfinite)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conveniences
//=----------------------------------------------------------------------------=

extension Shift where Target: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(masking value: some BinaryInteger) {
        let mask = IX(size: Target.self).decremented().unchecked()
        self.init(unchecked: Count(raw: IX(load: value) & mask))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `value` of `self`.
    ///
    ///     ┌───────────────────────┬───────────────┐
    ///     │ self                  │ value │ error │
    ///     ├───────────────────────┼───────┼───────┤
    ///     │ 0                     │  0    │ false │
    ///     │ 1                     │  1    │ false │
    ///     │ 2                     │  2    │ false │
    ///     ├───────────────────────┼───────┼───────┤
    ///     │ log2(UXL.max + 1) - 2 │ -3    │ true  │
    ///     │ log2(UXL.max + 1) - 1 │ -2    │ true  │
    ///     │ log2(UXL.max + 1)     │ %%%%% │ %%%%% │
    ///     └───────────────────────┴───────┴───────┘
    ///
    /// - Note: All systems integer `Shift(s)` are natural.
    ///
    @inlinable public func natural() -> IX {
        self.value.natural().unchecked("SystemsInteger")
    }
}
