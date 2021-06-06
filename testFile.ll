@.LinkedList_vtable = global [0 x i8*] []

@.Element_vtable = global [6 x i8*] [
	i8* bitcast (i1 (i8*,i32,i32,i1)* @Element.Init to i8*),
	i8* bitcast (i32 (i8*)* @Element.GetAge to i8*),
	i8* bitcast (i32 (i8*)* @Element.GetSalary to i8*),
	i8* bitcast (i1 (i8*)* @Element.GetMarried to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Element.Equal to i8*),
	i8* bitcast (i1 (i8*,i32,i32)* @Element.Compare to i8*)
]

@.List_vtable = global [10 x i8*] [
	i8* bitcast (i1 (i8*)* @List.Init to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*,i1)* @List.InitNew to i8*),
	i8* bitcast (i8* (i8*,i8*)* @List.Insert to i8*),
	i8* bitcast (i1 (i8*,i8*)* @List.SetNext to i8*),
	i8* bitcast (i8* (i8*,i8*)* @List.Delete to i8*),
	i8* bitcast (i32 (i8*,i8*)* @List.Search to i8*),
	i8* bitcast (i1 (i8*)* @List.GetEnd to i8*),
	i8* bitcast (i8* (i8*)* @List.GetElem to i8*),
	i8* bitcast (i8* (i8*)* @List.GetNext to i8*),
	i8* bitcast (i1 (i8*)* @List.Print to i8*)
]

@.LL_vtable = global [1 x i8*] [
	i8* bitcast (i32 (i8*)* @LL.Start to i8*)
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
	%t2 = getelementptr [1 x i8*], [1 x i8*]* @.LL_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	; sto message send: AllocationExpressionLL.Start
	%t3 = bitcast i8* %t0 to i8***
	%t4 = load i8**, i8*** %t3
	 ; to className einai: LL
	%t5 = getelementptr i8*, i8** %t4, i32 0
	%t6 = load i8*, i8** %t5
	%t7 = bitcast i8* %t6 to i32 (i8*)*
	%t8 = call i32 %t7(i8* %t0)
	call void (i32) @print_int(i32 %t8)
	ret i32 0
}

define i1 @Element.Init(i8* %this, i32 %.v_Age, i32 %.v_Salary, i1 %.v_Married) {
	%v_Age = alloca i32
	store i32 %.v_Age, i32* %v_Age
	%v_Salary = alloca i32
	store i32 %.v_Salary, i32* %v_Salary
	%v_Married = alloca i1
	store i1 %.v_Married, i1* %v_Married

	; Load and Store
	%t0 = load i32, i32* %v_Age
	%t1 = getelementptr i8, i8* %this, i32 8
	%t2 = bitcast i8* %t1 to i32*
	store i32 %t0, i32* %t2


	; Load and Store
	%t3 = load i32, i32* %v_Salary
	%t4 = getelementptr i8, i8* %this, i32 12
	%t5 = bitcast i8* %t4 to i32*
	store i32 %t3, i32* %t5


	; Load and Store
	%t6 = load i1, i1* %v_Married
	%t7 = getelementptr i8, i8* %this, i32 16
	%t8 = bitcast i8* %t7 to i1*
	store i1 %t6, i1* %t8


	ret i1 1
}

define i32 @Element.GetAge(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 8
	%t1 = bitcast i8* %t0 to i32*
	%t2 = load i32, i32* %t1

	ret i32 %t2
}

define i32 @Element.GetSalary(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 12
	%t1 = bitcast i8* %t0 to i32*
	%t2 = load i32, i32* %t1

	ret i32 %t2
}

define i1 @Element.GetMarried(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 16
	%t1 = bitcast i8* %t0 to i1*
	%t2 = load i1, i1* %t1

	ret i1 %t2
}

