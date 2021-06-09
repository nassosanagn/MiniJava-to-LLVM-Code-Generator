@.BinaryTree_vtable = global [0 x i8*] []

@.BT_vtable = global [1 x i8*] [
	i8* bitcast (i32 (i8*)* @BT.Start to i8*)
]

@.Tree_vtable = global [20 x i8*] [
	i8* bitcast (i1 (i8*,i32)* @Tree.Init to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Tree.SetRight to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Tree.SetLeft to i8*),
	i8* bitcast (i8* (i8*)* @Tree.GetRight to i8*),
	i8* bitcast (i8* (i8*)* @Tree.GetLeft to i8*),
	i8* bitcast (i32 (i8*)* @Tree.GetKey to i8*),
	i8* bitcast (i1 (i8*,i32)* @Tree.SetKey to i8*),
	i8* bitcast (i1 (i8*)* @Tree.GetHas_Right to i8*),
	i8* bitcast (i1 (i8*)* @Tree.GetHas_Left to i8*),
	i8* bitcast (i1 (i8*,i1)* @Tree.SetHas_Left to i8*),
	i8* bitcast (i1 (i8*,i1)* @Tree.SetHas_Right to i8*),
	i8* bitcast (i1 (i8*,i32,i32)* @Tree.Compare to i8*),
	i8* bitcast (i1 (i8*,i32)* @Tree.Insert to i8*),
	i8* bitcast (i1 (i8*,i32)* @Tree.Delete to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*)* @Tree.Remove to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*)* @Tree.RemoveRight to i8*),
	i8* bitcast (i1 (i8*,i8*,i8*)* @Tree.RemoveLeft to i8*),
	i8* bitcast (i32 (i8*,i32)* @Tree.Search to i8*),
	i8* bitcast (i1 (i8*)* @Tree.Print to i8*),
	i8* bitcast (i1 (i8*,i8*)* @Tree.RecPrint to i8*)
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
	%t2 = getelementptr [1 x i8*], [1 x i8*]* @.BT_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	; sto message send: AllocationExpressionBT.Start
	%t3 = bitcast i8* %t0 to i8***
	%t4 = load i8**, i8*** %t3
	 ; to className einai: BT
	%t5 = getelementptr i8*, i8** %t4, i32 0
	%t6 = load i8*, i8** %t5
	%t7 = bitcast i8* %t6 to i32 (i8*)*
	%t8 = call i32 %t7(i8* %t0)
	call void (i32) @print_int(i32 %t8)
	ret i32 0
}

