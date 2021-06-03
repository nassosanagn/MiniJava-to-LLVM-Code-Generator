@.LinearSearch_vtable = global [0 x i8*] []

@.LS_vtable = global [4 x i8*] [
	i8* bitcast (i32 (i8*,i32)* @LS.Start to i8*),
	i8* bitcast (i32 (i8*)* @LS.Print to i8*),
	i8* bitcast (i32 (i8*,i32)* @LS.Search to i8*),
	i8* bitcast (i32 (i8*,i32)* @LS.Init to i8*)
]

declare i8* @calloc(i32, i32)
declare i32 @printf(i8*, ...)
declare void @exit(i32)

@_cint = constant [4 x i8] c"%d\0a\00"
@_cOOB = constant [15 x i8] c"Out of bounds\0a\00"
@_cNSZ = constant [15 x i8] c"Negative size\0a\00"

define void @print_int(i32 %i) {
	%_str = bitcast [4 x i8]* @_cint to i8*
	call i32 (i8*, ...) @printf(i8* %_str, i32 %i)
	ret void
}

define void @throw_oob() {
	%_str = bitcast [15 x i8]* @_cOOB to i8*
	call i32 (i8*, ...) @printf(i8* %_str)
	call void @exit(i32 1)
	ret void
}

define void @throw_nsz() {
	%_str = bitcast [15 x i8]* @_cNSZ to i8*
	call i32 (i8*, ...) @printf(i8* %_str)
	call void @exit(i32 1)
	ret void
}

define i32 @main() {

	%t0 = call i8* @calloc(i32 1, i32 20)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [4 x i8*], [4 x i8*]* @.LS_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1

	; Message send here 
	%t3 = bitcast i8* %t0 to i8***
	%t4 = load i8**, i8*** %t3
	%t5 = getelementptr i8*, i8** %t4, i32 0
	%t6 = load i8*, i8** %t5
	%t7 = bitcast i8* %t6 to i32 (i8*,i32)*
	%t8 = call i32 %t7(i8* %t0, i32 10)
	call void (i32) @print_int(i32 %t8)
	ret i32 0
}

define i32 @LS.Start(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%aux01 = alloca i32
	%aux02 = alloca i32

	; Message send here 
	%t0 = bitcast i8* %this to i8***
	%t1 = load i8**, i8*** %t0
	%t2 = getelementptr i8*, i8** %t1, i32 3
	%t3 = load i8*, i8** %t2
	%t4 = bitcast i8* %t3 to i32 (i8*,i32)*
	%t5 = load i32, i32* %sz
	%t6 = call i32 %t4(i8* %this, i32 %t5)
	; Sto Assignment Statement 
	store i32 %t6, i32* %aux01

	; Message send here 
	%t7 = bitcast i8* %this to i8***
	%t8 = load i8**, i8*** %t7
	%t9 = getelementptr i8*, i8** %t8, i32 1
	%t10 = load i8*, i8** %t9
	%t11 = bitcast i8* %t10 to i32 (i8*)*
	%t12 = call i32 %t11(i8* %this)
	; Sto Assignment Statement 
	store i32 %t12, i32* %aux02
	call void (i32) @print_int(i32 9999)

	; Message send here 
	%t13 = bitcast i8* %this to i8***
	%t14 = load i8**, i8*** %t13
	%t15 = getelementptr i8*, i8** %t14, i32 2
	%t16 = load i8*, i8** %t15
	%t17 = bitcast i8* %t16 to i32 (i8*,i32)*
	%t18 = call i32 %t17(i8* %this, i32 8)
	call void (i32) @print_int(i32 %t18)

	; Message send here 
	%t19 = bitcast i8* %this to i8***
	%t20 = load i8**, i8*** %t19
	%t21 = getelementptr i8*, i8** %t20, i32 2
	%t22 = load i8*, i8** %t21
	%t23 = bitcast i8* %t22 to i32 (i8*,i32)*
	%t24 = call i32 %t23(i8* %this, i32 12)
	call void (i32) @print_int(i32 %t24)

	; Message send here 
	%t25 = bitcast i8* %this to i8***
	%t26 = load i8**, i8*** %t25
	%t27 = getelementptr i8*, i8** %t26, i32 2
	%t28 = load i8*, i8** %t27
	%t29 = bitcast i8* %t28 to i32 (i8*,i32)*
	%t30 = call i32 %t29(i8* %this, i32 17)
	call void (i32) @print_int(i32 %t30)

	; Message send here 
	%t31 = bitcast i8* %this to i8***
	%t32 = load i8**, i8*** %t31
	%t33 = getelementptr i8*, i8** %t32, i32 2
	%t34 = load i8*, i8** %t33
	%t35 = bitcast i8* %t34 to i32 (i8*,i32)*
	%t36 = call i32 %t35(i8* %this, i32 50)
	call void (i32) @print_int(i32 %t36)

	ret i32 55
}

