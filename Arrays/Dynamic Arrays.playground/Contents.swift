//: Playground - Implement dynamic array using swift 3

import UIKit
import Foundation

let fixedCapacity = 32

func ^(radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

protocol Initable: Equatable{
    init()
}

extension String:Initable {}
extension Double:Initable {}
extension Int:Initable {}
extension Float:Initable {}

struct MyArray<T: Initable>{
    
    private var mArray: [T]
    private var mCapacity: Int
    private var mCount = 0
    
    // Create new array with fixted initial capacity.
    init() {
        self.mCapacity = fixedCapacity
        self.mArray = [T](repeating: T(), count: self.mCapacity)
        self.mCount = 0
    }
    
    // Create new array with specific initial capacity.
    init(capacity: Int) {
        self.mCapacity = capacity
        self.mArray = [T](repeating: T(), count: self.mCapacity)
        self.mCount = 0
    }
    
    // Returns the number of elements managed in the array.
    func size() -> Int{
        return self.mCount
    }
    
    // Returns the actual capacity the array can accommodate.
    func capacity() -> Int{
        return self.mCapacity
    }
    
    // Returns true if array is empty otherwise return false.
    func isEmpty() -> Bool{
        if mCount == 0{
            return true
        }
        return false
    }
    
    // Returns the value stored at the given index.
    subscript(_ index: Int) -> T{
        if index < 0 || index > (mCount - 1) {
            exit(EXIT_FAILURE)
        }
        return self.mArray[index]
    }
    
    // Appends the given item to the end of the array.
    mutating func push(_ item: T){
        if fullCapacity(){
            self.resize(self.mCapacity ^ 2)
        }
        mArray[mCount] = item
        mCount += 1
    }
    
    // Inserts the given value at the given index, shifting
    // current and trailing elements to the right.
    mutating func insert(index: Int,item: T){
        if index < 0 || index > (mCount - 1) {
            exit(EXIT_FAILURE)
        }
        
        shiftElementRight(fromIndex: index)
        mArray[index] = item
        mCount += 1
    }
    
    // Prepends the given value to the array, shifting trailing
    // elements to the right.
    mutating func prepend(item: T){
        insert(index: 0, item: item)
    }
    
    // Removes the last item from the array and returns its value.
    mutating func pop() -> T{
        if mCount < 0{
            exit(EXIT_FAILURE)
        }
        
        let removedValue = mArray[mCount-1]
        mArray[mCount-1] = T()
        mCount -= 1
        
        if mCount <= (mCapacity/4){
            resize(mCapacity/2)
        }
        return removedValue
    }
    
    // Deletes the item stored at the given index, shifting trailing
    // elements to the left.
    mutating func delete(at index: Int){
        if index < 0 || index > (mCount - 1){
            exit(EXIT_FAILURE)
        }
        shiftElementLeft(fromIndex: index)
        mArray[mCount - 1] = T()
        mCount -= 1
        
        if mCount <= (mCapacity/4){
            resize(mCapacity/2)
        }
    }
    
    // Removes the given value from the array, even if it appears more than once.
    mutating func remove(item: T){
        for index in (0 ..< mCount).reversed(){
            if equal(a: mArray[index], b: item){
                delete(at: index)
            }
        }
        
        if mCount <= (mCapacity/4){
            resize(mCapacity/2)
        }
    }
    
    // Returns the index of the first occurrence of the given value in the array.
    func find(item: T) -> Int{
        var firstIndex = -1
        for index in 0 ..< mCount{
            if equal(a: mArray[index], b: item){
                firstIndex = index
                break
            }
        }
        return firstIndex
    }
    
    //MARK: - Helper Methods
    private func equal<T:  Equatable>(a:T, b: T) -> Bool{
        return a == b ? true : false
    }
    
    // Returns true if count equal the capacity array.
    private func fullCapacity() -> Bool{
        if mCount < mCapacity{
            return false
        }
        return true
    }
    
    // resize the array capacity according to given
    private mutating func resize(_ newCapacity: Int){
        let oldArray = mArray
        mArray = [T](repeating: T(), count: newCapacity)
        self.mCapacity = newCapacity
        for index in 0..<mCount{
            mArray[index] = oldArray[index]
        }
    }
    
    //Shifting elements to the right from given index.
    private mutating func shiftElementRight(fromIndex index: Int){
        if fullCapacity(){
            self.resize(self.mCapacity ^ 2)
        }
        for localIndex in (index ..< mCount).reversed(){
            mArray[localIndex + 1] = mArray[localIndex]
        }
    }
    
    //Shifting elements to the left from given index.
    private mutating func shiftElementLeft(fromIndex index: Int){
        for localIndex in (index ..< (mCount-1)){
           mArray[localIndex] = mArray[localIndex + 1]
        }
    }
}


///////////////// Test Methods ///////////////////

func testSize(){
    let aptr = MyArray<Int>(capacity: 5)
    let initialSize = aptr.size()
    assert(initialSize == 0)
}

func testAppend(){
    var aptr = MyArray<Int>(capacity: 2)
    aptr.push(2)
    aptr.push(12)
    let newSize = aptr.size()
    assert(newSize == 2)
}

func testResize(){
    var aptr = MyArray<Int>(capacity: 2)
    let oldCapacity = aptr.capacity()
    assert(oldCapacity == 2)
    
    for i in 0..<18{
        aptr.push(i+1)
    }
    assert(aptr.capacity() == 256)
    
    for _ in 0..<15{
        aptr.pop()
    }
    assert(aptr.capacity() == 8)
}

func testEmpty(){
    var aptr = MyArray<Int>(capacity: 2)
    var empty: Bool = aptr.isEmpty()
    assert(empty == true)
    aptr.push(1)
    empty = aptr.isEmpty()
    assert(empty == false)
}

func testAt(){
    var aptr = MyArray<Int>(capacity: 12)
    for i in 0 ..< 12{
        aptr.push(i+3)
    }
    assert(aptr[6] == 9)
}

func testInsert(){
    var aptr = MyArray<Int>(capacity: 5)
    for i in 0 ..< 5{
        aptr.push(i+5)
    }
    
    aptr.insert(index: 2, item: 47)
    assert(aptr[2] == 47)
    assert(aptr[3] == 7)
}

func testPrepend(){
    var aptr = MyArray<Int>(capacity: 5)
    for i in 0 ..< 3{
        aptr.push(i+1)
    }
    aptr.prepend(item: 15)
    assert(aptr[0] == 15)
    assert(aptr[1] == 1)
}

func testPop(){
    var aptr = MyArray<Int>(capacity: 5)
    for i in 0 ..< 3{
        aptr.push(i+1)
    }
    assert(aptr.size() == 3)
    for _ in 0 ..< 2{
        aptr.pop()
    }
    assert(aptr.size() == 1)
}

func testRemove(){
    var aptr = MyArray<Int>(capacity: 5)
    aptr.push(12)
    aptr.push(3)
    aptr.push(41)
    aptr.push(12)
    aptr.push(12)
    aptr.push(12)
    aptr.remove(item: 12)
    assert(aptr.size() == 2)
}

func testFindExists(){
    var aptr = MyArray<Int>(capacity: 5)
    aptr.push(1)
    aptr.push(2)
    aptr.push(3)
    aptr.push(4)
    aptr.push(5)
    assert(aptr.find(item: 1) == 0)
    assert(aptr.find(item: 5) == 4)
    assert(aptr.find(item: 3) == 2)
}

func testFindNotExist(){
    var aptr = MyArray<Int>(capacity: 5)
    aptr.push(1)
    aptr.push(2)
    aptr.push(3)
    aptr.push(4)
    assert(aptr.find(item: 7) == -1)
}

/////////////////// Run Test Methods ////////////////

testSize()
testAppend()
testResize()
testEmpty()
testAt()
testInsert()
testPrepend()
testPop()
testRemove()
testFindExists()
testFindNotExist()