define i32 @BT.Start(i8* %this) {
	%root = alloca i8*
	%ntb = alloca i1
	%nti = alloca i32
	%t0 = call i8* @calloc(i32 1, i32 38)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [20 x i8*], [20 x i8*]* @.Tree_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	store i8* %t0, i8** %root

	; sto message send: root.Init
	; edw mpainei to psaximo tou l
	%t3 = load i8*, i8** %root
	%t4 = bitcast i8* %t3 to i8***
	%t5 = load i8**, i8*** %t4
	 ; to className einai: Tree
	%t6 = getelementptr i8*, i8** %t5, i32 0
	%t7 = load i8*, i8** %t6
	%t8 = bitcast i8* %t7 to i1 (i8*,i32)*
	%t9 = call i1 %t8(i8* %t3, i32 16)
	; Sto Assignment Statement 
	store i1 %t9, i1* %ntb
	; sto message send: root.Print
	; edw mpainei to psaximo tou l
	%t10 = load i8*, i8** %root
	%t11 = bitcast i8* %t10 to i8***
	%t12 = load i8**, i8*** %t11
	 ; to className einai: Tree
	%t13 = getelementptr i8*, i8** %t12, i32 18
	%t14 = load i8*, i8** %t13
	%t15 = bitcast i8* %t14 to i1 (i8*)*
	%t16 = call i1 %t15(i8* %t10)
	; Sto Assignment Statement 
	store i1 %t16, i1* %ntb
	call void (i32) @print_int(i32 100000000)
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t17 = load i8*, i8** %root
	%t18 = bitcast i8* %t17 to i8***
	%t19 = load i8**, i8*** %t18
	 ; to className einai: Tree
	%t20 = getelementptr i8*, i8** %t19, i32 12
	%t21 = load i8*, i8** %t20
	%t22 = bitcast i8* %t21 to i1 (i8*,i32)*
	%t23 = call i1 %t22(i8* %t17, i32 8)
	; Sto Assignment Statement 
	store i1 %t23, i1* %ntb
	; sto message send: root.Print
	; edw mpainei to psaximo tou l
	%t24 = load i8*, i8** %root
	%t25 = bitcast i8* %t24 to i8***
	%t26 = load i8**, i8*** %t25
	 ; to className einai: Tree
	%t27 = getelementptr i8*, i8** %t26, i32 18
	%t28 = load i8*, i8** %t27
	%t29 = bitcast i8* %t28 to i1 (i8*)*
	%t30 = call i1 %t29(i8* %t24)
	; Sto Assignment Statement 
	store i1 %t30, i1* %ntb
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t31 = load i8*, i8** %root
	%t32 = bitcast i8* %t31 to i8***
	%t33 = load i8**, i8*** %t32
	 ; to className einai: Tree
	%t34 = getelementptr i8*, i8** %t33, i32 12
	%t35 = load i8*, i8** %t34
	%t36 = bitcast i8* %t35 to i1 (i8*,i32)*
	%t37 = call i1 %t36(i8* %t31, i32 24)
	; Sto Assignment Statement 
	store i1 %t37, i1* %ntb
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t38 = load i8*, i8** %root
	%t39 = bitcast i8* %t38 to i8***
	%t40 = load i8**, i8*** %t39
	 ; to className einai: Tree
	%t41 = getelementptr i8*, i8** %t40, i32 12
	%t42 = load i8*, i8** %t41
	%t43 = bitcast i8* %t42 to i1 (i8*,i32)*
	%t44 = call i1 %t43(i8* %t38, i32 4)
	; Sto Assignment Statement 
	store i1 %t44, i1* %ntb
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t45 = load i8*, i8** %root
	%t46 = bitcast i8* %t45 to i8***
	%t47 = load i8**, i8*** %t46
	 ; to className einai: Tree
	%t48 = getelementptr i8*, i8** %t47, i32 12
	%t49 = load i8*, i8** %t48
	%t50 = bitcast i8* %t49 to i1 (i8*,i32)*
	%t51 = call i1 %t50(i8* %t45, i32 12)
	; Sto Assignment Statement 
	store i1 %t51, i1* %ntb
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t52 = load i8*, i8** %root
	%t53 = bitcast i8* %t52 to i8***
	%t54 = load i8**, i8*** %t53
	 ; to className einai: Tree
	%t55 = getelementptr i8*, i8** %t54, i32 12
	%t56 = load i8*, i8** %t55
	%t57 = bitcast i8* %t56 to i1 (i8*,i32)*
	%t58 = call i1 %t57(i8* %t52, i32 20)
	; Sto Assignment Statement 
	store i1 %t58, i1* %ntb
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t59 = load i8*, i8** %root
	%t60 = bitcast i8* %t59 to i8***
	%t61 = load i8**, i8*** %t60
	 ; to className einai: Tree
	%t62 = getelementptr i8*, i8** %t61, i32 12
	%t63 = load i8*, i8** %t62
	%t64 = bitcast i8* %t63 to i1 (i8*,i32)*
	%t65 = call i1 %t64(i8* %t59, i32 28)
	; Sto Assignment Statement 
	store i1 %t65, i1* %ntb
	; sto message send: root.Insert
	; edw mpainei to psaximo tou l
	%t66 = load i8*, i8** %root
	%t67 = bitcast i8* %t66 to i8***
	%t68 = load i8**, i8*** %t67
	 ; to className einai: Tree
	%t69 = getelementptr i8*, i8** %t68, i32 12
	%t70 = load i8*, i8** %t69
	%t71 = bitcast i8* %t70 to i1 (i8*,i32)*
	%t72 = call i1 %t71(i8* %t66, i32 14)
	; Sto Assignment Statement 
	store i1 %t72, i1* %ntb
	; sto message send: root.Print
	; edw mpainei to psaximo tou l
	%t73 = load i8*, i8** %root
	%t74 = bitcast i8* %t73 to i8***
	%t75 = load i8**, i8*** %t74
	 ; to className einai: Tree
	%t76 = getelementptr i8*, i8** %t75, i32 18
	%t77 = load i8*, i8** %t76
	%t78 = bitcast i8* %t77 to i1 (i8*)*
	%t79 = call i1 %t78(i8* %t73)
	; Sto Assignment Statement 
	store i1 %t79, i1* %ntb
	; sto message send: root.Search
	; edw mpainei to psaximo tou l
	%t80 = load i8*, i8** %root
	%t81 = bitcast i8* %t80 to i8***
	%t82 = load i8**, i8*** %t81
	 ; to className einai: Tree
	%t83 = getelementptr i8*, i8** %t82, i32 17
	%t84 = load i8*, i8** %t83
	%t85 = bitcast i8* %t84 to i32 (i8*,i32)*
	%t86 = call i32 %t85(i8* %t80, i32 24)
	call void (i32) @print_int(i32 %t86)
	; sto message send: root.Search
	; edw mpainei to psaximo tou l
	%t87 = load i8*, i8** %root
	%t88 = bitcast i8* %t87 to i8***
	%t89 = load i8**, i8*** %t88
	 ; to className einai: Tree
	%t90 = getelementptr i8*, i8** %t89, i32 17
	%t91 = load i8*, i8** %t90
	%t92 = bitcast i8* %t91 to i32 (i8*,i32)*
	%t93 = call i32 %t92(i8* %t87, i32 12)
	call void (i32) @print_int(i32 %t93)
	; sto message send: root.Search
	; edw mpainei to psaximo tou l
	%t94 = load i8*, i8** %root
	%t95 = bitcast i8* %t94 to i8***
	%t96 = load i8**, i8*** %t95
	 ; to className einai: Tree
	%t97 = getelementptr i8*, i8** %t96, i32 17
	%t98 = load i8*, i8** %t97
	%t99 = bitcast i8* %t98 to i32 (i8*,i32)*
	%t100 = call i32 %t99(i8* %t94, i32 16)
	call void (i32) @print_int(i32 %t100)
	; sto message send: root.Search
	; edw mpainei to psaximo tou l
	%t101 = load i8*, i8** %root
	%t102 = bitcast i8* %t101 to i8***
	%t103 = load i8**, i8*** %t102
	 ; to className einai: Tree
	%t104 = getelementptr i8*, i8** %t103, i32 17
	%t105 = load i8*, i8** %t104
	%t106 = bitcast i8* %t105 to i32 (i8*,i32)*
	%t107 = call i32 %t106(i8* %t101, i32 50)
	call void (i32) @print_int(i32 %t107)
	; sto message send: root.Search
	; edw mpainei to psaximo tou l
	%t108 = load i8*, i8** %root
	%t109 = bitcast i8* %t108 to i8***
	%t110 = load i8**, i8*** %t109
	 ; to className einai: Tree
	%t111 = getelementptr i8*, i8** %t110, i32 17
	%t112 = load i8*, i8** %t111
	%t113 = bitcast i8* %t112 to i32 (i8*,i32)*
	%t114 = call i32 %t113(i8* %t108, i32 12)
	call void (i32) @print_int(i32 %t114)
	; sto message send: root.Delete
	; edw mpainei to psaximo tou l
	%t115 = load i8*, i8** %root
	%t116 = bitcast i8* %t115 to i8***
	%t117 = load i8**, i8*** %t116
	 ; to className einai: Tree
	%t118 = getelementptr i8*, i8** %t117, i32 13
	%t119 = load i8*, i8** %t118
	%t120 = bitcast i8* %t119 to i1 (i8*,i32)*
	%t121 = call i1 %t120(i8* %t115, i32 12)
	; Sto Assignment Statement 
	store i1 %t121, i1* %ntb
	; sto message send: root.Print
	; edw mpainei to psaximo tou l
	%t122 = load i8*, i8** %root
	%t123 = bitcast i8* %t122 to i8***
	%t124 = load i8**, i8*** %t123
	 ; to className einai: Tree
	%t125 = getelementptr i8*, i8** %t124, i32 18
	%t126 = load i8*, i8** %t125
	%t127 = bitcast i8* %t126 to i1 (i8*)*
	%t128 = call i1 %t127(i8* %t122)
	; Sto Assignment Statement 
	store i1 %t128, i1* %ntb
	; sto message send: root.Search
	; edw mpainei to psaximo tou l
	%t129 = load i8*, i8** %root
	%t130 = bitcast i8* %t129 to i8***
	%t131 = load i8**, i8*** %t130
	 ; to className einai: Tree
	%t132 = getelementptr i8*, i8** %t131, i32 17
	%t133 = load i8*, i8** %t132
	%t134 = bitcast i8* %t133 to i32 (i8*,i32)*
	%t135 = call i32 %t134(i8* %t129, i32 12)
	call void (i32) @print_int(i32 %t135)

	ret i32 0
}

define i1 @Tree.Init(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%t0 = load i32, i32* %v_key
	%t1 = getelementptr i8, i8* %this, i32 24
	%t2 = bitcast i8* %t1 to i32*
	store i32 %t0, i32* %t2

	%t3 = getelementptr i8, i8* %this, i32 28
	%t4 = bitcast i8* %t3 to i1*
	store i1 0, i1* %t4

	%t5 = getelementptr i8, i8* %this, i32 29
	%t6 = bitcast i8* %t5 to i1*
	store i1 0, i1* %t6


	ret i1 1
}

define i1 @Tree.SetRight(i8* %this, i8* %.rn) {
	%rn = alloca i8*
	store i8* %.rn, i8** %rn
	%t0 = load i8*, i8** %rn
	%t1 = getelementptr i8, i8* %this, i32 16
	%t2 = bitcast i8* %t1 to i8**
	store i8* %t0, i8** %t2


	ret i1 1
}

define i1 @Tree.SetLeft(i8* %this, i8* %.ln) {
	%ln = alloca i8*
	store i8* %.ln, i8** %ln
	%t0 = load i8*, i8** %ln
	%t1 = getelementptr i8, i8* %this, i32 8
	%t2 = bitcast i8* %t1 to i8**
	store i8* %t0, i8** %t2


	ret i1 1
}

define i8* @Tree.GetRight(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 16
	%t1 = bitcast i8* %t0 to i8**
	%t2 = load i8*, i8** %t1

	ret i8* %t2
}

define i8* @Tree.GetLeft(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 8
	%t1 = bitcast i8* %t0 to i8**
	%t2 = load i8*, i8** %t1

	ret i8* %t2
}

define i32 @Tree.GetKey(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 24
	%t1 = bitcast i8* %t0 to i32*
	%t2 = load i32, i32* %t1

	ret i32 %t2
}

