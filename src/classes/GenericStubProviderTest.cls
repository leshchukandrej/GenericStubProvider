@IsTest
public with sharing class GenericStubProviderTest {

    @IsTest static void testComplexStub() {
        String expectedReturnValueByInputValuesAndInputTypes = 'expectedReturnValueByInputValuesAndInputTypes';
        String expectedReturnValueByReturnTypeAndInputTypes = 'expectedReturnValueByReturnTypeAndInputTypes';
        String expectedReturnValueByReturnTypeAndInputValues = 'expectedReturnValueByReturnTypeAndInputValues';
        String expectedReturnValueByMethodNameAndInputTypes = 'expectedReturnValueByMethodNameAndInputTypes';
        String expectedReturnValueByMethodNameAndInputValues = 'expectedReturnValueByMethodNameAndInputValues';

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) new GenericStubProvider()
            .when(new GenericStubProvider.StubCondition()
                .setInputValues(new List<Object>{new List<String>(), new List<String>()})
                .setInputTypes(new List<Type>{List<String>.class, List<String>.class})
            )
            .thenReturn(expectedReturnValueByInputValuesAndInputTypes)
            .when(new GenericStubProvider.StubCondition()
                .setReturnType(String.class)
                .setInputTypes(new List<Type>{GenericStubProviderClassToStub.ComplexClass.class})
            )
            .thenReturn(expectedReturnValueByReturnTypeAndInputTypes)
            .when(new GenericStubProvider.StubCondition()
                .setReturnType(String.class)
                .setInputValues(new List<Object>{new List<String>(), new List<Integer>()})
            )
            .thenReturn(expectedReturnValueByReturnTypeAndInputValues)
            .when(new GenericStubProvider.StubCondition()
                .setMethod('stringMethod')
                .setInputTypes(new List<Type>{Integer.class})
            )
            .thenReturn(expectedReturnValueByMethodNameAndInputTypes)
            .when(new GenericStubProvider.StubCondition()
                .setMethod('stringMethod')
                .setInputValues(new List<Object>{''})
            )
            .thenReturn(expectedReturnValueByMethodNameAndInputValues)
            .mock(GenericStubProviderClassToStub.class);

        System.assertEquals(expectedReturnValueByInputValuesAndInputTypes, stubbedClass.stringMethod(new List<String>(), new List<String>()));
        System.assertEquals(expectedReturnValueByReturnTypeAndInputTypes, stubbedClass.stringMethod(new GenericStubProviderClassToStub.ComplexClass('a', 1)));
        System.assertEquals(expectedReturnValueByReturnTypeAndInputValues, stubbedClass.stringMethod(new List<String>(), new List<Integer>()));
        System.assertEquals(expectedReturnValueByMethodNameAndInputTypes, stubbedClass.stringMethod(0));
        System.assertEquals(expectedReturnValueByMethodNameAndInputValues, stubbedClass.stringMethod(''));
    }

    @IsTest static void testStubByMethodName() {

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setMethod('voidMethod');

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod('');
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod(0);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByReturnType() {

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setReturnType(void.class);

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.complexClassMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByReturnType2() {

        GenericStubProviderClassToStub.ComplexClass expectedReturnValue =
            new GenericStubProviderClassToStub.ComplexClass('a', 1);

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setReturnType(GenericStubProviderClassToStub.ComplexClass.class);

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        GenericStubProviderClassToStub.ComplexClass actualReturnValue = stubbedClass.complexClassMethod();

        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputTypes() {

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputTypes(new List<Type>());

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod(0);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod('');
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod(0);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod('');
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputTypes2() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputTypes(new List<Type>{Integer.class});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod(0);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputTypes3() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputTypes(new List<Type>{GenericStubProviderClassToStub.ComplexClass.class});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod((GenericStubProviderClassToStub.ComplexClass) null);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputValues() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputValues(new List<Object>());

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod();
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod(0);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod('');
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputValues2() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputValues(new List<Object>{0});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod(0);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputValues3() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProviderClassToStub.ComplexClass expectedInputValue = new GenericStubProviderClassToStub.ComplexClass('a', 1);
        GenericStubProviderClassToStub.ComplexClass notExpectedInputValue = new GenericStubProviderClassToStub.ComplexClass('b', 2);

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputValues(new List<Object>{expectedInputValue});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod(expectedInputValue);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(notExpectedInputValue);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByMethodNameAndReturnType() {

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setMethod('voidMethod')
            .setReturnType(void.class);

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod2();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByMethodNameAndInputTypes() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setMethod('stringMethod')
            .setInputTypes(new List<Type>{String.class});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod('');
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByMethodNameAndInputValues() {

        String expectedReturnValue = 'Stubbed';

        String expectedInputValue = 'Expected';
        String notExpectedInputValue = '';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setMethod('stringMethod')
            .setInputValues(new List<Object>{expectedInputValue});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod(expectedInputValue);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(notExpectedInputValue);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByReturnTypeAndInputTypes() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setReturnType(String.class)
            .setInputTypes(new List<Type>{String.class});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod('');
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByReturnTypeAndInputValues() {

        String expectedReturnValue = 'Stubbed';

        String expectedInputValue = 'Expected';
        String notExpectedInputValue = '';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setReturnType(String.class)
            .setInputValues(new List<Object>{expectedInputValue});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod(expectedInputValue);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(notExpectedInputValue);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        stubbedClass.voidMethod();
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }

    @IsTest static void testStubByInputTypesAndInputValues() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider.StubCondition stubCondition = new GenericStubProvider.StubCondition()
            .setInputValues(new List<Object>{new List<String>(), new List<String>()})
            .setInputTypes(new List<Type>{List<String>.class, List<Integer>.class});

        GenericStubProvider stubProvider = new GenericStubProvider()
            .when(stubCondition)
            .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) stubProvider.mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        String actualReturnValue = stubbedClass.stringMethod(new List<String>(), new List<Integer>());
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));

        actualReturnValue = stubbedClass.stringMethod(new List<String>(), new List<String>());
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, stubProvider.getNumberOfCalls(stubCondition));
    }
}