define i1 @Element.Equal(i8* %this, i8* %.other) {
	%other = alloca i8*
	store i8* %.other, i8** %other
	%ret_val = alloca i1
	%aux01 = alloca i32
	%aux02 = alloca i32
	%nt = alloca i32
	store i1 1, i1* %ret_val
	; sto message send: other.GetAge
	%t0 = load i8*, i8** %other
	%t1 = bitcast i8* %t0 to i8***
	%t2 = load i8**, i8*** %t1
	 ; to className einai: Element
	%t3 = getelementptr i8*, i8** %t2, i32 1
	%t4 = load i8*, i8** %t3
	%t5 = bitcast i8* %t4 to i32 (i8*)*
	%t6 = call i32 %t5(i8* %t0)
	; Sto Assignment Statement 
	store i32 %t6, i32* %aux01
	; sto message send: this.Compare
	%t7 = bitcast i8* %this to i8***
	%t8 = load i8**, i8*** %t7
	 ; to className einai: Element
	%t9 = getelementptr i8*, i8** %t8, i32 5
	%t10 = load i8*, i8** %t9
	%t11 = bitcast i8* %t10 to i1 (i8*,i32,i32)*
	;eimai sta orismata 
	%t12 = load i32, i32* %aux01
	%t13 = getelementptr i8, i8* %this, i32 8
	%t14 = bitcast i8* %t13 to i32*
	%t15 = load i32, i32* %t14
	%t16 = call i1 %t11(i8* %this, i32 %t12, i32 %t15)
	%t17 = xor i1 1, %t16
	; stin arxh tou IfStatement
	br i1 %t17, label %if_then_0, label %if_else_0

	if_then_0:
	store i1 0, i1* %ret_val
	br label %if_end_0

	if_else_0:
	; sto message send: other.GetSalary
	%t18 = load i8*, i8** %other
	%t19 = bitcast i8* %t18 to i8***
	%t20 = load i8**, i8*** %t19
	 ; to className einai: Element
	%t21 = getelementptr i8*, i8** %t20, i32 2
	%t22 = load i8*, i8** %t21
	%t23 = bitcast i8* %t22 to i32 (i8*)*
	%t24 = call i32 %t23(i8* %t18)
	; Sto Assignment Statement 
	store i32 %t24, i32* %aux02
	; sto message send: this.Compare
	%t25 = bitcast i8* %this to i8***
	%t26 = load i8**, i8*** %t25
	 ; to className einai: Element
	%t27 = getelementptr i8*, i8** %t26, i32 5
	%t28 = load i8*, i8** %t27
	%t29 = bitcast i8* %t28 to i1 (i8*,i32,i32)*
	;eimai sta orismata 
	%t30 = load i32, i32* %aux02
	%t31 = getelementptr i8, i8* %this, i32 12
	%t32 = bitcast i8* %t31 to i32*
	%t33 = load i32, i32* %t32
	%t34 = call i1 %t29(i8* %this, i32 %t30, i32 %t33)
	%t35 = xor i1 1, %t34
	; stin arxh tou IfStatement
	br i1 %t35, label %if_then_1, label %if_else_1

	if_then_1:
	store i1 0, i1* %ret_val
	br label %if_end_1

	if_else_1:
	; stin arxh tou IfStatement
	%t36 = getelementptr i8, i8* %this, i32 16
	%t37 = bitcast i8* %t36 to i1*
	%t38 = load i1, i1* %t37
	br i1 %t38, label %if_then_2, label %if_else_2

	if_then_2:
	; sto message send: other.GetMarried
	%t39 = load i8*, i8** %other
	%t40 = bitcast i8* %t39 to i8***
	%t41 = load i8**, i8*** %t40
	 ; to className einai: Element
	%t42 = getelementptr i8*, i8** %t41, i32 3
	%t43 = load i8*, i8** %t42
	%t44 = bitcast i8* %t43 to i1 (i8*)*
	%t45 = call i1 %t44(i8* %t39)
	%t46 = xor i1 1, %t45
	; stin arxh tou IfStatement
	br i1 %t46, label %if_then_3, label %if_else_3

	if_then_3:
	store i1 0, i1* %ret_val
	br label %if_end_3

	if_else_3:
	store i32 0, i32* %nt
	br label %if_end_3

	if_end_3:
	br label %if_end_2

	if_else_2:
	; sto message send: other.GetMarried
	%t47 = load i8*, i8** %other
	%t48 = bitcast i8* %t47 to i8***
	%t49 = load i8**, i8*** %t48
	 ; to className einai: Element
	%t50 = getelementptr i8*, i8** %t49, i32 3
	%t51 = load i8*, i8** %t50
	%t52 = bitcast i8* %t51 to i1 (i8*)*
	%t53 = call i1 %t52(i8* %t47)
	; stin arxh tou IfStatement
	br i1 %t53, label %if_then_4, label %if_else_4

	if_then_4:
	store i1 0, i1* %ret_val
	br label %if_end_4

	if_else_4:
	store i32 0, i32* %nt
	br label %if_end_4

	if_end_4:
	br label %if_end_2

	if_end_2:
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_end_0:
	%t54 = load i1, i1* %ret_val

	ret i1 %t54
}

define i1 @Element.Compare(i8* %this, i32 %.num1, i32 %.num2) {
	%num1 = alloca i32
	store i32 %.num1, i32* %num1
	%num2 = alloca i32
	store i32 %.num2, i32* %num2
	%retval = alloca i1
	%aux02 = alloca i32
	store i1 0, i1* %retval
	; mmphke sto add
	%t0 = load i32, i32* %num2
	%t1 = add i32 %t0, 1
	store i32 %t1, i32* %aux02

	; CompareExpression
	%t2 = load i32, i32* %num1
	%t3 = load i32, i32* %num2
	%t4 = icmp slt i32 %t2, %t3
	; stin arxh tou IfStatement
	br i1 %t4, label %if_then_0, label %if_else_0

	if_then_0:
	store i1 0, i1* %retval
	br label %if_end_0

	if_else_0:

	; CompareExpression
	%t5 = load i32, i32* %num1
	%t6 = load i32, i32* %aux02
	%t7 = icmp slt i32 %t5, %t6
	%t8 = xor i1 1, %t7
	; stin arxh tou IfStatement
	br i1 %t8, label %if_then_1, label %if_else_1

	if_then_1:
	store i1 0, i1* %retval
	br label %if_end_1

	if_else_1:
	store i1 1, i1* %retval
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_end_0:
	%t9 = load i1, i1* %retval

	ret i1 %t9
}

define i1 @List.Init(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 24
	%t1 = bitcast i8* %t0 to i1*
	store i1 1, i1* %t1


	ret i1 1
}