define i1 @Tree.SetKey(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%t0 = load i32, i32* %v_key
	%t1 = getelementptr i8, i8* %this, i32 24
	%t2 = bitcast i8* %t1 to i32*
	store i32 %t0, i32* %t2


	ret i1 1
}

define i1 @Tree.GetHas_Right(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 29
	%t1 = bitcast i8* %t0 to i1*
	%t2 = load i1, i1* %t1

	ret i1 %t2
}

define i1 @Tree.GetHas_Left(i8* %this) {
	%t0 = getelementptr i8, i8* %this, i32 28
	%t1 = bitcast i8* %t0 to i1*
	%t2 = load i1, i1* %t1

	ret i1 %t2
}

define i1 @Tree.SetHas_Left(i8* %this, i1 %.val) {
	%val = alloca i1
	store i1 %.val, i1* %val
	%t0 = load i1, i1* %val
	%t1 = getelementptr i8, i8* %this, i32 28
	%t2 = bitcast i8* %t1 to i1*
	store i1 %t0, i1* %t2


	ret i1 1
}

define i1 @Tree.SetHas_Right(i8* %this, i1 %.val) {
	%val = alloca i1
	store i1 %.val, i1* %val
	%t0 = load i1, i1* %val
	%t1 = getelementptr i8, i8* %this, i32 29
	%t2 = bitcast i8* %t1 to i1*
	store i1 %t0, i1* %t2


	ret i1 1
}

define i1 @Tree.Compare(i8* %this, i32 %.num1, i32 %.num2) {
	%num1 = alloca i32
	store i32 %.num1, i32* %num1
	%num2 = alloca i32
	store i32 %.num2, i32* %num2
	%ntb = alloca i1
	%nti = alloca i32
	store i1 0, i1* %ntb
	; mmphke sto add
	%t0 = load i32, i32* %num2
	%t1 = add i32 %t0, 1
	store i32 %t1, i32* %nti

	; CompareExpression
	%t2 = load i32, i32* %num1
	%t3 = load i32, i32* %num2
	%t4 = icmp slt i32 %t2, %t3
	; stin arxh tou IfStatement
	br i1 %t4, label %if_then_0, label %if_else_0

	if_then_0:
	store i1 0, i1* %ntb
	br label %if_end_0

	if_else_0:

	; CompareExpression
	%t5 = load i32, i32* %num1
	%t6 = load i32, i32* %nti
	%t7 = icmp slt i32 %t5, %t6
	%t8 = xor i1 1, %t7
	; stin arxh tou IfStatement
	br i1 %t8, label %if_then_1, label %if_else_1

	if_then_1:
	store i1 0, i1* %ntb
	br label %if_end_1

	if_else_1:
	store i1 1, i1* %ntb
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_end_0:
	%t9 = load i1, i1* %ntb

	ret i1 %t9
}

define i1 @Tree.Insert(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%new_node = alloca i8*
	%ntb = alloca i1
	%cont = alloca i1
	%key_aux = alloca i32
	%current_node = alloca i8*
	%t0 = call i8* @calloc(i32 1, i32 38)
	%t1 = bitcast i8* %t0 to i8***
	%t2 = getelementptr [20 x i8*], [20 x i8*]* @.Tree_vtable, i32 0 , i32 0
	store i8** %t2, i8*** %t1
	store i8* %t0, i8** %new_node

	; sto message send: new_node.Init
	; edw mpainei to psaximo tou l
	%t3 = load i8*, i8** %new_node
	%t4 = bitcast i8* %t3 to i8***
	%t5 = load i8**, i8*** %t4
	 ; to className einai: Tree
	%t6 = getelementptr i8*, i8** %t5, i32 0
	%t7 = load i8*, i8** %t6
	%t8 = bitcast i8* %t7 to i1 (i8*,i32)*
	;eimai sta orismata 
	%t9 = load i32, i32* %v_key
	%t10 = call i1 %t8(i8* %t3, i32 %t9)
	; Sto Assignment Statement 
	store i1 %t10, i1* %ntb
	store i8* %this, i8** %current_node
	store i1 1, i1* %cont
	br label %loop0

	loop0:
	%t11 = load i1, i1* %cont
	br i1 %t11, label %loop1, label %loop2

	loop1:
	; sto message send: current_node.GetKey
	; edw mpainei to psaximo tou l
	%t12 = load i8*, i8** %current_node
	%t13 = bitcast i8* %t12 to i8***
	%t14 = load i8**, i8*** %t13
	 ; to className einai: Tree
	%t15 = getelementptr i8*, i8** %t14, i32 5
	%t16 = load i8*, i8** %t15
	%t17 = bitcast i8* %t16 to i32 (i8*)*
	%t18 = call i32 %t17(i8* %t12)
	; Sto Assignment Statement 
	store i32 %t18, i32* %key_aux

	; CompareExpression
	%t19 = load i32, i32* %v_key
	%t20 = load i32, i32* %key_aux
	%t21 = icmp slt i32 %t19, %t20
	; stin arxh tou IfStatement
	br i1 %t21, label %if_then_0, label %if_else_0

	if_then_0:
	; sto message send: current_node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t22 = load i8*, i8** %current_node
	%t23 = bitcast i8* %t22 to i8***
	%t24 = load i8**, i8*** %t23
	 ; to className einai: Tree
	%t25 = getelementptr i8*, i8** %t24, i32 8
	%t26 = load i8*, i8** %t25
	%t27 = bitcast i8* %t26 to i1 (i8*)*
	%t28 = call i1 %t27(i8* %t22)
	; stin arxh tou IfStatement
	br i1 %t28, label %if_then_1, label %if_else_1

	if_then_1:
	; sto message send: current_node.GetLeft
	; edw mpainei to psaximo tou l
	%t29 = load i8*, i8** %current_node
	%t30 = bitcast i8* %t29 to i8***
	%t31 = load i8**, i8*** %t30
	 ; to className einai: Tree
	%t32 = getelementptr i8*, i8** %t31, i32 4
	%t33 = load i8*, i8** %t32
	%t34 = bitcast i8* %t33 to i8* (i8*)*
	%t35 = call i8* %t34(i8* %t29)
	; Sto Assignment Statement 
	store i8* %t35, i8** %current_node
	br label %if_end_1

	if_else_1:
	store i1 0, i1* %cont
	; sto message send: current_node.SetHas_Left
	; edw mpainei to psaximo tou l
	%t36 = load i8*, i8** %current_node
	%t37 = bitcast i8* %t36 to i8***
	%t38 = load i8**, i8*** %t37
	 ; to className einai: Tree
	%t39 = getelementptr i8*, i8** %t38, i32 9
	%t40 = load i8*, i8** %t39
	%t41 = bitcast i8* %t40 to i1 (i8*,i1)*
	%t42 = call i1 %t41(i8* %t36, i1 1)
	; Sto Assignment Statement 
	store i1 %t42, i1* %ntb
	; sto message send: current_node.SetLeft
	; edw mpainei to psaximo tou l
	%t43 = load i8*, i8** %current_node
	%t44 = bitcast i8* %t43 to i8***
	%t45 = load i8**, i8*** %t44
	 ; to className einai: Tree
	%t46 = getelementptr i8*, i8** %t45, i32 2
	%t47 = load i8*, i8** %t46
	%t48 = bitcast i8* %t47 to i1 (i8*,i8*)*
	;eimai sta orismata 
	%t49 = load i8*, i8** %new_node
	%t50 = call i1 %t48(i8* %t43, i8* %t49)
	; Sto Assignment Statement 
	store i1 %t50, i1* %ntb
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_else_0:
	; sto message send: current_node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t51 = load i8*, i8** %current_node
	%t52 = bitcast i8* %t51 to i8***
	%t53 = load i8**, i8*** %t52
	 ; to className einai: Tree
	%t54 = getelementptr i8*, i8** %t53, i32 7
	%t55 = load i8*, i8** %t54
	%t56 = bitcast i8* %t55 to i1 (i8*)*
	%t57 = call i1 %t56(i8* %t51)
	; stin arxh tou IfStatement
	br i1 %t57, label %if_then_2, label %if_else_2

	if_then_2:
	; sto message send: current_node.GetRight
	; edw mpainei to psaximo tou l
	%t58 = load i8*, i8** %current_node
	%t59 = bitcast i8* %t58 to i8***
	%t60 = load i8**, i8*** %t59
	 ; to className einai: Tree
	%t61 = getelementptr i8*, i8** %t60, i32 3
	%t62 = load i8*, i8** %t61
	%t63 = bitcast i8* %t62 to i8* (i8*)*
	%t64 = call i8* %t63(i8* %t58)
	; Sto Assignment Statement 
	store i8* %t64, i8** %current_node
	br label %if_end_2

	if_else_2:
	store i1 0, i1* %cont
	; sto message send: current_node.SetHas_Right
	; edw mpainei to psaximo tou l
	%t65 = load i8*, i8** %current_node
	%t66 = bitcast i8* %t65 to i8***
	%t67 = load i8**, i8*** %t66
	 ; to className einai: Tree
	%t68 = getelementptr i8*, i8** %t67, i32 10
	%t69 = load i8*, i8** %t68
	%t70 = bitcast i8* %t69 to i1 (i8*,i1)*
	%t71 = call i1 %t70(i8* %t65, i1 1)
	; Sto Assignment Statement 
	store i1 %t71, i1* %ntb
	; sto message send: current_node.SetRight
	; edw mpainei to psaximo tou l
	%t72 = load i8*, i8** %current_node
	%t73 = bitcast i8* %t72 to i8***
	%t74 = load i8**, i8*** %t73
	 ; to className einai: Tree
	%t75 = getelementptr i8*, i8** %t74, i32 1
	%t76 = load i8*, i8** %t75
	%t77 = bitcast i8* %t76 to i1 (i8*,i8*)*
	;eimai sta orismata 
	%t78 = load i8*, i8** %new_node
	%t79 = call i1 %t77(i8* %t72, i8* %t78)
	; Sto Assignment Statement 
	store i1 %t79, i1* %ntb
	br label %if_end_2

	if_end_2:
	br label %if_end_0

	if_end_0:
	br label %loop0
	loop2:

	ret i1 1
}

