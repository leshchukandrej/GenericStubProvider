@IsTest
public with sharing class GenericStubProviderClassToStub {

    public void voidMethod() {

    }

    public void voidMethod2() {

    }

    public void voidMethod(String someString) {

    }

    public void voidMethod(Integer someInteger) {

    }

    public String stringMethod() {
        return null;
    }

    public String stringMethod(String someString) {
        return null;
    }

    public String stringMethod(Integer someInteger) {
        return null;
    }

    public String stringMethod(ComplexClass complexClass) {
        return null;
    }

    public String stringMethod(List<String> strings, List<Integer> integers) {
        return null;
    }

    public String stringMethod(List<String> strings, List<String> strings2) {
        return null;
    }

    public ComplexClass complexClassMethod() {
        return null;
    }

    public class ComplexClass {

        private String someString;
        private Integer someInteger;

        public ComplexClass(String someString, Integer someInteger) {
            this.someString = someString;
            this.someInteger = someInteger;
        }
    }
}