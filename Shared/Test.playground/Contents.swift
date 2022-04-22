import UIKit

struct TestYM {
    var month: Int = 1
    var totalIncomes: Double? = nil
    var totalExpenses: Double? = nil
}

struct TestIncome {
    var month: Int = 1
    var value: Double
}

var testYMs: [TestYM] = [
    TestYM(month: 1),
    TestYM(month: 2),
]

var testYMs2: [TestYM] = [
    TestYM(month: 1),
    TestYM(month: 2),
    TestYM(month: 3),
]
var incomes: [TestIncome] = Array(repeating: TestIncome(value: 1), count: 10)

incomes = incomes + Array(repeating: TestIncome(month: 2, value: 2), count: 10)

//print(testYMs, incomes)

for index in testYMs.indices {
    testYMs[index].totalIncomes = incomes.map({
        if $0.month == testYMs[index].month {
            return $0.value
        }
        return 0
    }).reduce(0, +)
}

testYMs2 = testYMs2.map({ item in
    var item = item
    
    item.totalIncomes = incomes.map({
        if $0.month == item.month {
            return $0.value
        }
        return 0
    }).reduce(0, +)
    
    return item
})

//testYMs[0].totalIncomes = incomes.map({
//    if $0.month == 2 {
//    return $0.value
//    }
//    return 0
//}
//).reduce(0, +)

print(testYMs)
print(testYMs2)