define i1 @Tree.Delete(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%current_node = alloca i8*
	%parent_node = alloca i8*
	%cont = alloca i1
	%found = alloca i1
	%is_root = alloca i1
	%key_aux = alloca i32
	%ntb = alloca i1
	store i8* %this, i8** %current_node
	store i8* %this, i8** %parent_node
	store i1 1, i1* %cont
	store i1 0, i1* %found
	store i1 1, i1* %is_root
	br label %loop0

	loop0:
	%t0 = load i1, i1* %cont
	br i1 %t0, label %loop1, label %loop2

	loop1:
	; sto message send: current_node.GetKey
	; edw mpainei to psaximo tou l
	%t1 = load i8*, i8** %current_node
	%t2 = bitcast i8* %t1 to i8***
	%t3 = load i8**, i8*** %t2
	 ; to className einai: Tree
	%t4 = getelementptr i8*, i8** %t3, i32 5
	%t5 = load i8*, i8** %t4
	%t6 = bitcast i8* %t5 to i32 (i8*)*
	%t7 = call i32 %t6(i8* %t1)
	; Sto Assignment Statement 
	store i32 %t7, i32* %key_aux

	; CompareExpression
	%t8 = load i32, i32* %v_key
	%t9 = load i32, i32* %key_aux
	%t10 = icmp slt i32 %t8, %t9
	; stin arxh tou IfStatement
	br i1 %t10, label %if_then_0, label %if_else_0

	if_then_0:
	; sto message send: current_node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t11 = load i8*, i8** %current_node
	%t12 = bitcast i8* %t11 to i8***
	%t13 = load i8**, i8*** %t12
	 ; to className einai: Tree
	%t14 = getelementptr i8*, i8** %t13, i32 8
	%t15 = load i8*, i8** %t14
	%t16 = bitcast i8* %t15 to i1 (i8*)*
	%t17 = call i1 %t16(i8* %t11)
	; stin arxh tou IfStatement
	br i1 %t17, label %if_then_1, label %if_else_1

	if_then_1:
	%t18 = load i8*, i8** %current_node
	 ; to brhkeeeeeee
	store i8* %t18, i8** %parent_node

	; sto message send: current_node.GetLeft
	; edw mpainei to psaximo tou l
	%t19 = load i8*, i8** %current_node
	%t20 = bitcast i8* %t19 to i8***
	%t21 = load i8**, i8*** %t20
	 ; to className einai: Tree
	%t22 = getelementptr i8*, i8** %t21, i32 4
	%t23 = load i8*, i8** %t22
	%t24 = bitcast i8* %t23 to i8* (i8*)*
	%t25 = call i8* %t24(i8* %t19)
	; Sto Assignment Statement 
	store i8* %t25, i8** %current_node
	br label %if_end_1

	if_else_1:
	store i1 0, i1* %cont
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_else_0:

	; CompareExpression
	%t26 = load i32, i32* %key_aux
	%t27 = load i32, i32* %v_key
	%t28 = icmp slt i32 %t26, %t27
	; stin arxh tou IfStatement
	br i1 %t28, label %if_then_2, label %if_else_2

	if_then_2:
	; sto message send: current_node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t29 = load i8*, i8** %current_node
	%t30 = bitcast i8* %t29 to i8***
	%t31 = load i8**, i8*** %t30
	 ; to className einai: Tree
	%t32 = getelementptr i8*, i8** %t31, i32 7
	%t33 = load i8*, i8** %t32
	%t34 = bitcast i8* %t33 to i1 (i8*)*
	%t35 = call i1 %t34(i8* %t29)
	; stin arxh tou IfStatement
	br i1 %t35, label %if_then_3, label %if_else_3

	if_then_3:
	%t36 = load i8*, i8** %current_node
	 ; to brhkeeeeeee
	store i8* %t36, i8** %parent_node

	; sto message send: current_node.GetRight
	; edw mpainei to psaximo tou l
	%t37 = load i8*, i8** %current_node
	%t38 = bitcast i8* %t37 to i8***
	%t39 = load i8**, i8*** %t38
	 ; to className einai: Tree
	%t40 = getelementptr i8*, i8** %t39, i32 3
	%t41 = load i8*, i8** %t40
	%t42 = bitcast i8* %t41 to i8* (i8*)*
	%t43 = call i8* %t42(i8* %t37)
	; Sto Assignment Statement 
	store i8* %t43, i8** %current_node
	br label %if_end_3

	if_else_3:
	store i1 0, i1* %cont
	br label %if_end_3

	if_end_3:
	br label %if_end_2

	if_else_2:
	; stin arxh tou IfStatement
	%t44 = load i1, i1* %is_root
	br i1 %t44, label %if_then_4, label %if_else_4

	if_then_4:
	; mpainei sto && expression sti sinartisi Delete
	; sto message send: current_node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t45 = load i8*, i8** %current_node
	%t46 = bitcast i8* %t45 to i8***
	%t47 = load i8**, i8*** %t46
	 ; to className einai: Tree
	%t48 = getelementptr i8*, i8** %t47, i32 7
	%t49 = load i8*, i8** %t48
	%t50 = bitcast i8* %t49 to i1 (i8*)*
	%t51 = call i1 %t50(i8* %t45)
	%t52 = xor i1 1, %t51
	; mpainei mia edww
	br i1 %t52, label %exp_res_1, label %exp_res_0

	exp_res_0:
	br label %exp_res_3

	exp_res_1:
	; sto message send: current_node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t53 = load i8*, i8** %current_node
	%t54 = bitcast i8* %t53 to i8***
	%t55 = load i8**, i8*** %t54
	 ; to className einai: Tree
	%t56 = getelementptr i8*, i8** %t55, i32 8
	%t57 = load i8*, i8** %t56
	%t58 = bitcast i8* %t57 to i1 (i8*)*
	%t59 = call i1 %t58(i8* %t53)
	%t60 = xor i1 1, %t59
	br label %exp_res_2

	exp_res_2:
	br label %exp_res_3

	exp_res_3:
	%t61 = phi i1 [ 0, %exp_res_0 ], [ %t60, %exp_res_2 ]
	; stin arxh tou IfStatement
	br i1 %t61, label %if_then_5, label %if_else_5

	if_then_5:
	store i1 1, i1* %ntb
	br label %if_end_5

	if_else_5:
	; sto message send: this.Remove
	%t62 = bitcast i8* %this to i8***
	%t63 = load i8**, i8*** %t62
	 ; to className einai: Tree
	%t64 = getelementptr i8*, i8** %t63, i32 14
	%t65 = load i8*, i8** %t64
	%t66 = bitcast i8* %t65 to i1 (i8*,i8*,i8*)*
	;eimai sta orismata 
	%t67 = load i8*, i8** %parent_node
	;eimai sta orismata 
	%t68 = load i8*, i8** %current_node
	%t69 = call i1 %t66(i8* %this, i8* %t67, i8* %t68)
	; Sto Assignment Statement 
	store i1 %t69, i1* %ntb
	br label %if_end_5

	if_end_5:
	br label %if_end_4

	if_else_4:
	; sto message send: this.Remove
	%t70 = bitcast i8* %this to i8***
	%t71 = load i8**, i8*** %t70
	 ; to className einai: Tree
	%t72 = getelementptr i8*, i8** %t71, i32 14
	%t73 = load i8*, i8** %t72
	%t74 = bitcast i8* %t73 to i1 (i8*,i8*,i8*)*
	;eimai sta orismata 
	%t75 = load i8*, i8** %parent_node
	;eimai sta orismata 
	%t76 = load i8*, i8** %current_node
	%t77 = call i1 %t74(i8* %this, i8* %t75, i8* %t76)
	; Sto Assignment Statement 
	store i1 %t77, i1* %ntb
	br label %if_end_4

	if_end_4:
	store i1 1, i1* %found
	store i1 0, i1* %cont
	br label %if_end_2

	if_end_2:
	br label %if_end_0

	if_end_0:
	store i1 0, i1* %is_root
	br label %loop0
	loop2:
	%t78 = load i1, i1* %found

	ret i1 %t78
}

