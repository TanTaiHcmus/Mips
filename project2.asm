.data
	m_day: .space 3
	m_month: .space 3
	m_year: .space 5
	m_luachon: .space 2
	DayOfMonth: .word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	In_day: .asciiz "\nNhap ngay DAY: "
	In_month: .asciiz "\nNhap thang MONTH: "
	In_year: .asciiz "\nNhap nam YEAR: "
	In_Thaotac: .asciiz "\n----------Ban hay chon 1 trong cac thao tac duoi day-----------"
	In_Thaotac1: .asciiz "\n1. Xuat chuoi Time theo dinh dang DD/MM/YYYY"
	In_Thaotac2: .asciiz "\n2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n\tA. MM/DD/YYYY\n\tB. Month DD, YYYY\n\tC. DD Month, YYYY"
	In_Thaotac3: .asciiz "\n3. Cho biet ngay vua nhap la ngay thu may trong tuan:"
	In_Thaotac4: .asciiz "\n4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong"
	In_Thaotac5: .asciiz "\n5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2"
	In_Thaotac6: .asciiz "\n6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time"
	In_Thaotac7: .asciiz "\n7. Exit."
	In_Vach: .asciiz "\n------------------------------------------------------------------"
	In_LuaChon: .asciiz "\n. Lua chon: "
	In_KetQua: .asciiz "\n. Ket qua: "
	In_Error: .asciiz "\nDu lieu nhap vao sai, xin kiem tra lai!"
	Time_Mau: .space 11
	Time_Mau1: .space 11
	In_ChonType: .asciiz "\n. Chon type cho TIME(A or B or C): "
	DinhDangTime: .space 21
	Jan: .asciiz "January"
	Feb: .asciiz "February"
	Mar: .asciiz "March"
	Apr: .asciiz "April"
	May: .asciiz "May"
	Jun: .asciiz "June"
	Jul: .asciiz "July"
	Aug: .asciiz "August"
	Sep: .asciiz "September"
	Oct: .asciiz "October"
	Nov: .asciiz "November"
	Dec: .asciiz "December"
	Sun: .asciiz "Sun"
	Mon: .asciiz "Mon"
	Tues: .asciiz "Tues"
	Wed: .asciiz "Wed"
	Thurs: .asciiz "Thurs"
	Fri: .asciiz "Fri"
	Sat: .asciiz "Sat"
	In_Nhuan: .asciiz "La nam nhuan"
	In_KhongNhuan: .asciiz "Khong phai la nam nhuan"
	In_NhapTime2: .asciiz "\n. Nhap TIME_2: "
	In_nam: .asciiz " nam"
	In_space: .asciiz " "
	
.text
.globl main

main:
	do:
		la $a0, Time_Mau
		addi $sp, $sp, -4
		sw $a0, ($sp)
		jal InputTime
		sw $v0, ($sp)
		jal PrintMenu
		jal Process
		addi $sp, $sp, 4
		beq $v0, -1, exit
		j do
	exit:
		addi $v0, $0, 10
		syscall

Process:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	la $t0, m_luachon
	lb $t0, ($t0)
	addi $t0, $t0, -48
	beq $t0, 1, Thaotac1
	beq $t0, 2, Thaotac2
	beq $t0, 3, Thaotac3
	beq $t0, 4, Thaotac4
	beq $t0, 5, Thaotac5 
	beq $t0, 6, Thaotac6
	beq $t0, 7, Thaotac7
	j Exit_Process

Thaotac1:
	la $a0, In_KetQua
	addi $v0, $0, 4
	syscall
	lw $a0, 4($sp)
	addi $v0, $0, 4
	syscall
	j Exit_Process

Thaotac2:
	While:
		la $a0, In_ChonType
		addi $v0, $0, 4
		syscall
		addi $v0, $0, 12
		syscall
		slti $t0, $v0, 65
		beq $t0, 1, While
		slti $t0, $v0, 68
		beq $t0, 0, While
		j EndWhile
	EndWhile:
		add $a1, $0, $v0
		la $a0, In_KetQua
		addi $v0, $0, 4
		syscall
		lw $a0, 4($sp)
		jal Convert
		add $a0, $0, $v0
		addi $v0, $0, 4
		syscall
		j Exit_Process

