@IsTest
public with sharing class GenericStubProviderTest {

    @IsTest static void testComplexStub() {
        String expectedReturnValueByInputValuesAndInputTypes = 'expectedReturnValueByInputValuesAndInputTypes';
        String expectedReturnValueByReturnTypeAndInputTypes = 'expectedReturnValueByReturnTypeAndInputTypes';
        String expectedReturnValueByReturnTypeAndInputValues = 'expectedReturnValueByReturnTypeAndInputValues';
        String expectedReturnValueByMethodNameAndInputTypes = 'expectedReturnValueByMethodNameAndInputTypes';
        String expectedReturnValueByMethodNameAndInputValues = 'expectedReturnValueByMethodNameAndInputValues';

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) new GenericStubProvider()
                .when()
                    .setInputValues(new List<Object>{new List<String>(), new List<String>()})
                    .setInputTypes(new List<Type>{List<String>.class, List<String>.class})
                    .thenReturn(expectedReturnValueByInputValuesAndInputTypes)
                .when()
                    .setReturnType(String.class)
                    .setInputTypes(new List<Type>{GenericStubProviderClassToStub.ComplexClass.class})
                    .thenReturn(expectedReturnValueByReturnTypeAndInputTypes)
                .when()
                    .setReturnType(String.class)
                    .setInputValues(new List<Object>{new List<String>(), new List<Integer>()})
                    .thenReturn(expectedReturnValueByReturnTypeAndInputValues)
                .when()
                    .setMethod('stringMethod')
                    .setInputTypes(new List<Type>{Integer.class})
                    .thenReturn(expectedReturnValueByMethodNameAndInputTypes)
                .when()
                    .setMethod('stringMethod')
                    .setInputValues(new List<Object>{''})
                    .thenReturn(expectedReturnValueByMethodNameAndInputValues)
                .mock(GenericStubProviderClassToStub.class);

        System.assertEquals(expectedReturnValueByInputValuesAndInputTypes, stubbedClass.stringMethod(new List<String>(), new List<String>()));
        System.assertEquals(expectedReturnValueByReturnTypeAndInputTypes, stubbedClass.stringMethod(new GenericStubProviderClassToStub.ComplexClass('a', 1)));
        System.assertEquals(expectedReturnValueByReturnTypeAndInputValues, stubbedClass.stringMethod(new List<String>(), new List<Integer>()));
        System.assertEquals(expectedReturnValueByMethodNameAndInputTypes, stubbedClass.stringMethod(0));
        System.assertEquals(expectedReturnValueByMethodNameAndInputValues, stubbedClass.stringMethod(''));
    }

    @IsTest static void testStubByMethodName() {

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setMethod('voidMethod')
                .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod('');
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod(0);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByReturnType() {

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();
        stubBuilder
                .setReturnType(void.class)
                .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.complexClassMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByReturnType2() {

        GenericStubProviderClassToStub.ComplexClass expectedReturnValue =
                new GenericStubProviderClassToStub.ComplexClass('a', 1);

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setReturnType(GenericStubProviderClassToStub.ComplexClass.class)
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        GenericStubProviderClassToStub.ComplexClass actualReturnValue = stubbedClass.complexClassMethod();

        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputTypes() {

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputTypes(new List<Type>())
                .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod(0);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod('');
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod(0);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod('');
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputTypes2() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputTypes(new List<Type>{Integer.class})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod(0);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputTypes3() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputTypes(new List<Type>{GenericStubProviderClassToStub.ComplexClass.class})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod((GenericStubProviderClassToStub.ComplexClass) null);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputValues() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputValues(new List<Object>())
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod();
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod(0);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod('');
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputValues2() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputValues(new List<Object>{0})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod(0);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputValues3() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProviderClassToStub.ComplexClass expectedInputValue = new GenericStubProviderClassToStub.ComplexClass('a', 1);
        GenericStubProviderClassToStub.ComplexClass notExpectedInputValue = new GenericStubProviderClassToStub.ComplexClass('b', 2);

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputValues(new List<Object>{expectedInputValue})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod(expectedInputValue);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(notExpectedInputValue);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod('');
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByMethodNameAndReturnType() {

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setMethod('voidMethod')
                .setReturnType(void.class)
                .thenReturn(null);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod2();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByMethodNameAndInputTypes() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setMethod('stringMethod')
                .setInputTypes(new List<Type>{String.class})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod('');
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByMethodNameAndInputValues() {

        String expectedReturnValue = 'Stubbed';

        String expectedInputValue = 'Expected';
        String notExpectedInputValue = '';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setMethod('stringMethod')
                .setInputValues(new List<Object>{expectedInputValue})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod(expectedInputValue);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(notExpectedInputValue);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByReturnTypeAndInputTypes() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setReturnType(String.class)
                .setInputTypes(new List<Type>{String.class})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod('');
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(0);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod();
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByReturnTypeAndInputValues() {

        String expectedReturnValue = 'Stubbed';

        String expectedInputValue = 'Expected';
        String notExpectedInputValue = '';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setReturnType(String.class)
                .setInputValues(new List<Object>{expectedInputValue})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod(expectedInputValue);
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(notExpectedInputValue);
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.stringMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        stubbedClass.voidMethod();
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

    @IsTest static void testStubByInputTypesAndInputValues() {

        String expectedReturnValue = 'Stubbed';

        GenericStubProvider genericStubProvider = new GenericStubProvider();

        genericStubProvider.enableLogs();

        GenericStubProvider.StubBuilder stubBuilder = genericStubProvider.when();

        stubBuilder
                .setInputValues(new List<Object>{new List<String>(), new List<String>()})
                .setInputTypes(new List<Type>{List<String>.class, List<Integer>.class})
                .thenReturn(expectedReturnValue);

        GenericStubProviderClassToStub stubbedClass = (GenericStubProviderClassToStub) genericStubProvider
                .mock(GenericStubProviderClassToStub.class);

        Integer expectedNumberOfCalls = 0;

        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        String actualReturnValue = stubbedClass.stringMethod(new List<String>(), new List<Integer>());
        System.assertEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(++expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));

        actualReturnValue = stubbedClass.stringMethod(new List<String>(), new List<String>());
        System.assertNotEquals(expectedReturnValue, actualReturnValue);
        System.assertEquals(expectedNumberOfCalls, genericStubProvider.getNumberOfCalls(stubBuilder));
    }

}