define i1 @Tree.Remove(i8* %this, i8* %.p_node, i8* %.c_node) {
	%p_node = alloca i8*
	store i8* %.p_node, i8** %p_node
	%c_node = alloca i8*
	store i8* %.c_node, i8** %c_node
	%ntb = alloca i1
	%auxkey1 = alloca i32
	%auxkey2 = alloca i32
	; sto message send: c_node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t0 = load i8*, i8** %c_node
	%t1 = bitcast i8* %t0 to i8***
	%t2 = load i8**, i8*** %t1
	 ; to className einai: Tree
	%t3 = getelementptr i8*, i8** %t2, i32 8
	%t4 = load i8*, i8** %t3
	%t5 = bitcast i8* %t4 to i1 (i8*)*
	%t6 = call i1 %t5(i8* %t0)
	; stin arxh tou IfStatement
	br i1 %t6, label %if_then_0, label %if_else_0

	if_then_0:
	; sto message send: this.RemoveLeft
	%t7 = bitcast i8* %this to i8***
	%t8 = load i8**, i8*** %t7
	 ; to className einai: Tree
	%t9 = getelementptr i8*, i8** %t8, i32 16
	%t10 = load i8*, i8** %t9
	%t11 = bitcast i8* %t10 to i1 (i8*,i8*,i8*)*
	;eimai sta orismata 
	%t12 = load i8*, i8** %p_node
	;eimai sta orismata 
	%t13 = load i8*, i8** %c_node
	%t14 = call i1 %t11(i8* %this, i8* %t12, i8* %t13)
	; Sto Assignment Statement 
	store i1 %t14, i1* %ntb
	br label %if_end_0

	if_else_0:
	; sto message send: c_node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t15 = load i8*, i8** %c_node
	%t16 = bitcast i8* %t15 to i8***
	%t17 = load i8**, i8*** %t16
	 ; to className einai: Tree
	%t18 = getelementptr i8*, i8** %t17, i32 7
	%t19 = load i8*, i8** %t18
	%t20 = bitcast i8* %t19 to i1 (i8*)*
	%t21 = call i1 %t20(i8* %t15)
	; stin arxh tou IfStatement
	br i1 %t21, label %if_then_1, label %if_else_1

	if_then_1:
	; sto message send: this.RemoveRight
	%t22 = bitcast i8* %this to i8***
	%t23 = load i8**, i8*** %t22
	 ; to className einai: Tree
	%t24 = getelementptr i8*, i8** %t23, i32 15
	%t25 = load i8*, i8** %t24
	%t26 = bitcast i8* %t25 to i1 (i8*,i8*,i8*)*
	;eimai sta orismata 
	%t27 = load i8*, i8** %p_node
	;eimai sta orismata 
	%t28 = load i8*, i8** %c_node
	%t29 = call i1 %t26(i8* %this, i8* %t27, i8* %t28)
	; Sto Assignment Statement 
	store i1 %t29, i1* %ntb
	br label %if_end_1

	if_else_1:
	; sto message send: c_node.GetKey
	; edw mpainei to psaximo tou l
	%t30 = load i8*, i8** %c_node
	%t31 = bitcast i8* %t30 to i8***
	%t32 = load i8**, i8*** %t31
	 ; to className einai: Tree
	%t33 = getelementptr i8*, i8** %t32, i32 5
	%t34 = load i8*, i8** %t33
	%t35 = bitcast i8* %t34 to i32 (i8*)*
	%t36 = call i32 %t35(i8* %t30)
	; Sto Assignment Statement 
	store i32 %t36, i32* %auxkey1
	; sto message send: p_node.GetLeft
	; edw mpainei to psaximo tou l
	%t37 = load i8*, i8** %p_node
	%t38 = bitcast i8* %t37 to i8***
	%t39 = load i8**, i8*** %t38
	 ; to className einai: Tree
	%t40 = getelementptr i8*, i8** %t39, i32 4
	%t41 = load i8*, i8** %t40
	%t42 = bitcast i8* %t41 to i8* (i8*)*
	%t43 = call i8* %t42(i8* %t37)
	; sto message send: (MessageSend Tree).GetKey
	%t44 = bitcast i8* %t43 to i8***
	%t45 = load i8**, i8*** %t44
	 ; to className einai: Tree
	%t46 = getelementptr i8*, i8** %t45, i32 5
	%t47 = load i8*, i8** %t46
	%t48 = bitcast i8* %t47 to i32 (i8*)*
	%t49 = call i32 %t48(i8* %t43)
	; Sto Assignment Statement 
	store i32 %t49, i32* %auxkey2
	; sto message send: this.Compare
	%t50 = bitcast i8* %this to i8***
	%t51 = load i8**, i8*** %t50
	 ; to className einai: Tree
	%t52 = getelementptr i8*, i8** %t51, i32 11
	%t53 = load i8*, i8** %t52
	%t54 = bitcast i8* %t53 to i1 (i8*,i32,i32)*
	;eimai sta orismata 
	%t55 = load i32, i32* %auxkey1
	;eimai sta orismata 
	%t56 = load i32, i32* %auxkey2
	%t57 = call i1 %t54(i8* %this, i32 %t55, i32 %t56)
	; stin arxh tou IfStatement
	br i1 %t57, label %if_then_2, label %if_else_2

	if_then_2:
	; sto message send: p_node.SetLeft
	; edw mpainei to psaximo tou l
	%t58 = load i8*, i8** %p_node
	%t59 = bitcast i8* %t58 to i8***
	%t60 = load i8**, i8*** %t59
	 ; to className einai: Tree
	%t61 = getelementptr i8*, i8** %t60, i32 2
	%t62 = load i8*, i8** %t61
	%t63 = bitcast i8* %t62 to i1 (i8*,i8*)*
	%t64 = getelementptr i8, i8* %this, i32 30
	%t65 = bitcast i8* %t64 to i8**
	%t66 = load i8*, i8** %t65
	%t67 = call i1 %t63(i8* %t58, i8* %t66)
	; Sto Assignment Statement 
	store i1 %t67, i1* %ntb
	; sto message send: p_node.SetHas_Left
	; edw mpainei to psaximo tou l
	%t68 = load i8*, i8** %p_node
	%t69 = bitcast i8* %t68 to i8***
	%t70 = load i8**, i8*** %t69
	 ; to className einai: Tree
	%t71 = getelementptr i8*, i8** %t70, i32 9
	%t72 = load i8*, i8** %t71
	%t73 = bitcast i8* %t72 to i1 (i8*,i1)*
	%t74 = call i1 %t73(i8* %t68, i1 0)
	; Sto Assignment Statement 
	store i1 %t74, i1* %ntb
	br label %if_end_2

	if_else_2:
	; sto message send: p_node.SetRight
	; edw mpainei to psaximo tou l
	%t75 = load i8*, i8** %p_node
	%t76 = bitcast i8* %t75 to i8***
	%t77 = load i8**, i8*** %t76
	 ; to className einai: Tree
	%t78 = getelementptr i8*, i8** %t77, i32 1
	%t79 = load i8*, i8** %t78
	%t80 = bitcast i8* %t79 to i1 (i8*,i8*)*
	%t81 = getelementptr i8, i8* %this, i32 30
	%t82 = bitcast i8* %t81 to i8**
	%t83 = load i8*, i8** %t82
	%t84 = call i1 %t80(i8* %t75, i8* %t83)
	; Sto Assignment Statement 
	store i1 %t84, i1* %ntb
	; sto message send: p_node.SetHas_Right
	; edw mpainei to psaximo tou l
	%t85 = load i8*, i8** %p_node
	%t86 = bitcast i8* %t85 to i8***
	%t87 = load i8**, i8*** %t86
	 ; to className einai: Tree
	%t88 = getelementptr i8*, i8** %t87, i32 10
	%t89 = load i8*, i8** %t88
	%t90 = bitcast i8* %t89 to i1 (i8*,i1)*
	%t91 = call i1 %t90(i8* %t85, i1 0)
	; Sto Assignment Statement 
	store i1 %t91, i1* %ntb
	br label %if_end_2

	if_end_2:
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_end_0:

	ret i1 1
}

