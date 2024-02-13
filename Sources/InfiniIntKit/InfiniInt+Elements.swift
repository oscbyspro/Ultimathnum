//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int x Elements x Signed
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream) {
        let `extension` = source.extension
        let `base` = InfiniInt.Storage.Base(source.succinct())
        //=--------------------------------------=
        source.consume()
        //=--------------------------------------=
        self.init(unchecked: InfiniInt.Storage(`base`, repeating: `extension`))
    }
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<Element.BitPattern> {
        self.init(normalizing: InfiniInt.Storage([Element.Magnitude(bitPattern: source)], repeating: Bit.Extension(repeating: 0)))
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        T(bitPattern: self.storage.base.first ?? self.storage.extension.element)
    }
    
    @inlinable public var elements: ContiguousArray<Element.Magnitude> {
        self.storage.base
    }
}

//*============================================================================*
// MARK: * Infini Int x Elements x Unsigned
//*============================================================================*

extension InfiniInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream) {
        let `extension` = source.extension
        let `base` = InfiniInt.Storage.Base(source.succinct())
        //=--------------------------------------=
        source.consume()
        //=--------------------------------------=
        self.init(unchecked: InfiniInt.Storage(`base`, repeating: `extension`))
    }

    @inlinable public init<T>(load source: T) where T: SystemsInteger<Element.BitPattern> {
        self.init(normalizing: InfiniInt.Storage([Element.Magnitude(bitPattern: source)], repeating: Bit.Extension(repeating: 0)))
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        T(bitPattern: self.storage.base.first ?? self.storage.extension.element)
    }
    
    @inlinable public var elements: ContiguousArray<Element.Magnitude> {
        self.storage.base
    }
}
