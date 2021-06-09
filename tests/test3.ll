@.VTableDemo_vtable = global [0 x i8*] []

@.A_vtable = global [3 x i8*] [
	i8* bitcast (i32 (i8*)* @A.foo to i8*),
	i8* bitcast (i1 (i8*,i32)* @A.func to i8*),
	i8* bitcast (i1 (i8*)* @A.bla to i8*)
]

@.B_vtable = global [4 x i8*] [
	i8* bitcast (i32 (i8*)* @B.foo to i8*),
	i8* bitcast (i32 (i8*,i32)* @B.baz to i8*),
	i8* bitcast (i1 (i8*)* @A.func to i8*),
	i8* bitcast (i1 (i8*)* @A.bla to i8*)
]

@.C_vtable = global [4 x i8*] [
	i8* bitcast (i32 (i8*)* @C.foo to i8*),
	i8* bitcast (i32 (i8*)* @C.bar to i8*),
	i8* bitcast (i1 (i8*)* @C.bla to i8*),
	i8* bitcast (i32 (i8*)* @B.baz to i8*)
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

	ret i32 0
}

define i32 @A.foo(i8* %this) {

	ret i32 5
}

define i1 @A.func(i8* %this, i32 %.a) {
	%a = alloca i32
	store i32 %.a, i32* %a

	ret i1 1
}

define i1 @A.bla(i8* %this) {

	ret i1 1
}

define i32 @B.foo(i8* %this) {

	ret i32 6
}

define i32 @B.baz(i8* %this) {

	ret i32 7
}

define i32 @C.foo(i8* %this) {

	ret i32 8
}

define i32 @C.bar(i8* %this) {

	ret i32 9
}

define i1 @C.bla(i8* %this) {

	ret i1 0
}