define i1 @Tree.RemoveRight(i8* %this, i8* %.p_node, i8* %.c_node) {
	%p_node = alloca i8*
	store i8* %.p_node, i8** %p_node
	%c_node = alloca i8*
	store i8* %.c_node, i8** %c_node
	%ntb = alloca i1
	br label %loop0

	loop0:
	; sto message send: c_node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t0 = load i8*, i8** %c_node
	%t1 = bitcast i8* %t0 to i8***
	%t2 = load i8**, i8*** %t1
	 ; to className einai: Tree
	%t3 = getelementptr i8*, i8** %t2, i32 7
	%t4 = load i8*, i8** %t3
	%t5 = bitcast i8* %t4 to i1 (i8*)*
	%t6 = call i1 %t5(i8* %t0)
	br i1 %t6, label %loop1, label %loop2

	loop1:
	; sto message send: c_node.SetKey
	; edw mpainei to psaximo tou l
	%t7 = load i8*, i8** %c_node
	%t8 = bitcast i8* %t7 to i8***
	%t9 = load i8**, i8*** %t8
	 ; to className einai: Tree
	%t10 = getelementptr i8*, i8** %t9, i32 6
	%t11 = load i8*, i8** %t10
	%t12 = bitcast i8* %t11 to i1 (i8*,i32)*
	; sto message send: c_node.GetRight
	; edw mpainei to psaximo tou l
	%t13 = load i8*, i8** %c_node
	%t14 = bitcast i8* %t13 to i8***
	%t15 = load i8**, i8*** %t14
	 ; to className einai: Tree
	%t16 = getelementptr i8*, i8** %t15, i32 3
	%t17 = load i8*, i8** %t16
	%t18 = bitcast i8* %t17 to i8* (i8*)*
	%t19 = call i8* %t18(i8* %t13)
	; sto message send: (MessageSend Tree).GetKey
	%t20 = bitcast i8* %t19 to i8***
	%t21 = load i8**, i8*** %t20
	 ; to className einai: Tree
	%t22 = getelementptr i8*, i8** %t21, i32 5
	%t23 = load i8*, i8** %t22
	%t24 = bitcast i8* %t23 to i32 (i8*)*
	%t25 = call i32 %t24(i8* %t19)
	%t26 = call i1 %t12(i8* %t7, i32 %t25)
	; Sto Assignment Statement 
	store i1 %t26, i1* %ntb
	%t27 = load i8*, i8** %c_node
	 ; to brhkeeeeeee
	store i8* %t27, i8** %p_node

	; sto message send: c_node.GetRight
	; edw mpainei to psaximo tou l
	%t28 = load i8*, i8** %c_node
	%t29 = bitcast i8* %t28 to i8***
	%t30 = load i8**, i8*** %t29
	 ; to className einai: Tree
	%t31 = getelementptr i8*, i8** %t30, i32 3
	%t32 = load i8*, i8** %t31
	%t33 = bitcast i8* %t32 to i8* (i8*)*
	%t34 = call i8* %t33(i8* %t28)
	; Sto Assignment Statement 
	store i8* %t34, i8** %c_node
	br label %loop0
	loop2:
	; sto message send: p_node.SetRight
	; edw mpainei to psaximo tou l
	%t35 = load i8*, i8** %p_node
	%t36 = bitcast i8* %t35 to i8***
	%t37 = load i8**, i8*** %t36
	 ; to className einai: Tree
	%t38 = getelementptr i8*, i8** %t37, i32 1
	%t39 = load i8*, i8** %t38
	%t40 = bitcast i8* %t39 to i1 (i8*,i8*)*
	%t41 = getelementptr i8, i8* %this, i32 30
	%t42 = bitcast i8* %t41 to i8**
	%t43 = load i8*, i8** %t42
	%t44 = call i1 %t40(i8* %t35, i8* %t43)
	; Sto Assignment Statement 
	store i1 %t44, i1* %ntb
	; sto message send: p_node.SetHas_Right
	; edw mpainei to psaximo tou l
	%t45 = load i8*, i8** %p_node
	%t46 = bitcast i8* %t45 to i8***
	%t47 = load i8**, i8*** %t46
	 ; to className einai: Tree
	%t48 = getelementptr i8*, i8** %t47, i32 10
	%t49 = load i8*, i8** %t48
	%t50 = bitcast i8* %t49 to i1 (i8*,i1)*
	%t51 = call i1 %t50(i8* %t45, i1 0)
	; Sto Assignment Statement 
	store i1 %t51, i1* %ntb

	ret i1 1
}

