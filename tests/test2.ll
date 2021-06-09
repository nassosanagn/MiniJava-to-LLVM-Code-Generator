@.AndShortC_vtable = global [0 x i8*] []

@.A_vtable = global [1 x i8*] [
	i8* bitcast (i1 (i8*)* @A.eval to i8*)
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
	%b = alloca i1
	%x = alloca i32
	%c = alloca i8*

	%t0 = call i8* @calloc(i32 1, i32 8)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [1 x i8*], [1 x i8*]* @.A_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	store i8* %t0, i8** %c

	store i1 0, i1* %b
	; mpainei sto && expression sti sinartisi main
	%t3 = load i1, i1* %b
	br i1 %t3, label %exp_res_1, label %exp_res_0

	exp_res_0:
	br label %exp_res_3

	exp_res_1:
	; sto message send: c.eval
	; edw mpainei to psaximo tou l
	%t4 = load i8*, i8** %c
	%t5 = bitcast i8* %t4 to i8***
	%t6 = load i8**, i8*** %t5
	 ; to className einai: A
	%t7 = getelementptr i8*, i8** %t6, i32 0
	%t8 = load i8*, i8** %t7
	%t9 = bitcast i8* %t8 to i1 (i8*)*
	%t10 = call i1 %t9(i8* %t4)
	br label %exp_res_2

	exp_res_2:
	br label %exp_res_3

	exp_res_3:
	%t11 = phi i1 [ 0, %exp_res_0 ], [ %t10, %exp_res_2 ]
	; stin arxh tou IfStatement
	br i1 %t11, label %if_then_0, label %if_else_0

	if_then_0:
	store i32 0, i32* %x
	br label %if_end_0

	if_else_0:
	store i32 1, i32* %x
	br label %if_end_0

	if_end_0:
	%t12 = load i32, i32* %x
	call void (i32) @print_int(i32 %t12)
	ret i32 0
}

define i1 @A.eval(i8* %this) {
	call void (i32) @print_int(i32 6969)

	ret i1 1
}