define i32 @LS.Print(i8* %this) {
	%j = alloca i32
	store i32 1, i32* %j
	br label %loop0

	loop0:

	; CompareExpression
	%t0 = load i32, i32* %j
	%t1 = getelementptr i8, i8* %this, i32 16
	%t2 = bitcast i8* %t1 to i32*
	%t3 = load i32, i32* %t2
	%t4 = icmp slt i32 %t0, %t3
	br i1 %t4, label %loop1, label %loop2

	loop1:
	; einai sto array look up: number
	%t5 = getelementptr i8, i8* %this, i32 8
	%t6 = bitcast i8* %t5 to i32**
	%t7 = load i32*, i32** %t6

	%t8 = load i32, i32* %j
	%t9 = load i32, i32* %t7
	%t10 = icmp ult i32 %t8, %t9
	br i1 %t10, label %oob_ok_0, label %oob_err_0

	oob_ok_0:
	%t11 = add i32 %t8, 1
	%t12 = getelementptr i32, i32* %t7, i32 %t11
	%t13 = load i32, i32* %t12
	br label %oob_end_0

	oob_err_0:
	call void @throw_oob()
	br label %oob_end_0

	oob_end_0:
	;Array lookup sto print statement
	call void (i32) @print_int(i32 %t13)
	; mmphke sto add
	%t14 = add i32 %t13, 1
	%t15 = load i32, i32* %j
	store i32 %t15, i32* %j

	br label %loop0
	loop2:

	ret i32 0
}

define i32 @LS.Search(i8* %this, i32 %.num) {
	%num = alloca i32
	store i32 %.num, i32* %num
	%j = alloca i32
	%ls01 = alloca i1
	%ifound = alloca i32
	%aux01 = alloca i32
	%aux02 = alloca i32
	%nt = alloca i32
	store i32 1, i32* %j
	store i1 0, i1* %ls01

	store i32 0, i32* %ifound
	br label %loop0

	loop0:

	; CompareExpression
	%t0 = load i32, i32* %j
	%t1 = getelementptr i8, i8* %this, i32 16
	%t2 = bitcast i8* %t1 to i32*
	%t3 = load i32, i32* %t2
	%t4 = icmp slt i32 %t0, %t3
	br i1 %t4, label %loop1, label %loop2

	loop1:
	; einai sto array look up: number
	%t5 = getelementptr i8, i8* %this, i32 8
	%t6 = bitcast i8* %t5 to i32**
	%t7 = load i32*, i32** %t6

	%t8 = load i32, i32* %j
	%t9 = load i32, i32* %t7
	%t10 = icmp ult i32 %t8, %t9
	br i1 %t10, label %oob_ok_0, label %oob_err_0

	oob_ok_0:
	%t11 = add i32 %t8, 1
	%t12 = getelementptr i32, i32* %t7, i32 %t11
	%t13 = load i32, i32* %t12
	br label %oob_end_0

	oob_err_0:
	call void @throw_oob()
	br label %oob_end_0

	oob_end_0:
	; mmphke sto add
	%t14 = add i32 %t13, 1
	%t15 = load i32, i32* %num
	store i32 %t15, i32* %aux02


	; CompareExpression
	%t16 = load i32, i32* %aux01
	%t17 = load i32, i32* %num
	; stin arxh tou IfStatement
	br i1 %t17, label %if_then_0, label %if_else_0

	if_then_0:
	store i32 0, i32* %nt
	br label %if_end_0

	if_else_0:

	; CompareExpression
	%t18 = load i32, i32* %aux01
	%t19 = load i32, i32* %aux02
	%t20 = xor i1 1, %t19
	; stin arxh tou IfStatement
	br i1 %t20, label %if_then_1, label %if_else_1

	if_then_1:
	store i32 0, i32* %nt
	br label %if_end_1

	if_else_1:
	store i1 1, i1* %ls01

	store i32 1, i32* %ifound

	; Load and Store
	%t21 =  getelementptr i8, i8* %this, i32 16
	%t22 = bitcast i8* 21 to i32*
	%t23 = load i32, i32* %t22
	store i32 %t23, i32* %j

	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_end_0:
	; mmphke sto add
	%t24 = add i32 %t23, 1
	%t25 = load i32, i32* %j
	store i32 %t25, i32* %j

	br label %loop0
	loop2:
	%t26 = load i32, i32* %ifound

	ret i32 %t26
}

