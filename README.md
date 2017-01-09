# letify package

A package to convert local variables to `let` statements, useful when refactoring RSpec specs:

```
my_variable = 'my value'
```

to

```
let(:my_variable) { 'my value' }
```
