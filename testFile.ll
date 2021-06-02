@.Factorial_vtable = global [0 x i8*] []

@.Fac_vtable = global [1 x i8*] [
	i8* bitcast (i32 (i8*,i32)* @Fac.ComputeFac to i8*)
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

	%t0 = call i8* @calloc(i32 1, i32 8)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [1 x i8*], [1 x i8*]* @.Fac_vtable, i32 0 , i32 0
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

define i32 @Fac.ComputeFac(i8* %this, i32 %.num) {
	%num = alloca i32
	store i32 %.num, i32* %num
	%num_aux = alloca i32

	; CompareExpression
	%t0 = load i32, i32* %num
	; stin arxh tou IfStatement
	%t1 = icmp slt i32 %t0, 1
	br i1 %t1, label %if_then_0, label %if_else_0

	if_then_0:
	store i32 1, i32* %num_aux
	br label %if_end_0

	if_else_0:
	; Sto Times Expression 
	%t2 = load i32, i32* %num

	; Message send here 
	%t3 = bitcast i8* %this to i8***
	%t4 = load i8**, i8*** %t3
	%t5 = getelementptr i8*, i8** %t4, i32 0
	%t6 = load i8*, i8** %t5
	%t7 = bitcast i8* %t6 to i32 (i8*,i32)*

	; MinusExpression
	%t8 = load i32, i32* %num
	%t9 = sub i32 %t8, 1

	%t10 = call i32 %t7(i8* %this, i32 %t9)
	%t11 = mul i32 %t2, %t10
	; Sto Times Expression BGAINEI 22222 
	; Sto Assignment Statement 
	store i32 %t11, i32* %num_aux
	br label %if_end_0

	if_end_0:
	%t12 = load i32, i32* %num_aux

	ret i32 %t12
}