define i1 @List.InitNew(i8* %this, i8* %.v_elem, i8* %.v_next, i1 %.v_end) {
	%v_elem = alloca i8*
	store i8* %.v_elem, i8** %v_elem
	%v_next = alloca i8*
	store i8* %.v_next, i8** %v_next
	%v_end = alloca i1
	store i1 %.v_end, i1* %v_end

	; Load and Store
	%t0 = load i1, i1* %v_end
	%t1 = getelementptr i8, i8* %this, i32 24
	%t2 = bitcast i8* %t1 to i1*
	store i1 %t0, i1* %t2


	; Load and Store
	%t3 = load i8*, i8** %v_elem
	%t4 = getelementptr i8, i8* %this, i32 8
	%t5 = bitcast i8* %t4 to i8**
	store i8* %t3, i8** %t5


	; Load and Store
	%t6 = load i8*, i8** %v_next
	%t7 = getelementptr i8, i8* %this, i32 16
	%t8 = bitcast i8* %t7 to i8**
	store i8* %t6, i8** %t8


	ret i1 1
}

define i8* @List.Insert(i8* %this, i8* %.new_elem) {
	%new_elem = alloca i8*
	store i8* %.new_elem, i8** %new_elem
	%ret_val = alloca i1
	%aux03 = alloca i8*
	%aux02 = alloca i8*
	store i8* %this, i8** %aux03
	%t0 = call i8* @calloc(i32 1, i32 25)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [10 x i8*], [10 x i8*]* @.List_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	store i8* %t0, i8** %aux02

	; sto message send: aux02.InitNew
	%t3 = load i8*, i8** %aux02
	%t4 = bitcast i8* %t3 to i8***
	%t5 = load i8**, i8*** %t4
	 ; to className einai: List
	%t6 = getelementptr i8*, i8** %t5, i32 1
	%t7 = load i8*, i8** %t6
	%t8 = bitcast i8* %t7 to i1 (i8*,i8*,i8*,i1)*
	;eimai sta orismata 
	%t9 = load i8*, i8** %new_elem
	;eimai sta orismata 
	%t10 = load i8*, i8** %aux03
	%t11 = call i1 %t8(i8* %t3, i8* %t9, i8* %t10, i1 0)
	; Sto Assignment Statement 
	store i1 %t11, i1* %ret_val
	%t12 = load i8*, i8** %aux02

	ret i8* %t12
}

define i1 @List.SetNext(i8* %this, i8* %.v_next) {
	%v_next = alloca i8*
	store i8* %.v_next, i8** %v_next

	; Load and Store
	%t0 = load i8*, i8** %v_next
	%t1 = getelementptr i8, i8* %this, i32 16
	%t2 = bitcast i8* %t1 to i8**
	store i8* %t0, i8** %t2


	ret i1 1
}