define i1 @Tree.RemoveLeft(i8* %this, i8* %.p_node, i8* %.c_node) {
	%p_node = alloca i8*
	store i8* %.p_node, i8** %p_node
	%c_node = alloca i8*
	store i8* %.c_node, i8** %c_node
	%ntb = alloca i1
	br label %loop0

	loop0:
	; sto message send: c_node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t0 = load i8*, i8** %c_node
	%t1 = bitcast i8* %t0 to i8***
	%t2 = load i8**, i8*** %t1
	 ; to className einai: Tree
	%t3 = getelementptr i8*, i8** %t2, i32 8
	%t4 = load i8*, i8** %t3
	%t5 = bitcast i8* %t4 to i1 (i8*)*
	%t6 = call i1 %t5(i8* %t0)
	br i1 %t6, label %loop1, label %loop2

	loop1:
	; sto message send: c_node.SetKey
	; edw mpainei to psaximo tou l
	%t7 = load i8*, i8** %c_node
	%t8 = bitcast i8* %t7 to i8***
	%t9 = load i8**, i8*** %t8
	 ; to className einai: Tree
	%t10 = getelementptr i8*, i8** %t9, i32 6
	%t11 = load i8*, i8** %t10
	%t12 = bitcast i8* %t11 to i1 (i8*,i32)*
	; sto message send: c_node.GetLeft
	; edw mpainei to psaximo tou l
	%t13 = load i8*, i8** %c_node
	%t14 = bitcast i8* %t13 to i8***
	%t15 = load i8**, i8*** %t14
	 ; to className einai: Tree
	%t16 = getelementptr i8*, i8** %t15, i32 4
	%t17 = load i8*, i8** %t16
	%t18 = bitcast i8* %t17 to i8* (i8*)*
	%t19 = call i8* %t18(i8* %t13)
	; sto message send: (MessageSend Tree).GetKey
	%t20 = bitcast i8* %t19 to i8***
	%t21 = load i8**, i8*** %t20
	 ; to className einai: Tree
	%t22 = getelementptr i8*, i8** %t21, i32 5
	%t23 = load i8*, i8** %t22
	%t24 = bitcast i8* %t23 to i32 (i8*)*
	%t25 = call i32 %t24(i8* %t19)
	%t26 = call i1 %t12(i8* %t7, i32 %t25)
	; Sto Assignment Statement 
	store i1 %t26, i1* %ntb
	%t27 = load i8*, i8** %c_node
	 ; to brhkeeeeeee
	store i8* %t27, i8** %p_node

	; sto message send: c_node.GetLeft
	; edw mpainei to psaximo tou l
	%t28 = load i8*, i8** %c_node
	%t29 = bitcast i8* %t28 to i8***
	%t30 = load i8**, i8*** %t29
	 ; to className einai: Tree
	%t31 = getelementptr i8*, i8** %t30, i32 4
	%t32 = load i8*, i8** %t31
	%t33 = bitcast i8* %t32 to i8* (i8*)*
	%t34 = call i8* %t33(i8* %t28)
	; Sto Assignment Statement 
	store i8* %t34, i8** %c_node
	br label %loop0
	loop2:
	; sto message send: p_node.SetLeft
	; edw mpainei to psaximo tou l
	%t35 = load i8*, i8** %p_node
	%t36 = bitcast i8* %t35 to i8***
	%t37 = load i8**, i8*** %t36
	 ; to className einai: Tree
	%t38 = getelementptr i8*, i8** %t37, i32 2
	%t39 = load i8*, i8** %t38
	%t40 = bitcast i8* %t39 to i1 (i8*,i8*)*
	%t41 = getelementptr i8, i8* %this, i32 30
	%t42 = bitcast i8* %t41 to i8**
	%t43 = load i8*, i8** %t42
	%t44 = call i1 %t40(i8* %t35, i8* %t43)
	; Sto Assignment Statement 
	store i1 %t44, i1* %ntb
	; sto message send: p_node.SetHas_Left
	; edw mpainei to psaximo tou l
	%t45 = load i8*, i8** %p_node
	%t46 = bitcast i8* %t45 to i8***
	%t47 = load i8**, i8*** %t46
	 ; to className einai: Tree
	%t48 = getelementptr i8*, i8** %t47, i32 9
	%t49 = load i8*, i8** %t48
	%t50 = bitcast i8* %t49 to i1 (i8*,i1)*
	%t51 = call i1 %t50(i8* %t45, i1 0)
	; Sto Assignment Statement 
	store i1 %t51, i1* %ntb

	ret i1 1
}

