package org.example;

public class OuterClass{
    private int outerVar = 10;
    protected int LocalInnerVar = 40;

    public void outerMethod(){
        int LocalOuterVar = 20;

        class InnerClass{
            private int innerVar = 30;

            public void innerMethod(){
                System.out.println(outerVar);
                System.out.println(LocalOuterVar);
                System.out.println(innerVar);
                //System.out.println(LocalInnerVar);
            }
        }

        InnerClass inner = new InnerClass();
        inner.innerMethod();
    }

    public static void main(String[] args ){
        OuterClass outer = new OuterClass();
        outer.outerMethod();
    }
}