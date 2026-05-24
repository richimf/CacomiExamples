//
//  ViewController.m
//  CalculatorOld
//
//  Created by Ricardo Montesinos on 24/05/26.
//
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *firstNumberTextField;
@property (nonatomic, strong) UITextField *secondNumberTextField;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"ViewController viewDidLoad started");

    self.view.backgroundColor = UIColor.systemBackgroundColor;

    [self setupUI];

    NSLog(@"Initial firstNumberTextField text: %@", self.firstNumberTextField.text);
    NSLog(@"Initial secondNumberTextField text: %@", self.secondNumberTextField.text);
    NSLog(@"Initial result text: %@", self.resultLabel.text);
    NSLog(@"ViewController viewDidLoad finished");
}

- (void)setupUI {
    NSLog(@"setupUI started");

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Basic Calculator";
    titleLabel.font = [UIFont boldSystemFontOfSize:32];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.firstNumberTextField = [[UITextField alloc] init];
    self.firstNumberTextField.placeholder = @"First number";
    self.firstNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.firstNumberTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.firstNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;

    self.secondNumberTextField = [[UITextField alloc] init];
    self.secondNumberTextField.placeholder = @"Second number";
    self.secondNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.secondNumberTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.secondNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [subtractButton setTitle:@"Subtract" forState:UIControlStateNormal];
    subtractButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    subtractButton.translatesAutoresizingMaskIntoConstraints = NO;
    [subtractButton addTarget:self action:@selector(subtractButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    UILabel *resultTitleLabel = [[UILabel alloc] init];
    resultTitleLabel.text = @"Result";
    resultTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    resultTitleLabel.textColor = UIColor.secondaryLabelColor;
    resultTitleLabel.textAlignment = NSTextAlignmentCenter;
    resultTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.text = @"0";
    self.resultLabel.font = [UIFont boldSystemFontOfSize:36];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        titleLabel,
        self.firstNumberTextField,
        self.secondNumberTextField,
        addButton,
        subtractButton,
        resultTitleLabel,
        self.resultLabel
    ]];

    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 16;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:24],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-24],
        [stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:32]
    ]];

    NSLog(@"setupUI finished");
}

- (void)addButtonTapped {
    NSLog(@"Add button tapped");
    [self addNumbers];
}

- (void)subtractButtonTapped {
    NSLog(@"Subtract button tapped");
    [self subtractNumbers];
}

