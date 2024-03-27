//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Numbers
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Base) where Base == BigIntLiteral, Element == IX {
        self.init(source, as: Element.self)
    }
    
    @inlinable public init(_ source: Base, as element: Element.Type = Element.self) where Base == BigIntLiteral {
        self.init(source, repeating: source.appendix)
    }
    
    @inlinable public init<T>(_ source: T) where T: BinaryInteger, Base == T.Content, Element == T.Element {
        self.init(source, as: Element.self)
    }
    
    @inlinable public init<T>(_ source: T, as element: Element.Type = Element.self) where T: BinaryInteger, Base == T.Content {
        self.init(source.content, repeating: source.appendix)
    }
}