Thaotac3:
	la $a0, In_KetQua
	addi $v0, $0, 4
	syscall
	lw $a0, 4($sp)
	jal Weekday
	add $a0, $0, $v0
	addi $v0, $0, 4
	syscall
	j Exit_Process

Thaotac4:
	la $a0, In_KetQua
	addi $v0, $0, 4
	syscall
	lw $a0, 4($sp)
	jal LeapYear
	beq $v0, 0, KhongNhuan
	beq $v0, 1, Nhuan

Thaotac5:
	la $a0, In_NhapTime2
	addi $v0, $0, 4
	syscall
	la $a0, Time_Mau1
	addi $sp, $sp, -4
	sw $a0, ($sp)
	jal InputTime
	add $a1, $0, $v0
	addi $sp, $sp, 4
	la $a0, In_KetQua
	addi $v0, $0, 4
	syscall
	lw $a0, 4($sp)
	jal GetTime
	add $a0, $0, $v0
	addi $v0, $0, 1
	syscall
	la $a0, In_nam
	addi $v0, $0, 4
	syscall
	j Exit_Process

Thaotac6:
	la $a0, In_KetQua
	addi $v0, $0, 4
	syscall
	lw $a0, 4($sp)
	jal LeapYear
	add $t0, $0, $v0
	jal Year
	add $a1, $0, $v0
	addi $t2, $0, 0
	beq $t0, 1, Case1
	addi $t0, $0, 4
	div $a1, $t0
	mfhi $t1
	beq $t1, 0, Case1
	beq $t1, 1, Case2
	j Case3

Thaotac7:
	addi $v0, $0, -1
	j Exit_Process

Case1:
	addi $a1, $a1, -4
	jal KtraNhuan
	addi $a1, $a1, 8
	jal KtraNhuan
	beq $t2, 2, Exit_Process
	addi $v0, $0, 1
	addi $a0, $a1, 4
	syscall
	j Exit_Process

Case2:
	addi $a1, $a1, -1
	jal KtraNhuan
	addi $a1, $a1, 4
	jal KtraNhuan
	beq $t2, 2, Exit_Process
	addi $v0, $0, 1
	addi $a0, $a1, -8
	syscall
	j Exit_Process

Case3:
	sub $a1, $a1, $t1
	jal KtraNhuan
	addi $a1, $a1, 4
	jal KtraNhuan
	beq $t2, 2, Exit_Process
	addi $v0, $0, 1
	addi $a0, $a1, 4
	syscall
	j Exit_Process

KtraNhuan:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	addi $t0, $0, 400
	div $a1, $t0
	mfhi $t1
	beq $t1, 0, InNhuan
	addi $t0, $0, 100
	div $a1, $t0
	mfhi $t1
	bne $t1, 0, InNhuan
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	

InNhuan:
	addi $v0, $0, 1
	add $a0, $0, $a1
	syscall
	la $a0, In_space
	addi $v0, $0, 4
	syscall
	addi $t2, $t2, 1
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	

GetTime:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal Day
	add $s0, $0, $v0
	jal Month
	add $s1, $0, $v0
	jal Year
	add $s2, $0, $v0
	add $a0, $0, $a1
	jal Day
	add $s3, $0, $v0
	jal Month
	add $s4, $0, $v0
	jal Year
	add $s5, $0, $v0
	slt $t3, $s2, $s5
	beq $t3, 0, TH1
	beq $t3, 1, TH2

TH1:
	sub $v0, $s2, $s5
	beq $v0, 0, Exit_GetTime
	slt $t3, $s1, $s4
	beq $t3, 1, Sub1
	slt $t3, $s4, $s1
	beq $t3, 1, Exit_GetTime
	slt $t3, $s0, $s3
	beq $t3, 1, Sub1
	j Exit_GetTime