- (void)addNumbers {
    NSLog(@"addNumbers started");
    NSLog(@"Raw first number input: %@", self.firstNumberTextField.text);
    NSLog(@"Raw second number input: %@", self.secondNumberTextField.text);

    NSNumber *firstValue = [self numberFromText:self.firstNumberTextField.text fieldName:@"firstNumber"];

    if (firstValue == nil) {
        NSLog(@"Failed to convert firstNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"firstNumber converted successfully: %@", firstValue);

    NSNumber *secondValue = [self numberFromText:self.secondNumberTextField.text fieldName:@"secondNumber"];

    if (secondValue == nil) {
        NSLog(@"Failed to convert secondNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"secondNumber converted successfully: %@", secondValue);

    double total = firstValue.doubleValue + secondValue.doubleValue;
    NSLog(@"Addition result before formatting: %f", total);

    self.resultLabel.text = [self formatResult:total];
    NSLog(@"Formatted addition result: %@", self.resultLabel.text);
    NSLog(@"addNumbers finished");
}

- (void)subtractNumbers {
    NSLog(@"subtractNumbers started");
    NSLog(@"Raw first number input: %@", self.firstNumberTextField.text);
    NSLog(@"Raw second number input: %@", self.secondNumberTextField.text);

    NSNumber *firstValue = [self numberFromText:self.firstNumberTextField.text fieldName:@"firstNumber"];

    if (firstValue == nil) {
        NSLog(@"Failed to convert firstNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"firstNumber converted successfully: %@", firstValue);

    NSNumber *secondValue = [self numberFromText:self.secondNumberTextField.text fieldName:@"secondNumber"];

    if (secondValue == nil) {
        NSLog(@"Failed to convert secondNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"secondNumber converted successfully: %@", secondValue);

    double total = firstValue.doubleValue - secondValue.doubleValue;
    NSLog(@"Subtraction result before formatting: %f", total);

    self.resultLabel.text = [self formatResult:total];
    NSLog(@"Formatted subtraction result: %@", self.resultLabel.text);
    NSLog(@"subtractNumbers finished");
}

// Declared but not used
- (void)multiplyNumbers {
    NSLog(@"multiplyNumbers started");
    NSLog(@"Raw first number input: %@", self.firstNumberTextField.text);
    NSLog(@"Raw second number input: %@", self.secondNumberTextField.text);

    NSNumber *firstValue = [self numberFromText:self.firstNumberTextField.text fieldName:@"firstNumber"];

    if (firstValue == nil) {
        NSLog(@"Failed to convert firstNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"firstNumber converted successfully: %@", firstValue);

    NSNumber *secondValue = [self numberFromText:self.secondNumberTextField.text fieldName:@"secondNumber"];

    if (secondValue == nil) {
        NSLog(@"Failed to convert secondNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"secondNumber converted successfully: %@", secondValue);

    double total = firstValue.doubleValue * secondValue.doubleValue;
    NSLog(@"Multiplication result before formatting: %f", total);

    self.resultLabel.text = [self formatResult:total];
    NSLog(@"Formatted multiplication result: %@", self.resultLabel.text);
    NSLog(@"multiplyNumbers finished");
}

// Declared but not used
- (void)divideNumbers {
    NSLog(@"divideNumbers started");
    NSLog(@"Raw first number input: %@", self.firstNumberTextField.text);
    NSLog(@"Raw second number input: %@", self.secondNumberTextField.text);

    NSNumber *firstValue = [self numberFromText:self.firstNumberTextField.text fieldName:@"firstNumber"];

    if (firstValue == nil) {
        NSLog(@"Failed to convert firstNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"firstNumber converted successfully: %@", firstValue);

    NSNumber *secondValue = [self numberFromText:self.secondNumberTextField.text fieldName:@"secondNumber"];

    if (secondValue == nil) {
        NSLog(@"Failed to convert secondNumber to NSNumber");
        self.resultLabel.text = @"Invalid input";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    NSLog(@"secondNumber converted successfully: %@", secondValue);

    if (secondValue.doubleValue == 0) {
        NSLog(@"Division stopped because secondNumber is zero");
        self.resultLabel.text = @"Cannot divide by zero";
        NSLog(@"Result updated to: %@", self.resultLabel.text);
        return;
    }

    double total = firstValue.doubleValue / secondValue.doubleValue;
    NSLog(@"Division result before formatting: %f", total);

    self.resultLabel.text = [self formatResult:total];
    NSLog(@"Formatted division result: %@", self.resultLabel.text);
    NSLog(@"divideNumbers finished");
}

- (NSNumber *)numberFromText:(NSString *)text fieldName:(NSString *)fieldName {
    NSLog(@"numberFromText started for field: %@", fieldName);
    NSLog(@"Text received: %@", text);

    if (text == nil || text.length == 0) {
        NSLog(@"Text is empty for field: %@", fieldName);
        return nil;
    }

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;

    NSNumber *number = [formatter numberFromString:text];

    if (number == nil) {
        NSLog(@"Formatter failed to parse text: %@", text);
        return nil;
    }

    NSLog(@"Parsed number successfully: %@", number);
    NSLog(@"numberFromText finished for field: %@", fieldName);

    return number;
}

- (NSString *)formatResult:(double)value {
    NSLog(@"formatResult started");
    NSLog(@"Value received: %f", value);

    if (fmod(value, 1.0) == 0) {
        NSLog(@"Value has no decimal part");

        NSString *formattedValue = [NSString stringWithFormat:@"%.0f", value];

        NSLog(@"Formatted value: %@", formattedValue);
        NSLog(@"formatResult finished");

        return formattedValue;
    }

    NSLog(@"Value has decimal part");

    NSString *formattedValue = [NSString stringWithFormat:@"%g", value];

    NSLog(@"Formatted value: %@", formattedValue);
    NSLog(@"formatResult finished");

    return formattedValue;
}

@end
