//
//  main.c
//  Tan_LocationMove
//
//  Created by PX_Mac on 2017/5/19.
//  Copyright © 2017年 M C. All rights reserved.
//

#include <stdio.h>

void testConstPointer(); //测试常量指针

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
    printf("。。。。位移。。。。\n");
    /*
     0000 0000 0000 0000 0000 0000 0000 1001
    0000 0000 0000 0000 0000 0000 0000 10010 : 9<<1 原码往左移动一位，右边用0补位，结果：16+2=18=9*2(1)
   0000 0000 0000 0000 0000 0000 0000 100100 : 9<<2 移动2位，右边用0补位，结果：32+4=36=9*2(2)
     
     00000 0000 0000 0000 0000 0000 0000 100 : 9>>1 : 右移一位，左边用0补位，结果：4 = 9/2(1)
     000000 0000 0000 0000 0000 0000 0000 10 : 9>>2 :右移两位，左边用0补位，结果：2 = 9/2(2)
     0000000 0000 0000 0000 0000 0000 0000 1 : 9>>3 : 右移三位，左边用0补位，结果：1=9/2(3)
     00000000 0000 0000 0000 0000 0000 0000  : 9>>4 : 结果0
     */
    printf("9<<1: %d, 9<<2: %d, 9>>1: %d, 9>>2: %d, 9>>3: %d, 9>>4: %d\n", 9<<1, 9<<2, 9>>1, 9>>2, 9>>3, 9>>4);
    
    
    /** 
     负数位移： -9  反码移动
     1000 0000 0000 0000 0000 0000 0000 1001
     1111 1111 1111 1111 1111 1111 1111 0110 反码
     1111 1111 1111 1111 1111 1111 1111 0111 补码
     
    1111 1111 1111 1111 1111 1111 1111 01111 左移1位, 左边用1补位
     111 1111 1111 1111 1111 1111 1111 01110
     100 0000 0000 0000 0000 0000 0000 10001 结果：-(16+2) = -18
     
    1111 1111 1111 1111 1111 1111 1111 011111 左移2位，左边用1补位
     11 1111 1111 1111 1111 1111 1111 011110
     10 0000 0000 0000 0000 0000 0000 100001 结果：-（32+1）=-33
     */
    printf("-9<<1: %d, -9<<2: %d, -9>>1: %d\n", -9<<1, -9<<2, -9>>1);
    
    printf("9>>32: %d, 9>>31: %d, 9>>30: %d, %d, %d, %d, %d, %d \n", 9>>32, 9>>31, 9>>30, 9>>0, 9>>1, 9>>2, 9>>3, 9>>4);
    printf("%d, %d, %d, %d, %d, %d, %d ,%d \n", (9>>32)&1, (9>>31)&1, (9>>30)&1, (9>>0)&1, (9>>1)&1, (9>>2)&1, (9>>3)&1, (9>>4)&1);
    
    /*
    题目1、输入一个整数num, 打印该整数num的二进制
     该题运用到位移、按位且&
     */
    int num =9;
    for (int i =31; i>=0; i--) {
        if ((i+1)%4==0){
            printf(" ");
        }
        
        printf("%d", (num>>i)&1);
    }
    printf("\n");
    //打印结果为： 0000 0000 0000 0000 0000 0000 0000 1001
    
    
    /**
     题目2：输入一个数字，判断该数字的奇偶性
     可以多种方式实现，这里我们使用按位&来实现，
     任何位&1都为该位，即0&1=0， 1&1=1
     分析：整数二进制最后一位为1的是奇数，为0的是偶数
     0001 1
     0010 2
     0011 3
     0100 4
     0101 5
     */
    printf("奇数：%d, %d, %d, %d, %d\n", 1&1, 3&1, 5&1, 7&1, 9&1);
    printf("偶数：%d, %d, %d, %d, %d\n", 0&1, 2&1, 4&1, 6&1, 8&1);
    /** 打印结果
     奇数：1, 1, 1, 1, 1
     偶数：0, 0, 0, 0, 0
     */
    
    
    /**
     题目3：两个整数a和b, 交换两个整数的值
     可以使用按位异或来处理：任何数num异或另外一个数num2两次都为该数num
     */
    int a = 10, b = 8;
    //第一种方式，增加一个中间变量来交换
    int c = a; a=b; b=c;
    printf("第一种方式：a=%d, b=%d \n", a, b);
    
    //第二种方式
    printf("第二种方式交换a: %d, b: %d的值:\n", a, b);
    a = a+b;
    b = a - b;
    a = a - b;
    printf("交换后：a=%d, b=%d \n", a, b);
    
    //第三种方式，使用^
    printf("第三种方式交换a: %d, b: %d的值 \n", a, b);
    a = a^b;
    b = a^b; //相当于b = a^b^b = a
    a = a^b; //相当于a = a^a^b = b
    printf("交换后： a = %d, b = %d\n", a, b);
    
    /** 打印结果：
     第一种方式：a=8, b=10
     第二种方式交换a: 8, b: 10的值:
     交换后：a=10, b=8
     第三种方式交换a: 10, b: 8的值
     交换后： a = 8, b = 10
     */
    
    
    
    /** 题目4：整数的简单加密，使用异或^ */
    int pwd = 888888, key = 518518;
    int encodePwd = pwd^key;
    int decodePwd = encodePwd^key;
    printf("原密码：%d， 加密后：%d, 解密后：%d\n", pwd, encodePwd, decodePwd);
    /** 打印结果：
     原密码：888888， 加密后：686414, 解密后：888888
     */
    
    printf("....\n");
    
    /**
     101 1000  --> 88
     110 0100  --> 100
     
     1、 88&100 按位且：一假都假; 
     有个小规律：任何位&1位都是该位， 比如位0&1为0位，位1&1位为1位
     101 1000
    &110 0100
     --------
     100 0000 --> 88 & 100 = 64
     另外：88&100 == 88&100&88 == 88&100&100 == 88&100&100&88
     
     2、 88|100 按位或：一真都真
     101 1000
    |110 0100
     --------
     111 1100 --> 88 | 100 = 64 + 32 + 16 + 8 + 4 = 124
     另外：88|100 == 88|100|88 == 100|88|100 == 88|100|88|100
     
     3、88^100 按位异或 ： 相同为0，不同为1; 
     规律总结：任何数num异或另外一个数num2两次，都等于该数num
     101 1000
    ^110 0100
     --------
     011 1100 --> 88^100 = 32 + 16 + 8 + 4 = 60
     即：88^100^100 == 88, 88^100^88 == 100
     */
    
    printf("0&1 = %d, 1&1 = %d \n", 0&1, 1&1);
    printf("88 & 100 = %d, 88 | 100 = %d, 88 ^ 100 = %d\n", 88 & 100, 88 | 100, 88 ^ 100);
    printf("88&100&88: %d, 100&88&100: %d, 88&100&100&88: %d, 88|100|88: %d, 100|88|100: %d, 88|100|100|88: %d \n", 88&100&88, 100&88&100, 88&100&100&88, 88|100|88, 100|88|100, 88|100|100|88);
    printf("88^100^88: %d, 100^88^100: %d, -88^100^-88: %d\n", 88^100^88, 100^88^100, -88^100^-88);
    /* 打印结果：
     0&1 = 0, 1&1 = 1
     88 & 100 = 64, 88 | 100 = 124, 88 ^ 100 = 60
     88&100&88: 64, 100&88&100: 64, 88&100&100&88: 64, 88|100|88: 124, 100|88|100: 124, 88|100|100|88: 124
     88^100^88: 100, 100^88^100: 88, -88^100^-88: 100
     */
    
    
    testConstPointer(); //测试指向常量的指针，和常量指针
    
    
    printf("\n");
    return 0;
}

