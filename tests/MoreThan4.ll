@.MoreThan4_vtable = global [0 x i8*] []

@.MT4_vtable = global [2 x i8*] [
	i8* bitcast (i32 (i8*,i32,i32,i32,i32,i32,i32)* @MT4.Start to i8*),
	i8* bitcast (i32 (i8*,i32,i32,i32,i32,i32,i32)* @MT4.Change to i8*)
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
	%t2 = getelementptr [2 x i8*], [2 x i8*]* @.MT4_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	; sto message send: AllocationExpressionMT4.Start
	%t3 = bitcast i8* %t0 to i8***
	%t4 = load i8**, i8*** %t3
	 ; to className einai: MT4
	%t5 = getelementptr i8*, i8** %t4, i32 0
	%t6 = load i8*, i8** %t5
	%t7 = bitcast i8* %t6 to i32 (i8*,i32,i32,i32,i32,i32,i32)*
	%t8 = call i32 %t7(i8* %t0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6)
	call void (i32) @print_int(i32 %t8)
	ret i32 0
}

define i32 @MT4.Start(i8* %this, i32 %.p1, i32 %.p2, i32 %.p3, i32 %.p4, i32 %.p5, i32 %.p6) {
	%p1 = alloca i32
	store i32 %.p1, i32* %p1
	%p2 = alloca i32
	store i32 %.p2, i32* %p2
	%p3 = alloca i32
	store i32 %.p3, i32* %p3
	%p4 = alloca i32
	store i32 %.p4, i32* %p4
	%p5 = alloca i32
	store i32 %.p5, i32* %p5
	%p6 = alloca i32
	store i32 %.p6, i32* %p6
	%aux = alloca i32
	%t0 = load i32, i32* %p1
	call void (i32) @print_int(i32 %t0)
	%t1 = load i32, i32* %p2
	call void (i32) @print_int(i32 %t1)
	%t2 = load i32, i32* %p3
	call void (i32) @print_int(i32 %t2)
	%t3 = load i32, i32* %p4
	call void (i32) @print_int(i32 %t3)
	%t4 = load i32, i32* %p5
	call void (i32) @print_int(i32 %t4)
	%t5 = load i32, i32* %p6
	call void (i32) @print_int(i32 %t5)
	; sto message send: this.Change
	%t6 = bitcast i8* %this to i8***
	%t7 = load i8**, i8*** %t6
	 ; to className einai: MT4
	%t8 = getelementptr i8*, i8** %t7, i32 1
	%t9 = load i8*, i8** %t8
	%t10 = bitcast i8* %t9 to i32 (i8*,i32,i32,i32,i32,i32,i32)*
	;eimai sta orismata 
	%t11 = load i32, i32* %p6
	;eimai sta orismata 
	%t12 = load i32, i32* %p5
	;eimai sta orismata 
	%t13 = load i32, i32* %p4
	;eimai sta orismata 
	%t14 = load i32, i32* %p3
	;eimai sta orismata 
	%t15 = load i32, i32* %p2
	;eimai sta orismata 
	%t16 = load i32, i32* %p1
	%t17 = call i32 %t10(i8* %this, i32 %t11, i32 %t12, i32 %t13, i32 %t14, i32 %t15, i32 %t16)
	; Sto Assignment Statement 
	store i32 %t17, i32* %aux
	%t18 = load i32, i32* %aux

	ret i32 %t18
}

define i32 @MT4.Change(i8* %this, i32 %.p1, i32 %.p2, i32 %.p3, i32 %.p4, i32 %.p5, i32 %.p6) {
	%p1 = alloca i32
	store i32 %.p1, i32* %p1
	%p2 = alloca i32
	store i32 %.p2, i32* %p2
	%p3 = alloca i32
	store i32 %.p3, i32* %p3
	%p4 = alloca i32
	store i32 %.p4, i32* %p4
	%p5 = alloca i32
	store i32 %.p5, i32* %p5
	%p6 = alloca i32
	store i32 %.p6, i32* %p6
	%t0 = load i32, i32* %p1
	call void (i32) @print_int(i32 %t0)
	%t1 = load i32, i32* %p2
	call void (i32) @print_int(i32 %t1)
	%t2 = load i32, i32* %p3
	call void (i32) @print_int(i32 %t2)
	%t3 = load i32, i32* %p4
	call void (i32) @print_int(i32 %t3)
	%t4 = load i32, i32* %p5
	call void (i32) @print_int(i32 %t4)
	%t5 = load i32, i32* %p6
	call void (i32) @print_int(i32 %t5)

	ret i32 0
}

