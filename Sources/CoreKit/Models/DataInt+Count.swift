//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Count x Read
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits needed to *arbitrarily* represent `self`.
    ///
    /// ```
    /// ┌──────┬──────────── → ────────┐
    /// │ self │ bit pattern │ entropy │
    /// ├──────┼──────────── → ────────┤
    /// │   ~3 │ 00........1 │ 3       │
    /// │   ~2 │ 10........1 │ 3       │
    /// │   ~1 │ 0.........1 │ 2       │
    /// │   ~0 │ ..........1 │ 1       │
    /// │    0 │ ..........0 │ 1       │
    /// │    1 │ 1.........0 │ 2       │
    /// │    2 │ 01........0 │ 3       │
    /// │    3 │ 11........0 │ 3       │
    /// └──────┴──────────── → ────────┘
    /// ```
    ///
    /// - Note: A binary integer's `entropy` must fit in a signed machine word.
    ///
    @inlinable borrowing public func entropy() -> IX {
        let count = self.body.nondescending(self.appendix).incremented()
        return count.unchecked("BinaryInteger/entropy/0...IX.max")
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    /// The number of bits needed to *arbitrarily* represent `self`.
    ///
    /// ```
    /// ┌──────┬──────────── → ────────┐
    /// │ self │ bit pattern │ entropy │
    /// ├──────┼──────────── → ────────┤
    /// │   ~3 │ 00........1 │ 3       │
    /// │   ~2 │ 10........1 │ 3       │
    /// │   ~1 │ 0.........1 │ 2       │
    /// │   ~0 │ ..........1 │ 1       │
    /// │    0 │ ..........0 │ 1       │
    /// │    1 │ 1.........0 │ 2       │
    /// │    2 │ 01........0 │ 3       │
    /// │    3 │ 11........0 │ 3       │
    /// └──────┴──────────── → ────────┘
    /// ```
    ///
    /// - Note: A binary integer's `entropy` must fit in a signed machine word.
    ///
    @inlinable borrowing public func entropy() -> IX {
        Immutable(self).entropy()
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits needed to *arbitrarily* represent `self`.
    ///
    /// ```
    /// ┌──────┬──────────── → ────────┐
    /// │ self │ bit pattern │ entropy │
    /// ├──────┼──────────── → ────────┤
    /// │      │ 00........1 │ 3       │
    /// │      │ 10........1 │ 3       │
    /// │      │ 0.........1 │ 2       │
    /// │      │ ..........1 │ 1       │
    /// │    0 │ ..........0 │ 1       │
    /// │    1 │ 1.........0 │ 2       │
    /// │    2 │ 01........0 │ 3       │
    /// │    3 │ 11........0 │ 3       │
    /// └──────┴──────────── → ────────┘
    /// ```
    ///
    /// - Note: A binary integer's `entropy` must fit in a signed machine word.
    ///
    @inlinable borrowing public func entropy() -> IX {
        DataInt(self).entropy()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits in `self`
    @inlinable borrowing public func size() -> IX {
        let count = self.count.times(IX(size: Element.self))
        return count.unwrap("BinaryInteger/body/0..<IX.max")
    }
    
    /// The `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).count(0) // 5
    /// I8(11).count(1) // 3
    /// ```
    ///
    @inlinable borrowing public func count(_ bit: Bit) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].count(bit)
            count = count.plus(IX(load: subcount))
        }
        
        return count.unwrap("BinaryInteger/body/0..<IX.max")
    }
    
    /// The ascending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).ascending(0) // 0
    /// I8(11).ascending(1) // 2
    /// I8(22).ascending(0) // 1
    /// I8(22).ascending(1) // 0
    /// ```
    ///
    @inlinable borrowing public func ascending(_ bit: Bit) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].ascending(bit)
            count = count.plus(IX(load: subcount))
            guard subcount == Element.size else { break }
        }
        
        return count.unwrap("BinaryInteger/body/0..<IX.max")
    }
    
    /// The inverse ascending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).nonascending(0) // 8
    /// I8(11).nonascending(1) // 6
    /// I8(22).nonascending(0) // 7
    /// I8(22).nonascending(1) // 8
    /// ```
    ///
    @inlinable borrowing public func nonascending(_ bit: Bit) -> IX {
        self.size().minus(self.ascending(bit)).unchecked("inverse bit count")
    }
    
    /// The descending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).descending(0) // 4
    /// I8(11).descending(1) // 0
    /// I8(22).descending(0) // 3
    /// I8(22).descending(1) // 0
    /// ```
    ///
    @inlinable borrowing public func descending(_ bit: Bit) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices.reversed() {
            let subcount = self[unchecked: index].descending(bit)
            count = count.plus(IX(load: subcount))
            guard subcount == Element.size else { break }
        }
        
        return count.unwrap("BinaryInteger/body/0..<IX.max")
    }
    
    /// The inverse descending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).nondescending(0) // 4
    /// I8(11).nondescending(1) // 8
    /// I8(22).nondescending(0) // 5
    /// I8(22).nondescending(1) // 8
    /// ```
    ///
    @inlinable borrowing public func nondescending(_ bit: Bit) -> IX {
        self.size().minus(self.descending(bit)).unchecked("inverse bit count")
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits needed to *arbitrarily* represent `self`.
    ///
    /// ```
    /// ┌──────┬──────────── → ────────┐
    /// │ self │ bit pattern │ entropy │
    /// ├──────┼──────────── → ────────┤
    /// │      │ 00........1 │ 3       │
    /// │      │ 10........1 │ 3       │
    /// │      │ 0.........1 │ 2       │
    /// │      │ ..........1 │ 1       │
    /// │    0 │ ..........0 │ 1       │
    /// │    1 │ 1.........0 │ 2       │
    /// │    2 │ 01........0 │ 3       │
    /// │    3 │ 11........0 │ 3       │
    /// └──────┴──────────── → ────────┘
    /// ```
    ///
    /// - Note: A binary integer's `entropy` must fit in a signed machine word.
    ///
    @inlinable borrowing public func entropy() -> IX {
        Immutable(self).entropy()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The number of bits in `self`
    @inlinable borrowing public func size() -> IX {
        Immutable(self).size()
    }
    
    /// The `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).count(0) // 5
    /// I8(11).count(1) // 3
    /// ```
    ///
    @inlinable borrowing public func count(_ bit: Bit) -> IX {
        Immutable(self).count(bit)
    }
    
    /// The ascending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).ascending(0) // 0
    /// I8(11).ascending(1) // 2
    /// I8(22).ascending(0) // 1
    /// I8(22).ascending(1) // 0
    /// ```
    ///
    @inlinable borrowing public func ascending(_ bit: Bit) -> IX {
        Immutable(self).ascending(bit)
    }
    
    /// The inverse ascending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).nonascending(0) // 8
    /// I8(11).nonascending(1) // 6
    /// I8(22).nonascending(0) // 7
    /// I8(22).nonascending(1) // 8
    /// ```
    ///
    @inlinable borrowing public func nonascending(_ bit: Bit) -> IX {
        Immutable(self).nonascending(bit)
    }
    
    /// The descending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).descending(0) // 4
    /// I8(11).descending(1) // 0
    /// I8(22).descending(0) // 3
    /// I8(22).descending(1) // 0
    /// ```
    ///
    @inlinable borrowing public func descending(_ bit: Bit) -> IX {
        Immutable(self).descending(bit)
    }
    
    /// The inverse descending `bit` count in `self`.
    ///
    /// ```swift
    /// I8(11).nondescending(0) // 4
    /// I8(11).nondescending(1) // 8
    /// I8(22).nondescending(0) // 5
    /// I8(22).nondescending(1) // 8
    /// ```
    ///
    @inlinable borrowing public func nondescending(_ bit: Bit) -> IX {
        Immutable(self).nondescending(bit)
    }
}