define i8* @List.Delete(i8* %this, i8* %.e) {
	%e = alloca i8*
	store i8* %.e, i8** %e
	%my_head = alloca i8*
	%ret_val = alloca i1
	%aux05 = alloca i1
	%aux01 = alloca i8*
	%prev = alloca i8*
	%var_end = alloca i1
	%var_elem = alloca i8*
	%aux04 = alloca i32
	%nt = alloca i32
	store i8* %this, i8** %my_head
	store i1 0, i1* %ret_val

	; MinusExpression
	%t0 = sub i32 0, 1
	store i32 %t0, i32* %aux04
	store i8* %this, i8** %aux01
	store i8* %this, i8** %prev

	; Load and Store
	%t1 =  getelementptr i8, i8* %this, i32 24
	%t2 = bitcast i8* %t1 to i1*
	%t3 = load i1, i1* %t2
	store i1 %t3, i1* %var_end


	; Load and Store
	%t4 =  getelementptr i8, i8* %this, i32 8
	%t5 = bitcast i8* %t4 to i8**
	%t6 = load i8*, i8** %t5
	store i8* %t6, i8** %var_elem

	br label %loop0

	loop0:
	; mpainei sto && expression sti sinartisi Delete
	%t7 = load i1, i1* %var_end
	%t8 = xor i1 1, %t7
	br i1 %t8, label %exp_res_1, label %exp_res_0

	exp_res_0:
	br label %exp_res_3

	exp_res_1:
	%t9 = load i1, i1* %ret_val
	%t10 = xor i1 1, %t9
	br label %exp_res_2

	exp_res_2:
	br label %exp_res_3

	exp_res_3:
	%t11 = phi i1 [ 0, %exp_res_0 ], [ %t10, %exp_res_2 ]
	br i1 %t11, label %loop1, label %loop2

	loop1:
	; sto message send: e.Equal
	%t12 = load i8*, i8** %e
	%t13 = bitcast i8* %t12 to i8***
	%t14 = load i8**, i8*** %t13
	 ; to className einai: Element
	%t15 = getelementptr i8*, i8** %t14, i32 4
	%t16 = load i8*, i8** %t15
	%t17 = bitcast i8* %t16 to i1 (i8*,i8*)*
	;eimai sta orismata 
	%t18 = load i8*, i8** %var_elem
	%t19 = call i1 %t17(i8* %t12, i8* %t18)
	; stin arxh tou IfStatement
	br i1 %t19, label %if_then_0, label %if_else_0

	if_then_0:
	store i1 1, i1* %ret_val

	; CompareExpression
	%t20 = load i32, i32* %aux04
	; stin arxh tou IfStatement
	%t21 = icmp slt i32 %t20, 0
	br i1 %t21, label %if_then_1, label %if_else_1

	if_then_1:
	; sto message send: aux01.GetNext
	%t22 = load i8*, i8** %aux01
	%t23 = bitcast i8* %t22 to i8***
	%t24 = load i8**, i8*** %t23
	 ; to className einai: List
	%t25 = getelementptr i8*, i8** %t24, i32 8
	%t26 = load i8*, i8** %t25
	%t27 = bitcast i8* %t26 to i8* (i8*)*
	%t28 = call i8* %t27(i8* %t22)
	; Sto Assignment Statement 
	store i8* %t28, i8** %my_head
	br label %if_end_1

	if_else_1:

	; MinusExpression
	%t29 = sub i32 0, 555
	call void (i32) @print_int(i32 %t29)
	; sto message send: prev.SetNext
	%t30 = load i8*, i8** %prev
	%t31 = bitcast i8* %t30 to i8***
	%t32 = load i8**, i8*** %t31
	 ; to className einai: List
	%t33 = getelementptr i8*, i8** %t32, i32 3
	%t34 = load i8*, i8** %t33
	%t35 = bitcast i8* %t34 to i1 (i8*,i8*)*
	; sto message send: aux01.GetNext
	%t36 = load i8*, i8** %aux01
	%t37 = bitcast i8* %t36 to i8***
	%t38 = load i8**, i8*** %t37
	 ; to className einai: List
	%t39 = getelementptr i8*, i8** %t38, i32 8
	%t40 = load i8*, i8** %t39
	%t41 = bitcast i8* %t40 to i8* (i8*)*
	%t42 = call i8* %t41(i8* %t36)
	%t43 = call i1 %t35(i8* %t30, i8* %t42)
	; Sto Assignment Statement 
	store i1 %t43, i1* %aux05

	; MinusExpression
	%t44 = sub i32 0, 555
	call void (i32) @print_int(i32 %t44)
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_else_0:
	store i32 0, i32* %nt
	br label %if_end_0

	if_end_0:
	%t45 = load i1, i1* %ret_val
	%t46 = xor i1 1, %t45
	; stin arxh tou IfStatement
	br i1 %t46, label %if_then_2, label %if_else_2

	if_then_2:

	; Load and Store
	%t47 = load i8*, i8** %aux01
	store i8* %t47, i8** %prev

	; sto message send: aux01.GetNext
	%t48 = load i8*, i8** %aux01
	%t49 = bitcast i8* %t48 to i8***
	%t50 = load i8**, i8*** %t49
	 ; to className einai: List
	%t51 = getelementptr i8*, i8** %t50, i32 8
	%t52 = load i8*, i8** %t51
	%t53 = bitcast i8* %t52 to i8* (i8*)*
	%t54 = call i8* %t53(i8* %t48)
	; Sto Assignment Statement 
	store i8* %t54, i8** %aux01
	; sto message send: aux01.GetEnd
	%t55 = load i8*, i8** %aux01
	%t56 = bitcast i8* %t55 to i8***
	%t57 = load i8**, i8*** %t56
	 ; to className einai: List
	%t58 = getelementptr i8*, i8** %t57, i32 6
	%t59 = load i8*, i8** %t58
	%t60 = bitcast i8* %t59 to i1 (i8*)*
	%t61 = call i1 %t60(i8* %t55)
	; Sto Assignment Statement 
	store i1 %t61, i1* %var_end
	; sto message send: aux01.GetElem
	%t62 = load i8*, i8** %aux01
	%t63 = bitcast i8* %t62 to i8***
	%t64 = load i8**, i8*** %t63
	 ; to className einai: List
	%t65 = getelementptr i8*, i8** %t64, i32 7
	%t66 = load i8*, i8** %t65
	%t67 = bitcast i8* %t66 to i8* (i8*)*
	%t68 = call i8* %t67(i8* %t62)
	; Sto Assignment Statement 
	store i8* %t68, i8** %var_elem
	store i32 1, i32* %aux04
	br label %if_end_2

	if_else_2:
	store i32 0, i32* %nt
	br label %if_end_2

	if_end_2:
	br label %loop0
	loop2:
	%t69 = load i8*, i8** %my_head

	ret i8* %t69
}