define i32 @LS.Init(i8* %this, i32 %.sz) {
	%sz = alloca i32
	store i32 %.sz, i32* %sz
	%j = alloca i32
	%k = alloca i32
	%aux01 = alloca i32
	%aux02 = alloca i32

	; Load and Store
	%t0 = load i32, i32* %sz
	%t1 = getelementptr i8, i8* %this, i32 16
	%t2 = bitcast i8* %t1 to i32*
	store i32 %t0, i32* %t2

	%t3 = load i32, i32* %sz
	%t4 = icmp slt i32 %t3, 0
	br i1 %t4, label %nsz_ok_0, label %nsz_err_0

	nsz_err_0:
	call void @throw_nsz()
	br label %nsz_ok_0

	nsz_ok_0:
	%t5 add i32 %t3, 1
	%t6 = call i8* @calloc(i32 %t4, i32 4)
	%t7 = bitcast i8* %t6 to i32*
	store i32 %t3, i32* %t7
	%t8 = getelementptr i8, i8* %this, i32
	%t9 = bitcast i8* %t8 to 
	store i32* %t5, i32** %t9

	store i32 1, i32* %j
	; mmphke sto add
	%t10 = getelementptr i8, i8* %this, i32 16
	%t11 = bitcast i8 %t*, 10to i32*
	%t12 = load i32, i32* %11
	%t13 = add i32 %t12, 1
	store i32 %t13, i32* %k

	br label %loop0

	loop0:

	; CompareExpression
	%t14 = load i32, i32* %j
	%t15 = getelementptr i8, i8* %this, i32 16
	%t16 = bitcast i8* %t15 to i32*
	%t17 = load i32, i32* %t16
	%t18 = icmp slt i32 %t14, %t17
	br i1 %t18, label %loop1, label %loop2

	loop1:
	; Sto Times Expression 
	%t19 = load i32, i32* %j
	%t20 = mul i32 2, %t19
	store i32 %t20, i32* %aux01

	; MinusExpression
	%t21 = load i32, i32* %k
	%t22 = sub i32 %t21, 3

	store i32 %t22, i32* %aux02

	%t23 = getelementptr i8, i8* %this, i32 8
	%t24 = bitcast i8* %t23 to i32**
	%t25 = load i32*, i32** %t24
	; mmphke sto add
	%t26 = load i32, i32* %aux01 + aux02
	; mmphke sto add
	%t27 = add i32 %t26, 1
	%t28 = load i32, i32* %j
	store i32 %t28, i32* %j


	; MinusExpression
	%t29 = load i32, i32* %k
	%t30 = sub i32 %t29, 1

	store i32 %t30, i32* %k

	br label %loop0
	loop2:

	ret i32 0
}

