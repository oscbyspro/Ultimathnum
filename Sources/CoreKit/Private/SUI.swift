//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer
//*============================================================================*

extension UMN {
    
    /// A namespace for strict unsigned integer algorithms.
    ///
    /// The `base` must be `nonempty` at the start and end of each access.
    ///
    /// ```swift
    /// static func algorithm(_ base: inout Base, input: Input) -> Output
    /// ```
    ///
    /// ### Development
    ///
    /// Remaking this as a view when Swift gets view types might be neat.
    ///
    @frozen public enum StrictUnsignedInteger<Base> where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger {
        
        /// The binary integer namespace of this type.
        public typealias Binary = UMN.StrictBinaryInteger<Base>
        
        /// The signed integer namespace of this type.
        public typealias Signed = UMN.StrictSignedInteger<Base>
        
        //*====================================================================*
        // MARK: * Sub Sequence
        //*====================================================================*
        
        /// The sub sequence namespace of this type.
        ///
        /// The `base` may be `empty` at the start and end of each access.
        ///
        @frozen public enum SubSequence {
            
            /// The binary integer namespace of this type.
            public typealias Binary = UMN.StrictBinaryInteger<Base>.SubSequence
            
            /// The signed integer namespace of this type.
            public typealias Signed = UMN.StrictSignedInteger<Base>.SubSequence
        }
    }
}