define i32 @List.Search(i8* %this, i8* %.e) {
	%e = alloca i8*
	store i8* %.e, i8** %e
	%int_ret_val = alloca i32
	%aux01 = alloca i8*
	%var_elem = alloca i8*
	%var_end = alloca i1
	%nt = alloca i32
	store i32 0, i32* %int_ret_val
	store i8* %this, i8** %aux01

	; Load and Store
	%t0 =  getelementptr i8, i8* %this, i32 24
	%t1 = bitcast i8* %t0 to i1*
	%t2 = load i1, i1* %t1
	store i1 %t2, i1* %var_end


	; Load and Store
	%t3 =  getelementptr i8, i8* %this, i32 8
	%t4 = bitcast i8* %t3 to i8**
	%t5 = load i8*, i8** %t4
	store i8* %t5, i8** %var_elem

	br label %loop0

	loop0:
	%t6 = load i1, i1* %var_end
	%t7 = xor i1 1, %t6
	br i1 %t7, label %loop1, label %loop2

	loop1:
	; sto message send: e.Equal
	%t8 = load i8*, i8** %e
	%t9 = bitcast i8* %t8 to i8***
	%t10 = load i8**, i8*** %t9
	 ; to className einai: Element
	%t11 = getelementptr i8*, i8** %t10, i32 4
	%t12 = load i8*, i8** %t11
	%t13 = bitcast i8* %t12 to i1 (i8*,i8*)*
	;eimai sta orismata 
	%t14 = load i8*, i8** %var_elem
	%t15 = call i1 %t13(i8* %t8, i8* %t14)
	; stin arxh tou IfStatement
	br i1 %t15, label %if_then_0, label %if_else_0

	if_then_0:
	store i32 1, i32* %int_ret_val
	br label %if_end_0

	if_else_0:
	store i32 0, i32* %nt
	br label %if_end_0

	if_end_0:
	; sto message send: aux01.GetNext
	%t16 = load i8*, i8** %aux01
	%t17 = bitcast i8* %t16 to i8***
	%t18 = load i8**, i8*** %t17
	 ; to className einai: List
	%t19 = getelementptr i8*, i8** %t18, i32 8
	%t20 = load i8*, i8** %t19
	%t21 = bitcast i8* %t20 to i8* (i8*)*
	%t22 = call i8* %t21(i8* %t16)
	; Sto Assignment Statement 
	store i8* %t22, i8** %aux01
	; sto message send: aux01.GetEnd
	%t23 = load i8*, i8** %aux01
	%t24 = bitcast i8* %t23 to i8***
	%t25 = load i8**, i8*** %t24
	 ; to className einai: List
	%t26 = getelementptr i8*, i8** %t25, i32 6
	%t27 = load i8*, i8** %t26
	%t28 = bitcast i8* %t27 to i1 (i8*)*
	%t29 = call i1 %t28(i8* %t23)
	; Sto Assignment Statement 
	store i1 %t29, i1* %var_end
	; sto message send: aux01.GetElem
	%t30 = load i8*, i8** %aux01
	%t31 = bitcast i8* %t30 to i8***
	%t32 = load i8**, i8*** %t31
	 ; to className einai: List
	%t33 = getelementptr i8*, i8** %t32, i32 7
	%t34 = load i8*, i8** %t33
	%t35 = bitcast i8* %t34 to i8* (i8*)*
	%t36 = call i8* %t35(i8* %t30)
	; Sto Assignment Statement 
	store i8* %t36, i8** %var_elem
	br label %loop0
	loop2:
	%t37 = load i32, i32* %int_ret_val

	ret i32 %t37
}

define i1 @List.GetEnd(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 24
	%t1 = bitcast i8* %t0 to i1*
	%t2 = load i1, i1* %t1

	ret i1 %t2
}

define i8* @List.GetElem(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 8
	%t1 = bitcast i8* %t0 to i8**
	%t2 = load i8*, i8** %t1

	ret i8* %t2
}

define i8* @List.GetNext(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 16
	%t1 = bitcast i8* %t0 to i8**
	%t2 = load i8*, i8** %t1

	ret i8* %t2
}

define i1 @List.Print(i8* %this) {
	%aux01 = alloca i8*
	%var_end = alloca i1
	%var_elem = alloca i8*
	store i8* %this, i8** %aux01

	; Load and Store
	%t0 =  getelementptr i8, i8* %this, i32 24
	%t1 = bitcast i8* %t0 to i1*
	%t2 = load i1, i1* %t1
	store i1 %t2, i1* %var_end


	; Load and Store
	%t3 =  getelementptr i8, i8* %this, i32 8
	%t4 = bitcast i8* %t3 to i8**
	%t5 = load i8*, i8** %t4
	store i8* %t5, i8** %var_elem

	br label %loop0

	loop0:
	%t6 = load i1, i1* %var_end
	%t7 = xor i1 1, %t6
	br i1 %t7, label %loop1, label %loop2

	loop1:
	; sto message send: var_elem.GetAge
	%t8 = load i8*, i8** %var_elem
	%t9 = bitcast i8* %t8 to i8***
	%t10 = load i8**, i8*** %t9
	 ; to className einai: Element
	%t11 = getelementptr i8*, i8** %t10, i32 1
	%t12 = load i8*, i8** %t11
	%t13 = bitcast i8* %t12 to i32 (i8*)*
	%t14 = call i32 %t13(i8* %t8)
	call void (i32) @print_int(i32 %t14)
	; sto message send: aux01.GetNext
	%t15 = load i8*, i8** %aux01
	%t16 = bitcast i8* %t15 to i8***
	%t17 = load i8**, i8*** %t16
	 ; to className einai: List
	%t18 = getelementptr i8*, i8** %t17, i32 8
	%t19 = load i8*, i8** %t18
	%t20 = bitcast i8* %t19 to i8* (i8*)*
	%t21 = call i8* %t20(i8* %t15)
	; Sto Assignment Statement 
	store i8* %t21, i8** %aux01
	; sto message send: aux01.GetEnd
	%t22 = load i8*, i8** %aux01
	%t23 = bitcast i8* %t22 to i8***
	%t24 = load i8**, i8*** %t23
	 ; to className einai: List
	%t25 = getelementptr i8*, i8** %t24, i32 6
	%t26 = load i8*, i8** %t25
	%t27 = bitcast i8* %t26 to i1 (i8*)*
	%t28 = call i1 %t27(i8* %t22)
	; Sto Assignment Statement 
	store i1 %t28, i1* %var_end
	; sto message send: aux01.GetElem
	%t29 = load i8*, i8** %aux01
	%t30 = bitcast i8* %t29 to i8***
	%t31 = load i8**, i8*** %t30
	 ; to className einai: List
	%t32 = getelementptr i8*, i8** %t31, i32 7
	%t33 = load i8*, i8** %t32
	%t34 = bitcast i8* %t33 to i8* (i8*)*
	%t35 = call i8* %t34(i8* %t29)
	; Sto Assignment Statement 
	store i8* %t35, i8** %var_elem
	br label %loop0
	loop2:

	ret i1 1
}

