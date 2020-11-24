public with sharing class GenericStubProvider implements StubProvider{

    private static final String NOT_SET = ' not set';

    private static final String IS_NOT_SET = ' is' + NOT_SET;
    private static final String ARE_NOT_SET = ' are' + NOT_SET;

    private static final String METHOD_NAME_EMPTY_MESSAGE = 'Method name' + IS_NOT_SET;
    private static final String RETURN_TYPE_EMPTY_MESSAGE = 'Return type' + IS_NOT_SET;
    private static final String INPUT_TYPES_EMPTY_MESSAGE = 'Input types' + ARE_NOT_SET;
    private static final String INPUT_VALUES_EMPTY_MESSAGE = 'Input values' + ARE_NOT_SET;

    private static final String STUB_BUILDER_WRONG_SETTINGS_MESSAGE = 'Wrong Stub Builder Settings';
    private static final String STUB_BUILDER_NOT_SELECTIVE_MESSAGE = 'Stub Builder Settings Not Selective';

    private static final String KEY_SEPARATOR = '|';
    private static final String VALUE_SEPARATOR = String.valueOf(Datetime.now().getTime());

    private static final Set<Type> ALL_STUBS = new Set<Type>{
            InputTypesAndInputValuesStub.class,
            ReturnTypeAndInputTypesStub.class,
            ReturnTypeAndInputValuesStub.class,
            MethodNameAndInputValuesStub.class,
            MethodNameAndInputTypesStub.class,
            MethodNameAndReturnTypeStub.class,
            InputValuesStub.class,
            InputTypesStub.class,
            ReturnTypeStub.class,
            MethodNameStub.class
    };

    private static final Set<Type> STUBS_BY_METHOD_NAME = new Set<Type>{
            MethodNameAndInputValuesStub.class,
            MethodNameAndInputTypesStub.class,
            MethodNameAndReturnTypeStub.class,
            MethodNameStub.class
    };

    private static final Set<Type> STUBS_BY_RETURN_TYPE = new Set<Type>{
            ReturnTypeAndInputTypesStub.class,
            ReturnTypeAndInputValuesStub.class,
            MethodNameAndReturnTypeStub.class,
            ReturnTypeStub.class
    };

    private static final Set<Type> STUBS_BY_INPUT_TYPES = new Set<Type>{
            InputTypesAndInputValuesStub.class,
            ReturnTypeAndInputTypesStub.class,
            MethodNameAndInputTypesStub.class,
            InputTypesStub.class
    };

    private static final Set<Type> STUBS_BY_INPUT_VALUES = new Set<Type>{
            InputTypesAndInputValuesStub.class,
            ReturnTypeAndInputValuesStub.class,
            MethodNameAndInputValuesStub.class,
            InputValuesStub.class
    };



    Boolean isLogsEnabled = false;
    Set<GenericStubProvider.AbstractStub> stubs = new Set<GenericStubProvider.AbstractStub>();
    Map<String, Object> returnValueByKey = new Map<String, Object>();
    Map<String, Integer> numberOfCallsByKey = new Map<String, Integer>();



    public Object mock(Type type) {
        return Test.createStub(type, this);
    }

    public GenericStubProvider enableLogs() {
        this.isLogsEnabled = true;
        return this;
    }

    public GenericStubProvider.StubBuilder when() {
        return new GenericStubProvider.StubBuilder(this);
    }

    //    Returns -1 if method was not stubbed
    public Integer getNumberOfCalls(GenericStubProvider.StubBuilder stubBuilder) {
        for (GenericStubProvider.AbstractStub stub: this.stubs) {
            String key = stub.generateKey(stubBuilder);
            if (this.returnValueByKey.containsKey(key)) return this.getNumberOfCalls(key);
        }
        return -1;
    }

    public Object handleMethodCall(
            Object stubbedObject,       //doesn't used
            String stubbedMethodName,
            System.Type returnType,
            List<System.Type> paramTypes,
            List<String> paramNames,
            List<Object> args
    ) {

        if (this.isLogsEnabled) {
            System.debug('\n\n');
            System.debug('stubbedMethodName: ' + stubbedMethodName);
            System.debug('returnType: ' + String.valueOf(returnType));
            System.debug('paramTypes: ' + String.valueOf(paramTypes));
            System.debug('args: ' + String.valueOf(args));
            System.debug('\n\n');
        }

        return this.getReturnValue(
                new GenericStubProvider.StubBuilder(this)
                        .setMethod(stubbedMethodName)
                        .setReturnType(returnType)
                        .setInputTypes(paramTypes)
                        .setInputValues(args)
        );
    }

    private Object getReturnValue(GenericStubProvider.StubBuilder stubBuilder) {
        for (GenericStubProvider.AbstractStub stub: this.stubs) {
            String key = stub.generateKey(stubBuilder);
            if (this.returnValueByKey.containsKey(key)) return this.returnValueAndLogCall(key);
        }
        return null;
    }

    private Object returnValueAndLogCall(String key) {
        if (this.isLogsEnabled) System.debug( 'Handled method key: ' + key );

        Integer numberOfCalls = this.getNumberOfCalls(key);

        this.numberOfCallsByKey.put(key, ++numberOfCalls);

        return this.returnValueByKey.get(key);
    }

    private Integer getNumberOfCalls(String key) {
        if (this.numberOfCallsByKey.containsKey(key)) {
            return this.numberOfCallsByKey.get(key);
        } else {
            return 0;
        }
    }

    private GenericStubProvider addStub(GenericStubProvider.AbstractStub stub, String key, Object returnValue) {
        if (this.isLogsEnabled) System.debug( 'Stubbed method key: ' + key );

        this.stubs.add(stub);
        this.returnValueByKey.put(key, returnValue);
        return this;
    }



    private static String getMethodName(GenericStubProvider.StubBuilder stubBuilder) {
        if (String.isEmpty(stubBuilder.methodName)) throw new GenericStubProviderException(METHOD_NAME_EMPTY_MESSAGE);
        return stubBuilder.methodName;
    }

    private static String getReturnTypeString(GenericStubProvider.StubBuilder stubBuilder) {
        if (stubBuilder.returnType == null) throw new GenericStubProviderException(RETURN_TYPE_EMPTY_MESSAGE);
        return String.valueOf(stubBuilder.returnType);
    }

    private static String getInputTypesString(GenericStubProvider.StubBuilder stubBuilder) {
        if (stubBuilder.inputTypes == null) throw new GenericStubProviderException(INPUT_TYPES_EMPTY_MESSAGE);
        return String.valueOf(stubBuilder.inputTypes);
    }

    private static String getInputValuesString(GenericStubProvider.StubBuilder stubBuilder) {
        if (stubBuilder.inputValues == null) throw new GenericStubProviderException(INPUT_VALUES_EMPTY_MESSAGE);

        //VALUE_SEPARATOR is used to avoid wrong scenarios with empty values or without input values
        String key = VALUE_SEPARATOR;

        for (Object inputValue: stubBuilder.inputValues) {
            key += String.valueOf(inputValue) + VALUE_SEPARATOR;
        }

        return key;
    }



    private class InputTypesAndInputValuesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getInputTypesString(stubBuilder) + KEY_SEPARATOR + getInputValuesString(stubBuilder);
        }
    }

    private class ReturnTypeAndInputTypesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getReturnTypeString(stubBuilder) + KEY_SEPARATOR + getInputTypesString(stubBuilder);
        }
    }

    private class ReturnTypeAndInputValuesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getReturnTypeString(stubBuilder) + KEY_SEPARATOR + getInputValuesString(stubBuilder);
        }
    }

    private class MethodNameAndInputValuesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getMethodName(stubBuilder) + KEY_SEPARATOR + getInputValuesString(stubBuilder);
        }
    }

    private class MethodNameAndInputTypesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getMethodName(stubBuilder) + KEY_SEPARATOR + getInputTypesString(stubBuilder);
        }
    }

    private class MethodNameAndReturnTypeStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getMethodName(stubBuilder) + KEY_SEPARATOR + getReturnTypeString(stubBuilder);
        }
    }

    private class InputValuesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getInputValuesString(stubBuilder);
        }
    }

    private class InputTypesStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getInputTypesString(stubBuilder);
        }
    }

    private class ReturnTypeStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getReturnTypeString(stubBuilder);
        }
    }

    private class MethodNameStub extends GenericStubProvider.AbstractStub {
        protected override String generateKey(GenericStubProvider.StubBuilder stubBuilder) {
            return getMethodName(stubBuilder);
        }
    }

    private abstract class AbstractStub {
        protected abstract String generateKey(GenericStubProvider.StubBuilder stubBuilder);

        public Boolean equals(Object obj) {
            return obj.hashCode() == this.hashCode();
        }

        public Integer hashCode() {
            return this.toString().hashCode();
        }
    }



    public class StubBuilder {

        private GenericStubProvider genericStubProvider;

        private String methodName;
        private System.Type returnType;
        private List<System.Type> inputTypes;
        private List<Object> inputValues;

        private StubBuilder(GenericStubProvider genericStubProvider) {
            this.genericStubProvider = genericStubProvider;
        }

        public StubBuilder setMethod(String methodName) {
            this.methodName = methodName;
            return this;
        }

        public StubBuilder setReturnType(System.Type returnType) {
            this.returnType = returnType;
            return this;
        }

        public StubBuilder setInputTypes(List<System.Type> inputTypes) {
            this.inputTypes = inputTypes;
            return this;
        }

        public StubBuilder setInputValues(List<Object> inputValues) {
            this.inputValues = inputValues;
            return this;
        }

        public GenericStubProvider thenReturn(Object returnValue) {
            GenericStubProvider.AbstractStub stub = this.buildStub();
            String key = stub.generateKey(this);
            return this.genericStubProvider.addStub(stub, key, returnValue);
        }

        private GenericStubProvider.AbstractStub buildStub() {
            Set<Type> stubProviders = new Set<Type>(ALL_STUBS);
            this.filterStubProviders(stubProviders, this.methodName, STUBS_BY_METHOD_NAME);
            this.filterStubProviders(stubProviders, this.returnType, STUBS_BY_RETURN_TYPE);
            this.filterStubProviders(stubProviders, this.inputTypes, STUBS_BY_INPUT_TYPES);
            this.filterStubProviders(stubProviders, this.inputValues, STUBS_BY_INPUT_VALUES);

            List<Type> stubProvidersList = new List<Type>(stubProviders);

            System.debug( 'StubProviders list: ' + stubProvidersList );

            if (stubProvidersList.size() == 0) {
                throw new GenericStubProviderException(STUB_BUILDER_WRONG_SETTINGS_MESSAGE);
            } else if (stubProvidersList.size() > 1) {
                throw new GenericStubProviderException(STUB_BUILDER_NOT_SELECTIVE_MESSAGE);
            }

            return (GenericStubProvider.AbstractStub) stubProvidersList.get(0).newInstance();
        }

        private void filterStubProviders(Set<Type> stubProvidersToProcess, Object param, Set<Type> stubProvidersToOperate) {
            if (param != null) {
                stubProvidersToProcess.retainAll(stubProvidersToOperate);
            } else {
                stubProvidersToProcess.removeAll(stubProvidersToOperate);
            }
        }
    }



    class GenericStubProviderException extends Exception {

    }
}