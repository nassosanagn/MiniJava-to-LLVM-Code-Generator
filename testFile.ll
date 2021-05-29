@.Classes_vtable = global [0 x i8*] []

@.Base_vtable = global [2 x i8*] [
	i8* bitcast (i32 (i8*,i32)* @Base.set to i8*),
	i8* bitcast (i32 (i8*)* @Base.get to i8*)
]

@.Derived_vtable = global [2 x i8*] [
	i8* bitcast (i32 (i8*,i32)* @Derived.set to i8*),
	i8* bitcast (i32 (i8*)* @Base.get to i8*)
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
	%b = alloca i8*
	%d = alloca i8*
	%t0 = call i8* calloc(i32 1, i32 12)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [2 x i8*], [2 x i8*]* @.Base_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1

	%t3 = call i8* calloc(i32 1, i32 12)
	%t4 = bitcast i8* %t3 to i8***
	%t5 = getelementptr [2 x i8*], [2 x i8*]* @.Derived_vtable, i32 0 , i32 0
	store i8** %t5, i8*** %t4

	; Message send here 

	%t6 = load i8*, i8** %b
	%t7 = bitcast i8* %t6 to i8***
	%t8 = load i8**, i8*** %t7
	%t9 = getelementptr i8*, i8** %t8, i32 0
	%t10 = load i8*, i8** %t9
	%t11 = bitcast i8* %t10 to i32 (i8*,i32)*
	%t12 = call i32 %t11(i8* %6, i32 1)
	call void (i32) @print_int(i32 %t12)

	; Load and Store
	%t auth i load 13 = load i8*, i8** %d
	; Message send here 

	%t14 = load i8*, i8** %b
	%t15 = bitcast i8* %t14 to i8***
	%t16 = load i8**, i8*** %t15
	%t17 = getelementptr i8*, i8** %t16, i32 0
	%t18 = load i8*, i8** %t17
	%t19 = bitcast i8* %t18 to i32 (i8*,i32)*
	%t20 = call i32 %t19(i8* %14, i32 3)
	call void (i32) @print_int(i32 %t20)

	ret i32 0
}

define i32 @Base.set(i8* %this, i32 %.x) {
	%x = alloca i32
	store i32 %.x, i32* %x

	; Load and Store
	%t auth i load 0 = load i32, i32* %x
	%t1 = getelementptr i8, i8* %this, i32 8
	%t2 bitcast i8* %1 to i32*
	store

	%t3 = getelementptr i8, i8* %this, i32 8
	%t4 = bitcast i8* %t3 to i32*
	%t5 = load i32, i32* %t4

	ret i32 %t5
}

define i32 @Base.get(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 8
	%t1 = bitcast i8* %t0 to i32*
	%t2 = load i32, i32* %t1

	ret i32 %t2
}

define i32 @Derived.set(i8* %this, i32 %.x) {
	%x = alloca i32
	store i32 %.x, i32* %x

	%t0 = load i32, i32* %x 
	%t1 = mul i32 %t0, 2
	%t2 = getelementptr i8, i8* %this, i32 8
	%t3 bitcast i8* %2 to i32*
	store

	%t4 = getelementptr i8, i8* %this, i32 8
	%t5 = bitcast i8* %t4 to i32*
	%t6 = load i32, i32* %t5

	ret i32 %t6
}