define i32 @LL.Start(i8* %this) {
	%head = alloca i8*
	%last_elem = alloca i8*
	%aux01 = alloca i1
	%el01 = alloca i8*
	%el02 = alloca i8*
	%el03 = alloca i8*
	%t0 = call i8* @calloc(i32 1, i32 25)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [10 x i8*], [10 x i8*]* @.List_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	store i8* %t0, i8** %last_elem

	; sto message send: last_elem.Init
	%t3 = load i8*, i8** %last_elem
	%t4 = bitcast i8* %t3 to i8***
	%t5 = load i8**, i8*** %t4
	 ; to className einai: List
	%t6 = getelementptr i8*, i8** %t5, i32 0
	%t7 = load i8*, i8** %t6
	%t8 = bitcast i8* %t7 to i1 (i8*)*
	%t9 = call i1 %t8(i8* %t3)
	; Sto Assignment Statement 
	store i1 %t9, i1* %aux01

	; Load and Store
	%t10 = load i8*, i8** %last_elem
	store i8* %t10, i8** %head

	; sto message send: head.Init
	%t11 = load i8*, i8** %head
	%t12 = bitcast i8* %t11 to i8***
	%t13 = load i8**, i8*** %t12
	 ; to className einai: List
	%t14 = getelementptr i8*, i8** %t13, i32 0
	%t15 = load i8*, i8** %t14
	%t16 = bitcast i8* %t15 to i1 (i8*)*
	%t17 = call i1 %t16(i8* %t11)
	; Sto Assignment Statement 
	store i1 %t17, i1* %aux01
	; sto message send: head.Print
	%t18 = load i8*, i8** %head
	%t19 = bitcast i8* %t18 to i8***
	%t20 = load i8**, i8*** %t19
	 ; to className einai: List
	%t21 = getelementptr i8*, i8** %t20, i32 9
	%t22 = load i8*, i8** %t21
	%t23 = bitcast i8* %t22 to i1 (i8*)*
	%t24 = call i1 %t23(i8* %t18)
	; Sto Assignment Statement 
	store i1 %t24, i1* %aux01
	%t25 = call i8* @calloc(i32 1, i32 17)
	%t26 = bitcast i8* %t25 to i8***
	%t27 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0 , i32 0
	store i8** %t27, i8*** %t26
	store i8* %t25, i8** %el01

	; sto message send: el01.Init
	%t28 = load i8*, i8** %el01
	%t29 = bitcast i8* %t28 to i8***
	%t30 = load i8**, i8*** %t29
	 ; to className einai: Element
	%t31 = getelementptr i8*, i8** %t30, i32 0
	%t32 = load i8*, i8** %t31
	%t33 = bitcast i8* %t32 to i1 (i8*,i32,i32,i1)*
	%t34 = call i1 %t33(i8* %t28, i32 25, i32 37000, i1 0)
	; Sto Assignment Statement 
	store i1 %t34, i1* %aux01
	; sto message send: head.Insert
	%t35 = load i8*, i8** %head
	%t36 = bitcast i8* %t35 to i8***
	%t37 = load i8**, i8*** %t36
	 ; to className einai: List
	%t38 = getelementptr i8*, i8** %t37, i32 2
	%t39 = load i8*, i8** %t38
	%t40 = bitcast i8* %t39 to i8* (i8*,i8*)*
	;eimai sta orismata 
	%t41 = load i8*, i8** %el01
	%t42 = call i8* %t40(i8* %t35, i8* %t41)
	; Sto Assignment Statement 
	store i8* %t42, i8** %head
	; sto message send: head.Print
	%t43 = load i8*, i8** %head
	%t44 = bitcast i8* %t43 to i8***
	%t45 = load i8**, i8*** %t44
	 ; to className einai: List
	%t46 = getelementptr i8*, i8** %t45, i32 9
	%t47 = load i8*, i8** %t46
	%t48 = bitcast i8* %t47 to i1 (i8*)*
	%t49 = call i1 %t48(i8* %t43)
	; Sto Assignment Statement 
	store i1 %t49, i1* %aux01
	call void (i32) @print_int(i32 10000000)
	%t50 = call i8* @calloc(i32 1, i32 17)
	%t51 = bitcast i8* %t50 to i8***
	%t52 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0 , i32 0
	store i8** %t52, i8*** %t51
	store i8* %t50, i8** %el01

	; sto message send: el01.Init
	%t53 = load i8*, i8** %el01
	%t54 = bitcast i8* %t53 to i8***
	%t55 = load i8**, i8*** %t54
	 ; to className einai: Element
	%t56 = getelementptr i8*, i8** %t55, i32 0
	%t57 = load i8*, i8** %t56
	%t58 = bitcast i8* %t57 to i1 (i8*,i32,i32,i1)*
	%t59 = call i1 %t58(i8* %t53, i32 39, i32 42000, i1 1)
	; Sto Assignment Statement 
	store i1 %t59, i1* %aux01

	; Load and Store
	%t60 = load i8*, i8** %el01
	store i8* %t60, i8** %el02

	; sto message send: head.Insert
	%t61 = load i8*, i8** %head
	%t62 = bitcast i8* %t61 to i8***
	%t63 = load i8**, i8*** %t62
	 ; to className einai: List
	%t64 = getelementptr i8*, i8** %t63, i32 2
	%t65 = load i8*, i8** %t64
	%t66 = bitcast i8* %t65 to i8* (i8*,i8*)*
	;eimai sta orismata 
	%t67 = load i8*, i8** %el01
	%t68 = call i8* %t66(i8* %t61, i8* %t67)
	; Sto Assignment Statement 
	store i8* %t68, i8** %head
	; sto message send: head.Print
	%t69 = load i8*, i8** %head
	%t70 = bitcast i8* %t69 to i8***
	%t71 = load i8**, i8*** %t70
	 ; to className einai: List
	%t72 = getelementptr i8*, i8** %t71, i32 9
	%t73 = load i8*, i8** %t72
	%t74 = bitcast i8* %t73 to i1 (i8*)*
	%t75 = call i1 %t74(i8* %t69)
	; Sto Assignment Statement 
	store i1 %t75, i1* %aux01
	call void (i32) @print_int(i32 10000000)
	%t76 = call i8* @calloc(i32 1, i32 17)
	%t77 = bitcast i8* %t76 to i8***
	%t78 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0 , i32 0
	store i8** %t78, i8*** %t77
	store i8* %t76, i8** %el01

	; sto message send: el01.Init
	%t79 = load i8*, i8** %el01
	%t80 = bitcast i8* %t79 to i8***
	%t81 = load i8**, i8*** %t80
	 ; to className einai: Element
	%t82 = getelementptr i8*, i8** %t81, i32 0
	%t83 = load i8*, i8** %t82
	%t84 = bitcast i8* %t83 to i1 (i8*,i32,i32,i1)*
	%t85 = call i1 %t84(i8* %t79, i32 22, i32 34000, i1 0)
	; Sto Assignment Statement 
	store i1 %t85, i1* %aux01
	; sto message send: head.Insert
	%t86 = load i8*, i8** %head
	%t87 = bitcast i8* %t86 to i8***
	%t88 = load i8**, i8*** %t87
	 ; to className einai: List
	%t89 = getelementptr i8*, i8** %t88, i32 2
	%t90 = load i8*, i8** %t89
	%t91 = bitcast i8* %t90 to i8* (i8*,i8*)*
	;eimai sta orismata 
	%t92 = load i8*, i8** %el01
	%t93 = call i8* %t91(i8* %t86, i8* %t92)
	; Sto Assignment Statement 
	store i8* %t93, i8** %head
	; sto message send: head.Print
	%t94 = load i8*, i8** %head
	%t95 = bitcast i8* %t94 to i8***
	%t96 = load i8**, i8*** %t95
	 ; to className einai: List
	%t97 = getelementptr i8*, i8** %t96, i32 9
	%t98 = load i8*, i8** %t97
	%t99 = bitcast i8* %t98 to i1 (i8*)*
	%t100 = call i1 %t99(i8* %t94)
	; Sto Assignment Statement 
	store i1 %t100, i1* %aux01
	%t101 = call i8* @calloc(i32 1, i32 17)
	%t102 = bitcast i8* %t101 to i8***
	%t103 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0 , i32 0
	store i8** %t103, i8*** %t102
	store i8* %t101, i8** %el03

	; sto message send: el03.Init
	%t104 = load i8*, i8** %el03
	%t105 = bitcast i8* %t104 to i8***
	%t106 = load i8**, i8*** %t105
	 ; to className einai: Element
	%t107 = getelementptr i8*, i8** %t106, i32 0
	%t108 = load i8*, i8** %t107
	%t109 = bitcast i8* %t108 to i1 (i8*,i32,i32,i1)*
	%t110 = call i1 %t109(i8* %t104, i32 27, i32 34000, i1 0)
	; Sto Assignment Statement 
	store i1 %t110, i1* %aux01
	; sto message send: head.Search
	%t111 = load i8*, i8** %head
	%t112 = bitcast i8* %t111 to i8***
	%t113 = load i8**, i8*** %t112
	 ; to className einai: List
	%t114 = getelementptr i8*, i8** %t113, i32 5
	%t115 = load i8*, i8** %t114
	%t116 = bitcast i8* %t115 to i32 (i8*,i8*)*
	;eimai sta orismata 
	%t117 = load i8*, i8** %el02
	%t118 = call i32 %t116(i8* %t111, i8* %t117)
	call void (i32) @print_int(i32 %t118)
	; sto message send: head.Search
	%t119 = load i8*, i8** %head
	%t120 = bitcast i8* %t119 to i8***
	%t121 = load i8**, i8*** %t120
	 ; to className einai: List
	%t122 = getelementptr i8*, i8** %t121, i32 5
	%t123 = load i8*, i8** %t122
	%t124 = bitcast i8* %t123 to i32 (i8*,i8*)*
	;eimai sta orismata 
	%t125 = load i8*, i8** %el03
	%t126 = call i32 %t124(i8* %t119, i8* %t125)
	call void (i32) @print_int(i32 %t126)
	call void (i32) @print_int(i32 10000000)
	%t127 = call i8* @calloc(i32 1, i32 17)
	%t128 = bitcast i8* %t127 to i8***
	%t129 = getelementptr [6 x i8*], [6 x i8*]* @.Element_vtable, i32 0 , i32 0
	store i8** %t129, i8*** %t128
	store i8* %t127, i8** %el01

	; sto message send: el01.Init
	%t130 = load i8*, i8** %el01
	%t131 = bitcast i8* %t130 to i8***
	%t132 = load i8**, i8*** %t131
	 ; to className einai: Element
	%t133 = getelementptr i8*, i8** %t132, i32 0
	%t134 = load i8*, i8** %t133
	%t135 = bitcast i8* %t134 to i1 (i8*,i32,i32,i1)*
	%t136 = call i1 %t135(i8* %t130, i32 28, i32 35000, i1 0)
	; Sto Assignment Statement 
	store i1 %t136, i1* %aux01
	; sto message send: head.Insert
	%t137 = load i8*, i8** %head
	%t138 = bitcast i8* %t137 to i8***
	%t139 = load i8**, i8*** %t138
	 ; to className einai: List
	%t140 = getelementptr i8*, i8** %t139, i32 2
	%t141 = load i8*, i8** %t140
	%t142 = bitcast i8* %t141 to i8* (i8*,i8*)*
	;eimai sta orismata 
	%t143 = load i8*, i8** %el01
	%t144 = call i8* %t142(i8* %t137, i8* %t143)
	; Sto Assignment Statement 
	store i8* %t144, i8** %head
	; sto message send: head.Print
	%t145 = load i8*, i8** %head
	%t146 = bitcast i8* %t145 to i8***
	%t147 = load i8**, i8*** %t146
	 ; to className einai: List
	%t148 = getelementptr i8*, i8** %t147, i32 9
	%t149 = load i8*, i8** %t148
	%t150 = bitcast i8* %t149 to i1 (i8*)*
	%t151 = call i1 %t150(i8* %t145)
	; Sto Assignment Statement 
	store i1 %t151, i1* %aux01
	call void (i32) @print_int(i32 2220000)
	; sto message send: head.Delete
	%t152 = load i8*, i8** %head
	%t153 = bitcast i8* %t152 to i8***
	%t154 = load i8**, i8*** %t153
	 ; to className einai: List
	%t155 = getelementptr i8*, i8** %t154, i32 4
	%t156 = load i8*, i8** %t155
	%t157 = bitcast i8* %t156 to i8* (i8*,i8*)*
	;eimai sta orismata 
	%t158 = load i8*, i8** %el02
	%t159 = call i8* %t157(i8* %t152, i8* %t158)
	; Sto Assignment Statement 
	store i8* %t159, i8** %head
	; sto message send: head.Print
	%t160 = load i8*, i8** %head
	%t161 = bitcast i8* %t160 to i8***
	%t162 = load i8**, i8*** %t161
	 ; to className einai: List
	%t163 = getelementptr i8*, i8** %t162, i32 9
	%t164 = load i8*, i8** %t163
	%t165 = bitcast i8* %t164 to i1 (i8*)*
	%t166 = call i1 %t165(i8* %t160)
	; Sto Assignment Statement 
	store i1 %t166, i1* %aux01
	call void (i32) @print_int(i32 33300000)
	; sto message send: head.Delete
	%t167 = load i8*, i8** %head
	%t168 = bitcast i8* %t167 to i8***
	%t169 = load i8**, i8*** %t168
	 ; to className einai: List
	%t170 = getelementptr i8*, i8** %t169, i32 4
	%t171 = load i8*, i8** %t170
	%t172 = bitcast i8* %t171 to i8* (i8*,i8*)*
	;eimai sta orismata 
	%t173 = load i8*, i8** %el01
	%t174 = call i8* %t172(i8* %t167, i8* %t173)
	; Sto Assignment Statement 
	store i8* %t174, i8** %head
	; sto message send: head.Print
	%t175 = load i8*, i8** %head
	%t176 = bitcast i8* %t175 to i8***
	%t177 = load i8**, i8*** %t176
	 ; to className einai: List
	%t178 = getelementptr i8*, i8** %t177, i32 9
	%t179 = load i8*, i8** %t178
	%t180 = bitcast i8* %t179 to i1 (i8*)*
	%t181 = call i1 %t180(i8* %t175)
	; Sto Assignment Statement 
	store i1 %t181, i1* %aux01
	call void (i32) @print_int(i32 44440000)

	ret i32 0
}

