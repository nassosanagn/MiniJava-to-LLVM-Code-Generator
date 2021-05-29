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
	%t2 = getelementptr [0 x i8*], [0 x i8*]* @.Classes_vtable, i32 0 , i32 0
	%t2 = call i8* calloc(i32 1, i32 12)
	%t3 = bitcast i8* %t2 to i8***
	%t4 = getelementptr [0 x i8*], [0 x i8*]* @.Classes_vtable, i32 0 , i32 0

	ret i32 0
}

define i32 @set(i8* %this, i32 %.x) {
}

define i32 @get(i8* %this) {
}

define i32 @set(i8* %this, i32 %.x) {
	store i32 2, i32* %data
}