define i32 @Tree.Search(i8* %this, i32 %.v_key) {
	%v_key = alloca i32
	store i32 %.v_key, i32* %v_key
	%cont = alloca i1
	%ifound = alloca i32
	%current_node = alloca i8*
	%key_aux = alloca i32
	store i8* %this, i8** %current_node
	store i1 1, i1* %cont
	store i32 0, i32* %ifound
	br label %loop0

	loop0:
	%t0 = load i1, i1* %cont
	br i1 %t0, label %loop1, label %loop2

	loop1:
	; sto message send: current_node.GetKey
	; edw mpainei to psaximo tou l
	%t1 = load i8*, i8** %current_node
	%t2 = bitcast i8* %t1 to i8***
	%t3 = load i8**, i8*** %t2
	 ; to className einai: Tree
	%t4 = getelementptr i8*, i8** %t3, i32 5
	%t5 = load i8*, i8** %t4
	%t6 = bitcast i8* %t5 to i32 (i8*)*
	%t7 = call i32 %t6(i8* %t1)
	; Sto Assignment Statement 
	store i32 %t7, i32* %key_aux

	; CompareExpression
	%t8 = load i32, i32* %v_key
	%t9 = load i32, i32* %key_aux
	%t10 = icmp slt i32 %t8, %t9
	; stin arxh tou IfStatement
	br i1 %t10, label %if_then_0, label %if_else_0

	if_then_0:
	; sto message send: current_node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t11 = load i8*, i8** %current_node
	%t12 = bitcast i8* %t11 to i8***
	%t13 = load i8**, i8*** %t12
	 ; to className einai: Tree
	%t14 = getelementptr i8*, i8** %t13, i32 8
	%t15 = load i8*, i8** %t14
	%t16 = bitcast i8* %t15 to i1 (i8*)*
	%t17 = call i1 %t16(i8* %t11)
	; stin arxh tou IfStatement
	br i1 %t17, label %if_then_1, label %if_else_1

	if_then_1:
	; sto message send: current_node.GetLeft
	; edw mpainei to psaximo tou l
	%t18 = load i8*, i8** %current_node
	%t19 = bitcast i8* %t18 to i8***
	%t20 = load i8**, i8*** %t19
	 ; to className einai: Tree
	%t21 = getelementptr i8*, i8** %t20, i32 4
	%t22 = load i8*, i8** %t21
	%t23 = bitcast i8* %t22 to i8* (i8*)*
	%t24 = call i8* %t23(i8* %t18)
	; Sto Assignment Statement 
	store i8* %t24, i8** %current_node
	br label %if_end_1

	if_else_1:
	store i1 0, i1* %cont
	br label %if_end_1

	if_end_1:
	br label %if_end_0

	if_else_0:

	; CompareExpression
	%t25 = load i32, i32* %key_aux
	%t26 = load i32, i32* %v_key
	%t27 = icmp slt i32 %t25, %t26
	; stin arxh tou IfStatement
	br i1 %t27, label %if_then_2, label %if_else_2

	if_then_2:
	; sto message send: current_node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t28 = load i8*, i8** %current_node
	%t29 = bitcast i8* %t28 to i8***
	%t30 = load i8**, i8*** %t29
	 ; to className einai: Tree
	%t31 = getelementptr i8*, i8** %t30, i32 7
	%t32 = load i8*, i8** %t31
	%t33 = bitcast i8* %t32 to i1 (i8*)*
	%t34 = call i1 %t33(i8* %t28)
	; stin arxh tou IfStatement
	br i1 %t34, label %if_then_3, label %if_else_3

	if_then_3:
	; sto message send: current_node.GetRight
	; edw mpainei to psaximo tou l
	%t35 = load i8*, i8** %current_node
	%t36 = bitcast i8* %t35 to i8***
	%t37 = load i8**, i8*** %t36
	 ; to className einai: Tree
	%t38 = getelementptr i8*, i8** %t37, i32 3
	%t39 = load i8*, i8** %t38
	%t40 = bitcast i8* %t39 to i8* (i8*)*
	%t41 = call i8* %t40(i8* %t35)
	; Sto Assignment Statement 
	store i8* %t41, i8** %current_node
	br label %if_end_3

	if_else_3:
	store i1 0, i1* %cont
	br label %if_end_3

	if_end_3:
	br label %if_end_2

	if_else_2:
	store i32 1, i32* %ifound
	store i1 0, i1* %cont
	br label %if_end_2

	if_end_2:
	br label %if_end_0

	if_end_0:
	br label %loop0
	loop2:
	%t42 = load i32, i32* %ifound

	ret i32 %t42
}

define i1 @Tree.Print(i8* %this) {
	%current_node = alloca i8*
	%ntb = alloca i1
	store i8* %this, i8** %current_node
	; sto message send: this.RecPrint
	%t0 = bitcast i8* %this to i8***
	%t1 = load i8**, i8*** %t0
	 ; to className einai: Tree
	%t2 = getelementptr i8*, i8** %t1, i32 19
	%t3 = load i8*, i8** %t2
	%t4 = bitcast i8* %t3 to i1 (i8*,i8*)*
	;eimai sta orismata 
	%t5 = load i8*, i8** %current_node
	%t6 = call i1 %t4(i8* %this, i8* %t5)
	; Sto Assignment Statement 
	store i1 %t6, i1* %ntb

	ret i1 1
}

define i1 @Tree.RecPrint(i8* %this, i8* %.node) {
	%node = alloca i8*
	store i8* %.node, i8** %node
	%ntb = alloca i1
	; sto message send: node.GetHas_Left
	; edw mpainei to psaximo tou l
	%t0 = load i8*, i8** %node
	%t1 = bitcast i8* %t0 to i8***
	%t2 = load i8**, i8*** %t1
	 ; to className einai: Tree
	%t3 = getelementptr i8*, i8** %t2, i32 8
	%t4 = load i8*, i8** %t3
	%t5 = bitcast i8* %t4 to i1 (i8*)*
	%t6 = call i1 %t5(i8* %t0)
	; stin arxh tou IfStatement
	br i1 %t6, label %if_then_0, label %if_else_0

	if_then_0:
	; sto message send: this.RecPrint
	%t7 = bitcast i8* %this to i8***
	%t8 = load i8**, i8*** %t7
	 ; to className einai: Tree
	%t9 = getelementptr i8*, i8** %t8, i32 19
	%t10 = load i8*, i8** %t9
	%t11 = bitcast i8* %t10 to i1 (i8*,i8*)*
	; sto message send: node.GetLeft
	; edw mpainei to psaximo tou l
	%t12 = load i8*, i8** %node
	%t13 = bitcast i8* %t12 to i8***
	%t14 = load i8**, i8*** %t13
	 ; to className einai: Tree
	%t15 = getelementptr i8*, i8** %t14, i32 4
	%t16 = load i8*, i8** %t15
	%t17 = bitcast i8* %t16 to i8* (i8*)*
	%t18 = call i8* %t17(i8* %t12)
	%t19 = call i1 %t11(i8* %this, i8* %t18)
	; Sto Assignment Statement 
	store i1 %t19, i1* %ntb
	br label %if_end_0

	if_else_0:
	store i1 1, i1* %ntb
	br label %if_end_0

	if_end_0:
	; sto message send: node.GetKey
	; edw mpainei to psaximo tou l
	%t20 = load i8*, i8** %node
	%t21 = bitcast i8* %t20 to i8***
	%t22 = load i8**, i8*** %t21
	 ; to className einai: Tree
	%t23 = getelementptr i8*, i8** %t22, i32 5
	%t24 = load i8*, i8** %t23
	%t25 = bitcast i8* %t24 to i32 (i8*)*
	%t26 = call i32 %t25(i8* %t20)
	call void (i32) @print_int(i32 %t26)
	; sto message send: node.GetHas_Right
	; edw mpainei to psaximo tou l
	%t27 = load i8*, i8** %node
	%t28 = bitcast i8* %t27 to i8***
	%t29 = load i8**, i8*** %t28
	 ; to className einai: Tree
	%t30 = getelementptr i8*, i8** %t29, i32 7
	%t31 = load i8*, i8** %t30
	%t32 = bitcast i8* %t31 to i1 (i8*)*
	%t33 = call i1 %t32(i8* %t27)
	; stin arxh tou IfStatement
	br i1 %t33, label %if_then_1, label %if_else_1

	if_then_1:
	; sto message send: this.RecPrint
	%t34 = bitcast i8* %this to i8***
	%t35 = load i8**, i8*** %t34
	 ; to className einai: Tree
	%t36 = getelementptr i8*, i8** %t35, i32 19
	%t37 = load i8*, i8** %t36
	%t38 = bitcast i8* %t37 to i1 (i8*,i8*)*
	; sto message send: node.GetRight
	; edw mpainei to psaximo tou l
	%t39 = load i8*, i8** %node
	%t40 = bitcast i8* %t39 to i8***
	%t41 = load i8**, i8*** %t40
	 ; to className einai: Tree
	%t42 = getelementptr i8*, i8** %t41, i32 3
	%t43 = load i8*, i8** %t42
	%t44 = bitcast i8* %t43 to i8* (i8*)*
	%t45 = call i8* %t44(i8* %t39)
	%t46 = call i1 %t38(i8* %this, i8* %t45)
	; Sto Assignment Statement 
	store i1 %t46, i1* %ntb
	br label %if_end_1

	if_else_1:
	store i1 1, i1* %ntb
	br label %if_end_1

	if_end_1:

	ret i1 1
}

