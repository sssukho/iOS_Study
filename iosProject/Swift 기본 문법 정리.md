# Swift



## 네이밍 규칙

* Lower Camel Case : function, method, variable, constant
  ex) someVariableName
* Upper Camel Case : type(class, struct, enum, extension)
  ex) Person Point, Week
* 대소문자 구분함



## 콘솔로그

* print : 단순 문자열 출력
* dump : 인스턴스의 자세한 설명(description 프로퍼티)까지 출력(자세한 요소들까지)



## 문자열 보간법

* String Interpolation
* 프로그램 실행 중 문자열 내에 변수 또는 상수의 실질적인 값을 표현하기 위해 사용
* __\\()__ 

~~~swift
import Swift

let age : Int = 10; //상수 선언

"안녕하세요! 저는 \(age)살 입니다" // == "안녕하세요! 저는 10살입니다."
"안녕하세요! 저는 \(age + 5)살 입니다" // == "안녕하세요! 저는 15살입니다."

print("안녕하세요! 저는 \(age + 5)살 입니다")
print("\n###########################\n")

class Person {
    var name: String = "yagom"
    var age: Int = 10
}

let yagom: Person = Person()

print(yagom)
print("\n##############\n")
dump(yagom)
~~~



## 상수, 변수 선언

* 상수 선언

  ~~~swift
  // let 이름: 타입 = 값
  let constant: String = "차후에 변경이 불가능한 상수 let"
  ~~~

* 변수 선언

  ~~~swift
  // var 이름: 타입 = 값
  var variable: String = "차후에 변경이 가능한 변수 var"
  // 값의 타입이 명확하다면 타입은 생략이 가능하지만 먼저 타입을 지정해주는 것이 좋음
  ~~~

* 나중에 할당하려고 하는 상수나 변수는 타입을 꼭 명시해줘야 함



## 기본 데이터 타입

* swift의 기본 데이터 타입으로는 Bool, Int, UInt, Float, Double, Character, String 등이 있다.

* 기본적으로 데이터 타입이 엄격하기 때문에 형변환을 다른 언어들보다 자유자재로 사용할 수 없다.

  ~~~swift
  //Bool
  var someBool: Bool = true
  someBool = false //false를 의미하는 0이나 true를 의미하는 1은 Int 타입이기 때문에 할당 불가능
  
  //Int
  var someInt: Int = -100
  
  //UInt(Unsigned Integer, 부호없는 정수)
  var someUInt: UInt = 100
  
  //Float
  var someFloat: Float = 3.14 //정수를 넣어줘도 상관 없음
  
  //Character(한글자의 문자만 사용가능, 유니코드 사용)
  var someCharacter: Character= "가"
  
  //String
  var someString: String ="하하하"
  someString = someString + "웃으면 복이 와요" //연산 가능
  ~~~



## Any, AnyObject, nil (데이터 타입의 위치에 있는 키워드들)

* Any : Swift의 모든 타입을 지칭하는 키워드, Any 타입의 변수를 다른 타입의 변수에게 할당할 수 없음.

* AnyObject : 모든 클래스 타입을 지칭하는 프로토콜

* nil : 없음을 의미하는 키워드

  ~~~swift
  //MARK: - Any
  var someAny: Any = 100
  someAny = "어떤 타입도 수용 가능합니다"
  someAny = 123.12 
  
  //MARK: - AnyObject
  class SomeClass{}
  var someAnyObject: AnyObject = SomeClass() //SomeClass() 부분은 클래스의 인스턴스 생성 부분
  
  //MARK: - nil
  someAny = nil //어떠한 타입의 값이라도 들어올 수 있지만 null 값은 들어올 수 없음
  someAnyObject = nil //어떠한 타입의 객체라도 들어올 수 있지만 null 값은 들어올 수 없음
  ~~~



## 컬렉션 타입(Array, Dictionary, Set)

* 여러 값들을 묶어서 표현할 수 있는 객체

* Array : 순서가 있는 리스트 컬렉션

* Dictionary : Key, Value 쌍으로 이루어진 컬렉션