TH2:
	sub $v0, $s5, $s2
	beq $v0, 0, Exit_GetTime
	slt $t3, $s4, $s1
	beq $t3, 1, Sub1
	slt $t3, $s1, $s4
	beq $t3, 1, Exit_GetTime
	slt $t3, $s3, $s0
	beq $t3, 1, Sub1
	j Exit_GetTime

Sub1:
	addi $v0, $v0, -1
	j Exit_GetTime

Exit_GetTime:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

KhongNhuan:
	la $a0, In_KhongNhuan
	addi $v0, $0, 4
	syscall
	j Exit_Process

Nhuan:
	la $a0, In_Nhuan
	addi $v0, $0, 4
	syscall
	j Exit_Process

Weekday:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal Day
	add $s0, $0, $v0
	jal Month
	add $s1, $0, $v0
	jal Year
	add $s2, $0, $v0
	la $s3, DayOfMonth
	SumDay:
		beq $s1, 1, End_SumDay
		addi $s1, $s1, -1
		lw $s4, ($s3)
		addi, $s3, $s3, 4
		add $s0, $s0, $s4
		j SumDay
	End_SumDay:
		addi $s2, $s2, -1
		add $s0, $s0, $s2
		addi $t1, $0, 4
		addi $t2, $0, 100
		addi $t3, $0, 400
		addi $t4, $0, 7
		div $s2, $t1
		mflo $t1
		add $s0, $s0, $t1
		div $s2, $t2
		mflo $t2
		sub $s0, $s0, $t2
		div $s2, $t3
		mflo $t3
		add $s0, $s0, $t3
		div $s0, $t4
		mfhi $t4
		beq $t4, 0, Sunday
		beq $t4, 1, Monday
		beq $t4, 2, Tuesday
		beq $t4, 3, Wednesday
		beq $t4, 4, Thursday
		beq $t4, 5, Friday
		beq $t4, 6, Saturday

Sunday:
	la $v0, Sun
	j Exit_Weekday

Monday:
	la $v0, Mon
	j Exit_Weekday

Tuesday:
	la $v0, Tues
	j Exit_Weekday

Wednesday:
	la $v0, Wed
	j Exit_Weekday

Thursday:
	la $v0, Thurs
	j Exit_Weekday

Friday:
	la $v0, Fri
	j Exit_Weekday

Saturday:
	la $v0, Sat
	j Exit_Weekday

Exit_Weekday:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

Convert:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	beq $a1, 65, DinhDangA
	la $a2, DinhDangTime
	la $t0, ($a2)
	addi $t1, $0, 0
	addi $t2, $0, 32
	WhileEmpty:
		beq $t1, 20, EndWhileEmpty
		sb $t2, ($t0)
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		j WhileEmpty
	EndWhileEmpty:
		jal Month
		add $a3, $0, $v0
		jal GetMonth
		add $a3, $0, $v0
		beq $a1, 66, DinhDangB
		beq $a1, 67, DinhDangC

GetMonth:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	beq $a3, 1, jan
	beq $a3, 2, feb
	beq $a3, 3, mar
	beq $a3, 4, apr
	beq $a3, 5, may
	beq $a3, 6, jun
	beq $a3, 7, jul
	beq $a3, 8, aug
	beq $a3, 9, sep
	beq $a3, 10, oct
	beq $a3, 11, nov
	beq $a3, 12, dec

jan:
	la $v0, Jan
	j Exit_GetMonth

feb:
	la $v0, Feb
	j Exit_GetMonth

mar:
	la $v0, Mar
	j Exit_GetMonth

apr:
	la $v0, Apr
	j Exit_GetMonth

may:
	la $v0, May
	j Exit_GetMonth

jun:
	la $v0, Jun
	j Exit_GetMonth

jul:
	la $v0, Jul
	j Exit_GetMonth

aug:
	la $v0, Aug
	j Exit_GetMonth

sep:
	la $v0, Sep
	j Exit_GetMonth

oct:
	la $v0, Oct
	j Exit_GetMonth

nov:
	la $v0, Nov
	j Exit_GetMonth

dec:
	la $v0, Dec
	j Exit_GetMonth

Exit_GetMonth:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