/* 指向整形常量的指针，指向整型的常量指针，指向整型常量的常量指针 */
void testConstPointer(){
    //1、指针变量，指针变量可间接修改值，指针变量也可重新赋值新变量地址
    int a = 50, a2 = 22;
    int *ap = &a;
    *ap = 12;
    
    printf("测试1：a=%d, a地址：%x, *ap=%d, ap地址：%x, ap保存的地址：%x \n", a, &a, *ap, &ap, ap);
    printf("变量a占用字节个数：%lu, 变量ap占用字节个数：%lu \n", sizeof(a), sizeof(ap));
    //测试1：a=12, a地址：5fbff65c, *ap=12, ap地址：5fbff650, ap保存的地址：5fbff65c
    //变量a占用字节个数：4, 变量ap占用字节个数：8
    //验证一个问题：a占用的字节地址为5fbff65f-5fbff65c, ap占用的字节地址为：5fbff657-5fbff650
    *ap = 13;
    printf("测试2：a=%d, a地址：%x, *ap=%d, ap地址：%x, ap保存的地址：%x \n", a, &a, *ap, &ap, ap);
    //测试2：a=13, a地址：5fbff65c, *ap=13, ap地址：5fbff650, ap保存的地址：5fbff65c
    
    ap = &a2;
    printf("*ap=%d, a2=%d, &a2=%x, ap=%x \n", *ap, a2, &a2, ap);
    //*ap=22, a2=22, &a2=5fbff658, ap=5fbff658  //说明指针变量可以重新指向其他变量
    
    
    //2、测试指向整型常量的指针
    int c = 19, c2 = 29;
    int const *cp = &c;  //指向整型常量的指针
    printf("c1: c=%d, *cp=%d, &c=%x, cp=%x \n", c, *cp, &c, cp);
    //c1: c=19, *cp=19, &c=5fbff63c, cp=5fbff63c
//    *cp = 20; //报错：Read-only variable is not assignable
    //指向整形常量的指针，不能间接修改变量的值，因为指向整型常量
    c = 20;  //但是原变量自己可以直接修改自己的值
    printf("c2: c=%d, *cp=%d, &c=%x, cp=%x \n", c, *cp, &c, cp);
    //c2: c=20, *cp=20, &c=5fbff63c, cp=5fbff63c
    cp = &c2;
    printf("c3: c2=%d, *cp=%d, &c2 = %x, cp=%x \n", c2, *cp, &c2, cp);
    //c3: c2=29, *cp=29, &c2 = 5fbff638, cp=5fbff638
    
    
    //3、测试指向整型的常量指针
    int d = 31, d2 = 32;
    int* const dp = &d;
    printf("d1: d=%d, *dp=%d, &d=%x, dp=%x \n", d, *dp, &d, dp);
    //d1: d=31, *dp=31, &d=5fbff63c, dp=5fbff63c
    *dp = 3;
    printf("d2: d=%d, *dp=%d, &d=%x, dp=%x \n", d, *dp, &d, dp);
    //d2: d=3, *dp=3, &d=5fbff63c, dp=5fbff63c
    
//    dp = &d2; //报错：Cannot assign to variable 'dp' with const-qualified type 'int *const'
    //指向整型的常量指针，不能再重新赋值其他变量地址。但是可以间接修改当前指向的变量的值
    
    
    //4、测试指向整型常量的常量指针：既不能间接修改变量的值，也不能重新赋值新的变量地址
    int e = 41, e2 = 42;
    int const * const ep = &e;
//    *ep = 48; //报错：Read-only vaiable is not assignable
//    ep = &e2;//报错：Cannot assign to variable 'ep' with const-qualified type 'int *const'
    
    
    //5、指向常量的指针变量
    int const b = 50; //
    //    b = 30;  //编译报错：Cannot assign to variable 'b' with const-qualified type 'const int'
    int *bp = &b;
    printf("b=%d, b地址: %x, bp保存的地址：%x, *bp: %d \n", b, &b, bp, *bp);
    //b=50, b地址: 5fbff64c, bp保存的地址：5fbff64c, *bp: 50
    
    *bp = 88;
    printf("修改后b=%d, b地址: %x, bp保存的地址：%x, *bp: %d \n", b, &b, bp, *bp);
    //修改后b=50, b地址: 5fbff64c, bp保存的地址：5fbff64c, *bp: 88
    /*
     这个地方有点奇怪，b是常量，指针变量bp指向b, 间接通过指针bp修改变量的值，
     但是最后打印结果是：*bp的值变了，b的值没有变（b是常量，指针变量bp指向b), 而且bp保存的地址和b的地址还是保持一样
     这究竟是为啥？怎么理解 ？ 
     变量被const修饰时，就复制了其值出来放到常量表中（由系统维护）
     但是每次取常量时，它是从常量表找到以前的值，而不是再次读内存。
     而指针变量bp可以修改指向地址里面的值。
     不知这样理解是否正确？
     */
}
