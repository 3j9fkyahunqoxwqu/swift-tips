//: [Previous](@previous)

/*
 Almost all Apple devices able to run Swift code are powered
 by a multi-core CPU, consequently making a good use of
 parallelism is a great way to improve code performance.
 `map()` is a perfect candidate for such an optimization,
 because it is almost trivial to implement a parallel version.
 
 🚨 Make sure to only use `parallelMap()` when the `transform`
 function actually performs some costly computations. Otherwise
 performances will be systematically slower than using `map()`
 because of the multithreading overhead.
 */

import Foundation

extension Array {
    func parallelMap<T>(_ transform: (Element) -> T) -> [T] {
        let res = UnsafeMutablePointer<T>.allocate(capacity: count)
        
        DispatchQueue.concurrentPerform(iterations: count) { i in
            res[i] = transform(self[i])
        }
        
        let finalResult = Array<T>(UnsafeBufferPointer(start: res, count: count))
        res.deallocate(capacity: count)
        
        return finalResult
    }
}

let array = (0..<1_000).map { $0 }

func work(_ n: Int) -> Int {
    return (0..<n).reduce(0, +)
}

print(array.parallelMap { work($0) })

//: [Next](@next)
