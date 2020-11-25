# GenericStubProvider

This class is used to create stubs for any class instance.
To set up StubProvider you should create specific StubConditions and add them using `when` method.

**All methods that should be stubbed are checked in order Stubs were added to the GenericStubProvider, not StubConditions.**


Use method `enableLogs()` to enable logs of GenericStubProvider at any step;

Use method `when(StubCondition stubCondition)` to set method conditions, when it should be stubbed;

Use method `getNumberOfCalls(StubCondition stubCondition)` to get the number of times specific method was called;

Use method `thenReturn(Object returnValue)` to set object that should be returned on stubbed method.


Example of using GenericStubProvider:


```
    GenericStubProvider stubProvider = new GenericStubProvider()
        .when(new GenericStubProvider.StubCondition()
            .setInputValues(new List<Object>{'Some Value'})
            .setInputTypes(new List<Type>{String.class})
        )
        .thenReturn('Expected Return Value')
        .when(new GenericStubProvider.StubCondition()
            .setReturnType(void.class)
            .setInputTypes(new List<Type>{String.class})
        )
        .thenReturn(null);

    ClassToBeStubbed someClass = (ClassToBeStubbed) stubProvider.mock(ClassToBeStubbed.class);
```

More examples you can find in test class GenericStubProviderTest.
