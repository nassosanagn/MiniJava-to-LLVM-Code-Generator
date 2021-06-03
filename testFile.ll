@.Arrays_vtable = global [0 x i8*] []

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
	%x = alloca i32*

	%t0 = add i32 1, 2
	%t1 = icmp sge i32 %t0, 1
	br i1 %t1, label %nsz_ok_0, label %nsz_err_0

	nsz_err_0:
	call void @throw_nsz()
	br label %nsz_ok_0

	nsz_ok_0:
	%t2 = call i8* @calloc(i32 %t0, i32 4)
	%t3 = bitcast i8* %t2 to i32*
	store i32 2, i32* %t3
	store i32* %t3, i32** %x
	%t4 = load i32*, i32** %x
	%t5 = load i32, i32* %t4
	%t6 = icmp sge i32 0, 0
	%t7 = icmp slt i32 0, %t5
	%t8 = and i1 %t6, %t7
	br i1 %t8, label %oob_ok_0, label %oob_err_0

	oob_err_0:
	call void @throw_oob()
	br label %oob_ok_0

	oob_ok_0:
	%t9 = add i32 1, 0
	%t10 = getelementptr i32, i32* %t4, i32 %t9

	store i32 1, i32* %t10
	%t11 = load i32*, i32** %x
	%t12 = load i32, i32* %t11
	%t13 = icmp sge i32 0, 0
	%t14 = icmp slt i32 0, %t12
	%t15 = and i1 %t13, %t14
	br i1 %t15, label %oob_ok_1, label %oob_err_1

	oob_err_1:
	call void @throw_oob()
	br label %oob_ok_1

	oob_ok_1:
	%t16 = add i32 1, 1
	%t17 = getelementptr i32, i32* %t11, i32 %t16

	store i32 2, i32* %t17
	; einai sto array look up: x
	%t18 = load i32*, i32** %x
	%t19 = load i32, i32* %t18
	%t20 = icmp sge i32 0, 0
	%t21 = icmp slt i32 0, %t19
	%t22 = and i1 %t20, %t21
	br i1 %t22, label %oob_ok_2, label %oob_err_2

	oob_err_2:
	call void @throw_oob()
	br label %oob_ok_2

	oob_ok_2:
	%t23 = add i32 1, 0
	%t24 = getelementptr i32, i32* %t18, i32 %t23
	%t25 = load i32, i32* %t24

	; einai sto array look up: x
	%t26 = load i32*, i32** %x
	%t27 = load i32, i32* %t26
	%t28 = icmp sge i32 0, 0
	%t29 = icmp slt i32 0, %t27
	%t30 = and i1 %t28, %t29
	br i1 %t30, label %oob_ok_3, label %oob_err_3

	oob_err_3:
	call void @throw_oob()
	br label %oob_ok_3

	oob_ok_3:
	%t31 = add i32 1, 1
	%t32 = getelementptr i32, i32* %t26, i32 %t31
	%t33 = load i32, i32* %t32

	; mmphke sto add
	%t34 = add i32 %t25, %t33
	call void (i32) @print_int(i32 %t34)
	ret i32 0
}

