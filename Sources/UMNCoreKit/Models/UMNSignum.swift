//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Signum
//*============================================================================*

@frozen public enum UMNSignum: Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case less
    case same
    case more
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral: IX.IntegerLiteralType) {
        self = switch integerLiteral {
        case -1: .less
        case  0: .same
        case  1: .more
        default: fatalError("invalid signum integer literal value") }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() -> Self {
        switch self {
        case .less: .more
        case .same: .same
        case .more: .less }
    }
}
