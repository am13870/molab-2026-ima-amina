import UIKit

print("Hello, world!")

// constant or variable must have the same type as the value you want to assign to it
var myVariable = 42
myVariable = 50
let myConstant = 42

// if the initial value doesn’t provide enough information (or if there isn’t an initial value), specify the type by writing it after the variable, separated by a colon
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70

// experiment: Create a constant with an explicit type of Float and a value of 4
let explicitFloat: Float = 4.2
print (explicitFloat)

// Values are never implicitly converted to another type.
// If you need to convert a value to a different type, explicitly make an instance of the desired type.
let label = "The width is "
let width = 94
let widthLabel = label + String(width)
// if the String() is removed from this line, an error pops up: "binary operator '+' cannpt be applied to operands of type 'String' and 'Int'
print(widthLabel)

// There’s an even simpler way to include values in strings:
// Write the value in parentheses, and write a backslash (\) before the parentheses.
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let orangeSummary = "I have \(oranges) oranges."

print (appleSummary + " and " + orangeSummary)

let fruitSummary = "I have \(apples + oranges) pieces of fruit."

print (fruitSummary)

// experiment: Use \() to include a floating-point calculation in a string and to include someone’s name in a greeting.
let newFloat: Float = 6.3
let fpCalc = "4.2 plus 6.3 is \(explicitFloat + newFloat)."
print (fpCalc)

let nameX = "John"
print ("Hi \(nameX)!")

//Use three double quotation marks (""") for strings that take up multiple lines
let quotation = """
        Even though there's whitespace to the left,
        the actual lines aren't indented.
            Except for this line.
        Double quotes (") can appear without being escaped.

        I still have \(apples + oranges) pieces of fruit.
        """
print (quotation)

// Create arrays and dictionaries using brackets ([]), and access their elements by writing the index or key in brackets. A comma is allowed after the last element.
var fruits = ["strawberries", "limes", "tangerines"]
fruits[1] = "grapes"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
 ]
occupations["Jayne"] = "Public Relations"