* Set : 순서가 없고, 멤버가 유일한 컬렉션

  ~~~swift
  //MARK: - Array
  
  // 빈 Int Array 생성
  var integers: Array<Int> = Array<Int>()
  integers.append(1) //요소를 맨 뒤에 추가할 때 쓰는 메소드
  integers.append(100)
  
  integers.contains(100) //요소가 포함되어 있는지 확인하는 메소드. boolean 값(true,false)으로 결과 배출
  integers.contains(99)
  
  integers.remove(at: 0) //인덱스에 해당된 값을 삭제하려고 할 때 쓰는 메소드
  integers.removeLast() //맨 마지막에 해당된 값 삭제
  integers.removeAll() //모든 값 삭제
  
  integers.count //property 임. 요소 갯수 출력
  
  // 빈 Double Array 생성
  var doubles: Array<Double> = [Double]()
  
  // 빈 String Array 생성
  var strings: [String] = [String]()
  
  //빈 Character Array 생성
  //[]는 새로운 빈 Array
  var characters: [Character] = []
  
  // let을 사용하여 Array를 선언하면 불변 Array
  let immutableArray = [1,2,3]
  
  
  //MARK: - Dictionary
  //Key가 String 타입이고 Value가 Any인 빈 Dictionary 생성
  var anyDictionary: Dictionary<String, Any> = [String: Any]()
  anyDictionary["someKey"] = "value"
  anyDictionary["anotherKey"] = 100
  
  //Key에 해당하는 값을 삭제할 때
  anyDictionary.removeValue(forKey: "anotherKey")
  anyDictionary["someKey"] = nil
  
  let emptyDictionary: [String: String] = [:]
  let initializedDictionary: [String: String] = ["name":"yagom", "gender":"male"]
  
  //MARK: - Set
  
  //비어있는 Int Set 생성. Set는 축약 문법이 없다.
  var integerSet: Set<Int> = Set<Int>()
  integerSet.insert(1)
  integerSet.insert(100)
  integerSet.insert(99) //set는 중복된 값을 알아서 다 제거해줌. 
  integerSet.insert(99)
  integerSet.insert(99)
  
  integerSet.contains(1) //값이 있는지 없는지. boolean 리턴
  integerSet.contains(2)
  
  integerSeet.count //Property. 요소 개수
  
  let setA: Set<Int> = [1, 2, 3, 4, 5]
  let setB: Set<Int> = [3, 4, 5, 6, 7]
  
  let union: Set<Int> = setA.union(setB) //합집합
  
  let sortedUnion: [Int] = union.sorted() //같은 타입의 배열로 표현
  
  let intersection: Set<Int> = setA.intersection(setB) //교집합
  
  let subtracting: Set<Int> = setA.subtracting(setB) //차집합
  ~~~



## 함수

~~~swift
//MARK: - 함수선언 기본형태
//func 함수이름(매개변수1이름: 배개변수1타입, 매개변수2이름: 매개변수2타입 ...) -> 반환타입 {
// 함수 구현부
// return 반환값
//}

//반환 타입 Int의 매소드
func sum(a: Int, b: Int) -> Int { 
    return a + b
}

//반환 타입 없는 메소드
func printMyName(name: String) -> Void {
    print(name)
}

//반환 타입이 없는 좀 더 간략한 형태의 메소드
func printYourName(name: String) {
    print(name)
}

//매개변수 없는 함수
func bye() { print("bye")}

//MARK: - 함수의 호출
sum(a: 3, b: 5)
printMyName(name: "yagom")
printYourName(name: "haha")
bye()

//MARK: - 매개변수 기본값
// 기본 값을 갖는 매개변수는 매개변수 목록 중에 뒤쪽에 위치하는 것이 좋다.
// func 함수이름(매개변수1이름: 매개변수1타입, 매개변수2이름: 매개변수2타입 = 매개변수 기본값 ...) -> 타입 {
// 		함수 구현부
//		return 반환값
//}

func greeting(friend: String, me: String = "yagom") {
    print("Hello \(friend)! I'm \(me)")
}

//매개변수 기본값을 가지는 매개변수는 생략할 수 있다.
greeting(friend: "hana") // Hello hana! I'm yagom
greeting(friend: "john", me: "eric") // Hello john! I'm eric

//MARK: - 전달인자 레이블
// 전달인자 레이블은 함수를 호출할 때
// 매개변수의 역할을 좀 더 명확하게 하거나
// 함수 사용자의 입장에서 표현하고자 할 때 사용한다.
//func 함수이름(전달인자 레이블 매개변수1이름: 매개변수1타입, 전달인자 레이블 매개변수2이름: 매개변수2타입)->타입{
//    함수구현부
//    return
//}

//함수 낸부에서 전달인자를 사용할 때에는 매개변수 이름을 사용한다.
func greeting(to friend: String, from me: String) {
    print("Hello \(friend)! I'm \(me)")
}

//함수를 호출할 때에는 전달인자 레이블을 사용해야 한다.
greeting(to: "hana", from: "yagom") // Hello hana! I'm yagom
~~~




























