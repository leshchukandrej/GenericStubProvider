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

    GenericStubProvider.StubBuilder stubBuilder = new GenericStubProvider.StubBuilder();

    Set<AbstractStub> stubs = new Set<AbstractStub>();
    Map<String, Object> returnValueByKey = new Map<String, Object>();
    Map<String, Integer> numberOfCallsByKey = new Map<String, Integer>();



    public Object mock(Type type) {
        return Test.createStub(type, this);
    }

    public GenericStubProvider enableLogs() {
        this.isLogsEnabled = true;
        return this;
    }

    public StubReturnValue when(StubCondition stubCondition) {
        return new StubReturnValue(this, stubCondition);
    }

    //    Returns -1 if method was not stubbed
    public Integer getNumberOfCalls(StubCondition stubCondition) {
        for (AbstractStub stub: this.stubs) {
            String key = stub.generateKey(stubCondition);
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
            new StubCondition()
                .setMethod(stubbedMethodName)
                .setReturnType(returnType)
                .setInputTypes(paramTypes)
                .setInputValues(args)
        );
    }

    private Object getReturnValue(StubCondition stubCondition) {
        for (AbstractStub stub: this.stubs) {
            String key = stub.generateKey(stubCondition);
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

    private GenericStubProvider addStub(StubCondition stubCondition, Object returnValue) {
        AbstractStub stub = this.stubBuilder.buildStub(stubCondition);
        this.stubs.add(stub);

        String key = stub.generateKey(stubCondition);

        if (this.isLogsEnabled) System.debug( 'Stubbed method key: ' + key );

        this.returnValueByKey.put(key, returnValue);

        return this;
    }



    private static String getMethodName(StubCondition stubCondition) {
        if (String.isEmpty(stubCondition.methodName)) throw new GenericStubProviderException(METHOD_NAME_EMPTY_MESSAGE);
        return stubCondition.methodName;
    }

    private static String getReturnTypeString(StubCondition stubCondition) {
        if (stubCondition.returnType == null) throw new GenericStubProviderException(RETURN_TYPE_EMPTY_MESSAGE);
        return String.valueOf(stubCondition.returnType);
    }

    private static String getInputTypesString(StubCondition stubCondition) {
        if (stubCondition.inputTypes == null) throw new GenericStubProviderException(INPUT_TYPES_EMPTY_MESSAGE);
        return String.valueOf(stubCondition.inputTypes);
    }

    private static String getInputValuesString(StubCondition stubCondition) {
        if (stubCondition.inputValues == null) throw new GenericStubProviderException(INPUT_VALUES_EMPTY_MESSAGE);

        //VALUE_SEPARATOR is used to avoid wrong scenarios with empty values or without input values
        String key = VALUE_SEPARATOR;

        for (Object inputValue: stubCondition.inputValues) {
            key += String.valueOf(inputValue) + VALUE_SEPARATOR;
        }

        return key;
    }



    private class InputTypesAndInputValuesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getInputTypesString(stubCondition) + KEY_SEPARATOR + getInputValuesString(stubCondition);
        }
    }

    private class ReturnTypeAndInputTypesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getReturnTypeString(stubCondition) + KEY_SEPARATOR + getInputTypesString(stubCondition);
        }
    }

    private class ReturnTypeAndInputValuesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getReturnTypeString(stubCondition) + KEY_SEPARATOR + getInputValuesString(stubCondition);
        }
    }

    private class MethodNameAndInputValuesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getMethodName(stubCondition) + KEY_SEPARATOR + getInputValuesString(stubCondition);
        }
    }

    private class MethodNameAndInputTypesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getMethodName(stubCondition) + KEY_SEPARATOR + getInputTypesString(stubCondition);
        }
    }

    private class MethodNameAndReturnTypeStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getMethodName(stubCondition) + KEY_SEPARATOR + getReturnTypeString(stubCondition);
        }
    }

    private class InputValuesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getInputValuesString(stubCondition);
        }
    }

    private class InputTypesStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getInputTypesString(stubCondition);
        }
    }

    private class ReturnTypeStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getReturnTypeString(stubCondition);
        }
    }

    private class MethodNameStub extends AbstractStub {
        protected override String generateKey(StubCondition stubCondition) {
            return getMethodName(stubCondition);
        }
    }

    public abstract class AbstractStub {

        protected abstract String generateKey(StubCondition stubCondition);

        public Boolean equals(Object obj) {
            return obj.hashCode() == this.hashCode();
        }

        public Integer hashCode() {
            return this.toString().hashCode();
        }

    }



    private class StubBuilder {
        private AbstractStub buildStub(StubCondition stubCondition) {
            Set<Type> stubProviders = new Set<Type>(ALL_STUBS);
            this.filterStubProviders(stubProviders, stubCondition.methodName, STUBS_BY_METHOD_NAME);
            this.filterStubProviders(stubProviders, stubCondition.returnType, STUBS_BY_RETURN_TYPE);
            this.filterStubProviders(stubProviders, stubCondition.inputTypes, STUBS_BY_INPUT_TYPES);
            this.filterStubProviders(stubProviders, stubCondition.inputValues, STUBS_BY_INPUT_VALUES);

            List<Type> stubProvidersList = new List<Type>(stubProviders);

            System.debug( 'StubProviders list: ' + stubProvidersList );

            if (stubProvidersList.size() == 0) {
                throw new GenericStubProviderException(STUB_BUILDER_WRONG_SETTINGS_MESSAGE);
            } else if (stubProvidersList.size() > 1) {
                throw new GenericStubProviderException(STUB_BUILDER_NOT_SELECTIVE_MESSAGE);
            }

            return (AbstractStub) stubProvidersList.get(0).newInstance();
        }

        private void filterStubProviders(Set<Type> stubProvidersToProcess, Object param, Set<Type> stubProvidersToOperate) {
            if (param != null) {
                stubProvidersToProcess.retainAll(stubProvidersToOperate);
            } else {
                stubProvidersToProcess.removeAll(stubProvidersToOperate);
            }
        }
    }

    public class StubReturnValue {

        GenericStubProvider stubProvider;
        StubCondition stubCondition;

        private StubReturnValue(GenericStubProvider stubProvider, StubCondition stubCondition) {
            this.stubProvider = stubProvider;
            this.stubCondition = stubCondition;
        }

        public GenericStubProvider thenReturn(Object returnValue) {
            return this.stubProvider.addStub(this.stubCondition, returnValue);
        }
    }

    public class StubCondition {

        private String methodName;
        private System.Type returnType;
        private List<System.Type> inputTypes;
        private List<Object> inputValues;

        public StubCondition setMethod(String methodName) {
            this.methodName = methodName;
            return this;
        }

        public StubCondition setReturnType(System.Type returnType) {
            this.returnType = returnType;
            return this;
        }

        public StubCondition setInputTypes(List<System.Type> inputTypes) {
            this.inputTypes = inputTypes;
            return this;
        }

        public StubCondition setInputValues(List<Object> inputValues) {
            this.inputValues = inputValues;
            return this;
        }
    }



    class GenericStubProviderException extends Exception {

    }
}