DinhDangA:
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	lb $t2, 3($a0)
	lb $t3, 4($a0)
	sb $t0, 3($a0)
	sb $t1, 4($a0)
	sb $t2, 0($a0)
	sb $t3, 1($a0)
	j Exit_Convert
	
DinhDangB:
	la $s0, ($a2)
	B:
		lb $t0, ($a3)
		beq $t0, $zero, EndB
		sb $t0, ($s0)
		addi $a3, $a3, 1
		addi $s0, $s0, 1
		j B
	EndB:
		addi $t0, $0, 32
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 0($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 1($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		addi $t0, $0, 44
		sb $t0, ($s0)
		addi $s0, $s0, 1
		addi $t0, $0, 32
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 6($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 7($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 8($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 9($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		add $a0, $0, $a2
		j Exit_Convert
	
DinhDangC:
	la $s0, ($a2)
	lb $t0, 0($a0)
	sb $t0, ($s0)
	addi $s0, $s0, 1
	lb $t0, 1($a0)
	sb $t0, ($s0)
	addi $s0, $s0, 1
	addi $t0, $0, 32
	sb $t0, ($s0)
	addi $s0, $s0, 1
	C:
		lb $t0, ($a3)
		beq $t0, $zero, EndC
		sb $t0, ($s0)
		addi $a3, $a3, 1
		addi $s0, $s0, 1
		j C
	EndC:
		addi $t0, $0, 44
		sb $t0, ($s0)
		addi $s0, $s0, 1
		addi $t0, $0, 32
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 6($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 7($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 8($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		lb $t0, 9($a0)
		sb $t0, ($s0)
		addi $s0, $s0, 1
		add $a0, $0, $a2
		j Exit_Convert

Exit_Convert:
	add $v0, $0, $a0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

PrintMenu:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	addi $v0, $0, 4
	la $a0, In_Thaotac
	syscall
	
	la $a0, In_Thaotac1
	syscall

	la $a0, In_Thaotac2
	syscall

	la $a0, In_Thaotac3
	syscall

	la $a0, In_Thaotac4
	syscall

	la $a0, In_Thaotac5
	syscall

	la $a0, In_Thaotac6
	syscall

	la $a0, In_Thaotac7
	syscall

	la $a0, In_Vach
	syscall
	
	la $a0, In_LuaChon
	syscall

	addi $v0, $0, 8
	addi $a1, $0, 2
	la $a0, m_luachon
	syscall

	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

InputTime:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	Input:
		la $a0, In_day
		addi $v0, $0, 4
		syscall
	
		la $a0, m_day
		addi $a1, $0, 3
		addi $v0, $0, 8
		syscall

		la $a0, In_month
		addi $v0, $0, 4
		syscall

		la $a0, m_month
		addi $a1, $0, 3
		addi $v0, $0, 8
		syscall

		la $a0, In_year
		addi $v0, $0, 4
		syscall

		la $a0, m_year
		addi $a1, $0, 5
		addi $v0, $0, 8
		syscall

		la $a0, m_day
		la $a1, m_month
		la $a2, m_year
		lw $a3, 4($sp)

		jal Date
		add $a0, $0, $v0

		jal KiemTraHopLe
		
		bne $v0, $zero, OK
		addi $v0, $0, 4
		la $a0, In_Error
		syscall
		j Input
	OK:
		add $v0, $0, $a0
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra

Date:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	addi $t1, $0, 47
	lb $t0, 3($a2)
	sb $t0, 9($a3)
	lb $t0, 2($a2)
	sb $t0, 8($a3)
	lb $t0, 1($a2)
	sb $t0, 7($a3)
	lb $t0, 0($a2)
	sb $t0, 6($a3)
	sb $t1, 5($a3)
	lb $t0, 1($a1)
	sb $t0, 4($a3)
	lb $t0, 0($a1)
	sb $t0, 3($a3)
	sb $t1, 2($a3)
	lb $t0, 1($a0)
	sb $t0, 1($a3)
	lb $t0, 0($a0)
	sb $t0, 0($a3)
	add $v0, $0, $a3
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

KiemTraHopLe:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal Day
	add $s0, $0, $v0
	beq $s0, $zero, Error
	jal Month
	add $s1, $0, $v0
	beq $s1, $zero, Error
	slti $t0, $s1, 13
	beq $t0, $zero, Error
	jal Year
	add $s2, $0, $v0
	beq $s2, $zero, Error
	slti $t0, $s2, 1900
	beq $t0, 1, Error
	la $s3, DayOfMonth
	addi $s4, $s1, -1
	sll $s4, $s4, 2
	add $s3, $s3, $s4
	lw $s3, ($s3)
	addi $t0, $0, 2
	beq $s1, $t0, CheckLeapYear
	j CheckDayOfMonth

Day:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	addi $t2, $0, 10
	lb $t0, 1($a0)
	addi $t0, $t0, -48
	slt $t3, $t0, $t2
	beq $t3, $zero, Error
	slt $t3, $t0, $zero
	bne $t3, $zero, Error
	lb $t1, 0($a0)
	addi $t1, $t1, -48
	slt $t3, $t1, $t2
	beq $t3, $zero, Error
	slt $t3, $t1, $zero
	bne $t3, $zero, Error
	mult $t1, $t2
	mflo $t1
	add $t1, $t1, $t0
	add $v0, $0, $t1
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	

Month:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	addi $t2, $0, 10
	lb $t0, 4($a0)
	addi $t0, $t0, -48
	slt $t3, $t0, $t2
	beq $t3, $zero, Error
	slt $t3, $t0, $zero
	bne $t3, $zero, Error
	lb $t1, 3($a0)
	addi $t1, $t1, -48
	slt $t3, $t1, $t2
	beq $t3, $zero, Error
	slt $t3, $t1, $zero
	bne $t3, $zero, Error
	mult $t1, $t2
	mflo $t1
	add $t1, $t1, $t0
	add $v0, $0, $t1
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	

Year:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	addi $t4, $0, 10
	lb $t0, 6($a0)
	addi $t0, $t0, -48
	slt $t3, $t0, $t4
	beq $t3, $zero, Error
	slt $t3, $t0, $zero
	bne $t3, $zero, Error
	mult $t0, $t4
	mflo $t0
	lb $t1, 7($a0)
	addi $t1, $t1, -48
	slt $t3, $t1, $t4
	beq $t3, $zero, Error
	slt $t3, $t1, $zero
	bne $t3, $zero, Error
	add $t0, $t0, $t1
	mult $t0, $t4
	mflo $t0
	lb $t2, 8($a0)
	addi $t2, $t2, -48
	slt $t3, $t2, $t4
	beq $t3, $zero, Error
	slt $t3, $t2, $zero
	bne $t3, $zero, Error
	add $t0, $t0, $t2
	mult $t0, $t4
	mflo $t0
	lb $t5, 9($a0)
	addi $t5, $t5, -48
	slt $t3, $t5, $t4
	beq $t3, $zero, Error
	slt $t3, $t5, $zero
	bne $t3, $zero, Error
	add $t0, $t0, $t5
	add $v0, $0, $t0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	

Error:
	addi $v0, $0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

CheckLeapYear:
	jal LeapYear
	sub $s0, $s0, $v0
	j CheckDayOfMonth

LeapYear:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal Year
	add $t1, $0, $v0
	addi $t2, $0, 400
	div $t1, $t2
	mfhi $t3
	beq $t3, $zero, LaNamNhuan
	addi $t2, $0, 100
	div $t1, $t2
	mfhi $t3
	beq $t3, $zero, KhongLaNamNhuan
	addi $t2, $0, 4
	div $t1, $t2
	mfhi $t3
	beq $t3, $zero, LaNamNhuan
	j KhongLaNamNhuan

LaNamNhuan:
	addi $v0, $0, 1
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

KhongLaNamNhuan:
	addi $v0, $0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

CheckDayOfMonth:
	slt $s4, $s3, $s0
	bne $s4, $zero, Error
	addi $v0, $0, 1
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

Exit_Process:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra



	
	
