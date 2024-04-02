//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * System Integer x Collection
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns the first element.
    @inlinable public static func prefix1<T: Collection>(
        _ base: T
    )   -> Self where T.Element: SystemsInteger<BitPattern> {
        var index = base.startIndex as T.Index
        return self.prefix1(base, pushing: &index)
    }
    
    /// Returns the first element by pushing the given `index`.
    @inlinable public static func prefix1<T: Collection>(
        _ base: T,
        pushing index: inout T.Index
    )   -> Self where T.Element: SystemsInteger<BitPattern> {
        defer {
            base.formIndex(after: &index)
        }
        return Self(bitPattern: base[index])
    }
    
    /// Returns the first two elements.
    @inlinable public static func prefix2<T: Collection>(
        _ base: T
    )   -> Doublet<Self> where T.Element: SystemsInteger<BitPattern> {
        var index = base.startIndex as T.Index
        return self.prefix2(base, pushing: &index)
    }
    
    /// Returns the first two elements by pushing the given `index`.
    @inlinable public static func prefix2<T: Collection>(
        _ base: T,
        pushing index: inout T.Index
    )   -> Doublet<Self> where T.Element: SystemsInteger<BitPattern> {
        let low  = Magnitude.prefix1(base, pushing: &index)
        let high = Self/*-*/.prefix1(base, pushing: &index)
        return Doublet(low: low, high: high)
    }
    
    /// Returns the first three elements.
    @inlinable public static func prefix3<T: Collection>(
        _ base: T
    )   -> Triplet<Self> where T.Element: SystemsInteger<BitPattern> {
        var index = base.startIndex as T.Index
        return self.prefix3(base, pushing: &index)
    }
    
    /// Returns the first three elements by pushing the given `index`.
    @inlinable public static func prefix3<T: Collection>(
        _ base: T,
        pushing index: inout T.Index
    )   -> Triplet<Self> where T.Element: SystemsInteger<BitPattern> {
        let low  = Magnitude.prefix1(base, pushing: &index)
        let mid  = Magnitude.prefix1(base, pushing: &index)
        let high = Self/*-*/.prefix1(base, pushing: &index)
        return Triplet(low: low, mid: mid, high: high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns the last element.
    @inlinable public static func suffix1<T: BidirectionalCollection>(
        _ base: T
    )   -> Self where T.Element: SystemsInteger<BitPattern> {
        var index = base.endIndex as T.Index
        return self.suffix1(base, pulling: &index)
    }
    
    /// Returns the last element by pulling the given `index`.
    @inlinable public static func suffix1<T: BidirectionalCollection>(
        _ base: T,
        pulling index: inout T.Index
    )   -> Self where T.Element: SystemsInteger<BitPattern> {
        base.formIndex(before: &index)
        return Self(bitPattern: base[index])
    }
    
    /// Returns the last two elements.
    @inlinable public static func suffix2<T: BidirectionalCollection>(
        _ base: T
    )   -> Doublet<Self> where T.Element: SystemsInteger<BitPattern> {
        var index = base.endIndex as T.Index
        return self.suffix2(base, pulling: &index)
    }
    
    /// Returns the last two elements by pulling the given `index`.
    @inlinable public static func suffix2<T: BidirectionalCollection>(
        _ base: T,
        pulling index: inout T.Index
    )   -> Doublet<Self> where T.Element: SystemsInteger<BitPattern> {
        let high = Self/*-*/.suffix1(base, pulling: &index)
        let low  = Magnitude.suffix1(base, pulling: &index)
        return Doublet(high: high, low: low)
    }
    
    /// Returns the last two elements.
    @inlinable public static func suffix3<T: BidirectionalCollection>(
        _ base: T
    )   -> Triplet<Self> where T.Element: SystemsInteger<BitPattern> {
        var index = base.endIndex as T.Index
        return self.suffix3(base, pulling: &index)
    }
    
    /// Returns the last two elements by pulling the given `index`.
    @inlinable public static func suffix3<T: BidirectionalCollection>(
        _ base: T,
        pulling index: inout T.Index
    )   -> Triplet<Self> where T.Element: SystemsInteger<BitPattern> {
        let high = Self/*-*/.suffix1(base, pulling: &index)
        let mid  = Magnitude.suffix1(base, pulling: &index)
        let low  = Magnitude.suffix1(base, pulling: &index)
        return Triplet(high: high, mid: mid, low: low)
    }
}
