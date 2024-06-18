//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Integer Invariants x Addition
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func comparisonOfGenericLowEntropy() {
        func versus<U>(_ other: U.Type) where U: BinaryInteger {
            switch (T.isSigned, U.isSigned) {
            case (true, true):
                test.comparison( 2 as T,  3 as U, -1 as Signum)
                test.comparison( 2 as T, ~3 as U,  1 as Signum)
                test.comparison(~2 as T,  3 as U, -1 as Signum)
                test.comparison(~2 as T, ~3 as U,  1 as Signum)
                
                test.comparison( 0 as T,  0 as U,  0 as Signum)
                test.comparison( 0 as T, -1 as U,  1 as Signum)
                test.comparison(-1 as T,  0 as U, -1 as Signum)
                test.comparison(-1 as T, -1 as U,  0 as Signum)
                
                test.comparison( 1 as T,  1 as U,  0 as Signum)
                test.comparison( 1 as T, -1 as U,  1 as Signum)
                test.comparison(-1 as T,  1 as U, -1 as Signum)
                test.comparison(-1 as T, -1 as U,  0 as Signum)

            case (true, false):
                test.comparison( 2 as T,  3 as U, -1 as Signum)
                test.comparison( 2 as T, ~3 as U, -1 as Signum)
                test.comparison(~2 as T,  3 as U, -1 as Signum)
                test.comparison(~2 as T, ~3 as U, -1 as Signum)
            
            case (false, true):
                test.comparison( 2 as T,  3 as U, -1 as Signum)
                test.comparison( 2 as T, ~3 as U,  1 as Signum)
                test.comparison(~2 as T,  3 as U,  1 as Signum)
                test.comparison(~2 as T, ~3 as U,  1 as Signum)
                
            case (false, false):
                test.comparison( 2 as T,  3 as U, -1 as Signum)
                test.comparison( 2 as T, ~3 as U, -1 as Signum)
                test.comparison(~2 as T,  3 as U,  1 as Signum)
                test.comparison(~2 as T, ~3 as U,  T.size < U.size ? -1 : 1)
            }
        }
        
        always: do {
            versus(T.Signitude.self)
            versus(T.Magnitude.self)
        }
        
        for type in coreSystemsIntegers {
            versus(type)
        }
    }
    
    public func comparisonOfGenericMinMaxEsque() {
        func versus<U>(_ other: U.Type) where U: BinaryInteger {
            typealias A = IntegerInvariants<T>
            typealias B = IntegerInvariants<U>
            
            always: do {
                test.comparison(A.minEsque, B.maxEsque, -1 as Signum)
                test.comparison(A.maxEsque, B.minEsque,  1 as Signum)
            }
            
            switch (T.isSigned, U.isSigned) {
            case (true,  true):
                test.comparison(A.minEsque, B.minEsque, -T.size.compared(to: U.size))
                test.comparison(A.maxEsque, B.maxEsque,  T.size.compared(to: U.size))
                
            case (true,  false):
                test.comparison(A.minEsque, B.minEsque, -1 as Signum)
                test.comparison(A.maxEsque, B.maxEsque, -Signum.one(Sign(T.size > U.size)))
            
            case (false, true):
                test.comparison(A.minEsque, B.minEsque,  1 as Signum)
                test.comparison(A.maxEsque, B.maxEsque,  Signum.one(Sign(T.size < U.size)))
                
            case (false, false):
                test.comparison(A.minEsque, B.minEsque,  0 as Signum)
                test.comparison(A.maxEsque, B.maxEsque,  T.size.compared(to: U.size))
            }
        }
        
        always: do {
            versus(T.Signitude.self)
            versus(T.Magnitude.self)
        }
        
        for type in coreSystemsIntegers {
            versus(type)
        }
    }
    
    public func comparisonOfGenericRepeatingBit() {
        func versus<U>(_ other: U.Type) where U: BinaryInteger {
            always: do {
                test.comparison(T(repeating: 0), U(repeating: 0),  0 as Signum)
                test.comparison(T(repeating: 0), U(repeating: 1), -Signum.one(Sign(U.isSigned)))
                test.comparison(T(repeating: 1), U(repeating: 0),  Signum.one(Sign(T.isSigned)))
            }
            
            switch (T.isSigned, U.isSigned) {
            case (true,  true):
                test.comparison(T(repeating: 1), U(repeating: 1),  0 as Signum)
                
            case (true,  false):
                test.comparison(T(repeating: 1), U(repeating: 1), -1 as Signum)
            
            case (false, true):
                test.comparison(T(repeating: 1), U(repeating: 1),  1 as Signum)
                
            case (false, false):
                test.comparison(T(repeating: 1), U(repeating: 1),  T.size.compared(to: U.size))
            }
        }
        
        always: do {
            versus(T.Signitude.self)
            versus(T.Magnitude.self)
        }
        
        for type in coreSystemsIntegers {
            versus(type)
        }
    }
}
