//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer
//*============================================================================*

extension Namespace {
    
    /// A namespace for tuple binary integer algorithms.
    ///
    /// A tuple binary integer's signedness is determined by its `High` type.
    ///
    @frozen public enum TupleBinaryInteger<Base> where Base: SystemsInteger {
        
        /// An integer.
        public typealias X1 = Base
        
        /// An integer split into 2 parts.
        public typealias X2 = Doublet<Base>
        
        /// An integer split into 3 parts.
        public typealias X3 = Triplet<Base>
        
        //*====================================================================*
        // MARK: * Magnitude
        //*====================================================================*
        
        public typealias Magnitude = TupleBinaryInteger<Base.Magnitude>
    }
}
