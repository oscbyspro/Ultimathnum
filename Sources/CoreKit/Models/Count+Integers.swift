//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count x Integers
//*============================================================================*

extension Count {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x T.init(_:)
    //=------------------------------------------------------------------------=
    
    /// Loads the `source` by trapping on `error` and `nil`.
    ///
    /// ```swift
    /// Self.exactly(source)!.unwrap()
    /// ```
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public init(_ source: consuming Natural<IX>) {
        self.base = source.value
    }
    
    /// Loads the `source` by trapping on `error` and `nil`.
    ///
    /// ```swift
    /// Self.exactly(source)!.unwrap()
    /// ```
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public init(_ source: consuming IX) {
        self.init(Natural(source))
    }
    
    /// Loads the `source` by trapping on `error` and `nil`.
    ///
    /// ```swift
    /// Self.exactly(source)!.unwrap()
    /// ```
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public init(_ source: /*borrowing*/ some BinaryInteger) {
        self.init(IX.exactly(source).unwrap())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x T.init?(load:)
    //=------------------------------------------------------------------------=
    
    /// Loads the `source` by wrapping on `error` or returns `nil`.
    ///
    /// ```swift
    /// Self.exactly(source)?.value
    /// ```
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public init?(load source: consuming IX) {
        guard let source = Self.exactly(source)?.value else { return nil }
        self  = ((source))
    }
    
    /// Loads the `source` by wrapping on `error` or returns `nil`.
    ///
    /// ```swift
    /// Self.exactly(source)?.value
    /// ```
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public init?(load source: some BinaryInteger) {
        guard let source = Self.exactly(source)?.value else { return nil }
        self  = ((source))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x T.exactly(_:)
    //=------------------------------------------------------------------------=
    
    /// Loads the `source` and returns an `error` indicator, or `nil`.
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public static func exactly(_ source: consuming IX) -> Optional<Fallible<Self>> {
        if !source.isNegative {
            return Fallible(Self(raw: source))
            
        }   else if let source = source.decremented().optional() {
            return Fallible(Self(raw: source), error: true)
            
        }   else {
            return nil
        }
    }
    
    /// Loads the `source` and returns an `error` indicator, or `nil`.
    ///
    /// - Note: It is `nil` if `source` is not in  `[-IX.max, IX.max]`.
    ///
    /// - Note: The `error` is set if `source` is not in `[0, IX.max]`.
    ///
    /// - Note: `Count.init(_: Natural<IX>)` guarantees exact results.
    ///
    /// ### Examples
    ///
    ///     ┌──────────── → ──────────────────────────┬───────┐
    ///     │ source      │ value                     │ error │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.max  + 2 │ ------------------------- │ ----- │
    ///     │ IX.max  + 1 │ ------------------------- │ ----- │
    ///     │ IX.max      │ IX.max                    │ false │
    ///     │ IX.max  - 1 │ IX.max  - 1               │ false │
    ///     │ IX.max  - 2 │ IX.max  - 2               │ false │
    ///     ├─────────── → ───────────────────────────┼───────┤
    ///     │ IX.zero + 2 │ IX.zero + 2               │ false │
    ///     │ IX.zero + 1 │ IX.zero + 1               │ false │
    ///     │ IX.zero     │ IX.zero                   │ false │
    ///     │ IX.zero - 1 │ log2(&0 + 1) - 1          │ true  │
    ///     │ IX.zero - 2 │ log2(&0 + 1) - 2          │ true  │
    ///     ├──────────── → ──────────────────────────┼───────┤
    ///     │ IX.min  + 2 │ log2(&0 + 1) - IX.max - 1 │ true  │
    ///     │ IX.min  + 1 │ log2(&0 + 1) - IX.max     │ true  │
    ///     │ IX.min      │ ------------------------- │ ----- │
    ///     │ IX.min  - 1 │ ------------------------- │ ----- │
    ///     │ IX.min  - 2 │ ------------------------- │ ----- │
    ///     └──────────── → ──────────────────────────┴───────┘
    ///
    /// - Note: Binary integers cannot represent values near `log2(&0+1)`.
    ///
    /// ### Development
    ///
    /// - Note: `log2(&0+1)` must be a power of `2` to load negative values.
    ///
    @inlinable public static func exactly(_ source: borrowing some BinaryInteger) -> Optional<Fallible<Self>> {
        IX.exactly(source).optional().flatMap(Self.exactly)
    }
}
