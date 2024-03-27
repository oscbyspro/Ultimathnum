//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Collection
//*============================================================================*

extension Namespace.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns the first element.
    @inlinable package static func prefix1<T: Collection>(
    _   base: T) -> X1 where T.Element == Base.Magnitude {
        var index = base.startIndex as T.Index
        return self.prefix1(base, pushing: &index)
    }
    
    /// Returns the first element by pushing the given `index`.
    @inlinable package static func prefix1<T: Collection>(
    _   base: T, pushing index: inout T.Index) -> X1 where T.Element == Base.Magnitude {
        defer{ base.formIndex(after: &index) }
        return Base(bitPattern: base[index])
    }
    
    /// Returns the first two elements.
    @inlinable package static func prefix2<T: Collection>(
    _   base: T) -> X2 where T.Element == Base.Magnitude {
        var index = base.startIndex as T.Index
        return self.prefix2(base, pushing: &index)
    }
    
    /// Returns the first two elements by pushing the given `index`.
    @inlinable package static func prefix2<T: Collection>(
    _   base: T, pushing index: inout T.Index) -> X2 where T.Element == Base.Magnitude {
        let low  = TBI.prefix1(base, pushing: &index) as X1.Magnitude
        let high = TBI.prefix1(base, pushing: &index) as X1
        return X2(high: consume high, low: consume low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns the last element.
    @inlinable package static func suffix1<T: BidirectionalCollection>(
    _   base: T) -> X1 where T.Element == Base.Magnitude {
        var index = base.endIndex as T.Index
        return self.suffix1(base, pulling: &index)
    }
    
    /// Returns the last element by pulling the given `index`.
    @inlinable package static func suffix1<T: BidirectionalCollection>(
    _   base: T, pulling index: inout T.Index) -> X1 where T.Element == Base.Magnitude {
        base.formIndex(before: &index)
        return Base(bitPattern: base[index])
    }
    
    /// Returns the last two elements.
    @inlinable package static func suffix2<T: BidirectionalCollection>(
    _   base: T) -> X2 where T.Element == Base.Magnitude {
        var index = base.endIndex as T.Index
        return self.suffix2(base, pulling: &index)
    }
    
    /// Returns the last two elements by pulling the given `index`.
    @inlinable package static func suffix2<T: BidirectionalCollection>(
    _   base: T, pulling index: inout T.Index) -> X2 where T.Element == Base.Magnitude {
        let high = TBI.suffix1(base, pulling: &index) as X1
        let low  = TBI.suffix1(base, pulling: &index) as X1.Magnitude
        return X2(high: consume high, low: consume low)
    }
}
