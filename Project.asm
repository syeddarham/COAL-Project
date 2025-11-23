; ========================================
; EMPLOYEE MANAGEMENT SYSTEM (EMS)
; Authors: Malik Zaryab Awan, Syed Arham, Mohammad Huzaifa
; ========================================

INCLUDE Irvine32.inc

EMPLOYEE STRUCT
    id      DWORD ?
    types   DWORD ?
    salary  DWORD ?
    name1   BYTE 24 DUP(0)
EMPLOYEE ENDS

.data
MAX_EMPLOYEES = 50

TYPE_OWNER = 1
TYPE_MANAGER = 2
TYPE_SENIOR_DEV = 3
TYPE_DEVELOPER = 4
TYPE_INTERN = 5

employees EMPLOYEE MAX_EMPLOYEES DUP(<>)
employeeCount DWORD 0

; Type strings
typeStrings DWORD OFFSET strOwner, OFFSET strManager, OFFSET strSeniorDev, \
                   OFFSET strDeveloper, OFFSET strIntern

strOwner BYTE "Owner",0
strManager BYTE "Manager",0
strSeniorDev BYTE "Senior Developer",0
strDeveloper BYTE "Developer",0
strIntern BYTE "Intern",0

mainMenu BYTE "===== EMPLOYEE MANAGEMENT SYSTEM =====",0dh,0ah
         BYTE "1. Add Employee",0dh,0ah
         BYTE "2. Display All Employees",0dh,0ah
         BYTE "3. Search Employee by ID",0dh,0ah
         BYTE "4. Search Employees by Type",0dh,0ah
         BYTE "5. Exit",0dh,0ah
         BYTE "Select option (1-5): ",0

idPrompt BYTE "Employee ID: ",0
namePrompt BYTE "Employee Name: ",0
salaryPrompt BYTE "Salary $",0
searchPrompt BYTE "Enter Employee ID to search: ",0
typeMenuHeader BYTE "===== EMPLOYEE TYPES =====",0dh,0ah,0
typeDot BYTE ". ",0
typePrompt BYTE "Select type (1-5): ",0

noEmployeesMsg BYTE "No employees in system.",0dh,0ah,0
notFoundMsg BYTE "Employee not found.",0dh,0ah,0
noTypeMatchMsg BYTE "No employees found of this type.",0dh,0ah,0
addedMsg BYTE "Employee added successfully!",0dh,0ah,0
invalidChoice BYTE "Invalid choice!",0dh,0ah,0
exitMsg BYTE "Thank you for using EMS!",0dh,0ah,0
systemFullMsg BYTE "System full!",0dh,0ah,0
ownerExistsMsg BYTE "Owner already exists! Only one owner allowed.",0dh,0ah,0
invalidIdMsg BYTE "Invalid ID! Please enter a positive integer (e.g., 1, 2, 3...).",0dh,0ah,0
invalidNameMsg BYTE "Invalid name! Name must contain only letters and spaces (no numbers or special characters).",0dh,0ah,0
invalidTypeMsg BYTE "Invalid type! Please select a valid option from the menu above (1-5).",0dh,0ah,0
invalidSalaryMsg BYTE "Invalid salary! Please enter a positive integer (e.g., 50000, 75000...).",0dh,0ah,0

employeesHeader BYTE "===== ALL EMPLOYEES =====",0dh,0ah
                BYTE "ID    Type              Name                 Salary",0dh,0ah
                BYTE "----  ----------------  ------------------   ------",0dh,0ah,0

typeEmployeesHeader BYTE "Employees of type: ",0
foundHeader BYTE "===== EMPLOYEE FOUND =====",0dh,0ah,0

; ========== LOADING SCREEN DATA ==========
loading_msg BYTE "Loading Employee Management System...",0dh,0ah,0
progress_bar BYTE "[                    ]",0  ; 20 spaces for progress
percent_msg BYTE " 0%",0
complete_msg BYTE "Loading Complete! Press any key to continue...",0dh,0ah,0
exitConfirmMsg BYTE "Are you sure you want to exit? (Y/N): ",0
exitCancelMsg BYTE "Exit cancelled. Returning to main menu...",0dh,0ah,0

.code
main PROC
    call Clrscr

    ; Display loading screen
    call show_loading_screen
    call Clrscr

main_loop:
    call Clrscr
    mov edx, OFFSET mainMenu
    call WriteString
    call ReadInt
    call Crlf

    cmp eax,1
    je add_emp
    cmp eax,2
    je display_emp
    cmp eax,3
    je search_emp
    cmp eax,4
    je search_type
    cmp eax,5
    je exit_program

    mov edx, OFFSET invalidChoice
    call WriteString
    jmp main_loop

add_emp:
    call AddEmployee
    jmp main_loop

display_emp:
    call DisplayAllEmployees
    jmp main_loop

search_emp:
    call SearchEmployeeByID
    jmp main_loop

search_type:
    call SearchEmployeesByType
    jmp main_loop

exit_program:
    call Clrscr
    mov edx, OFFSET exitConfirmMsg
    call WriteString
    call ReadChar
    call WriteChar  ; Echo the character
    call Crlf
    call Crlf

    ; Check if Y or y
    cmp al, 'Y'
    je confirm_exit
    cmp al, 'y'
    je confirm_exit

    ; User chose not to exit
    mov edx, OFFSET exitCancelMsg
    call WriteString
    call WaitMsg
    jmp main_loop

confirm_exit:
    mov edx, OFFSET exitMsg
    call WriteString
    exit
main ENDP

; =======================================================
;        ADD EMPLOYEE
; =======================================================
AddEmployee PROC
    call Clrscr

    mov eax, employeeCount
    cmp eax, MAX_EMPLOYEES
    jl ok_add

    mov edx, OFFSET systemFullMsg
    call WriteString
    call WaitMsg
    ret

ok_add:
    mov esi, employeeCount
    imul esi, SIZEOF EMPLOYEE ; correct offset

    ; ID
id_input:
    mov edx, OFFSET idPrompt
    call WriteString
    call ReadInt
    cmp eax, 1              ; ID must be >= 1
    jl invalid_id
    mov employees[esi].id, eax
    jmp id_valid

invalid_id:
    mov edx, OFFSET invalidIdMsg
    call WriteString
    jmp id_input

id_valid:

    ; TYPE
type_input:
    call DisplayTypeMenu
    call ReadInt
    cmp eax, 1              ; Type must be >= 1
    jl invalid_type
    cmp eax, 5              ; Type must be <= 5
    jg invalid_type
    mov employees[esi].types, eax
    jmp type_valid

invalid_type:
    mov edx, OFFSET invalidTypeMsg
    call WriteString
    jmp type_input

type_valid:
    ; Check if trying to add owner and one already exists
    cmp employees[esi].types, TYPE_OWNER
    jne continue_add

    ; Search for existing owner
    mov ecx, employeeCount
    cmp ecx, 0
    je continue_add  ; No employees yet, so no owner exists

    mov edi, 0       ; index = 0
check_owner_loop:
    cmp edi, ecx
    jge continue_add  ; No owner found, continue

    mov eax, edi
    imul eax, SIZEOF EMPLOYEE
    mov edx, employees[eax].types
    cmp edx, TYPE_OWNER
    je owner_exists  ; Owner found!

    inc edi
    jmp check_owner_loop

owner_exists:
    mov edx, OFFSET ownerExistsMsg
    call WriteString
    ret

continue_add:
    ; NAME
name_input:
    mov edx, OFFSET namePrompt
    call WriteString
    lea edx, employees[esi].name1
    mov ecx, 23
    call ReadString

    ; Validate name (only letters and spaces)
    lea edi, employees[esi].name1
    mov al, [edi]            ; Check first character
    cmp al, 0                ; Empty name?
    je invalid_name_char     ; Reject empty name

    mov ecx, 0

validate_name_loop:
    mov al, [edi + ecx]
    cmp al, 0                ; End of string?
    je name_valid

    ; Check if letter (A-Z or a-z) or space
    cmp al, 'A'
    jl check_space
    cmp al, 'Z'
    jle valid_char
    cmp al, 'a'
    jl invalid_name_char
    cmp al, 'z'
    jle valid_char
    jmp invalid_name_char

check_space:
    cmp al, ' '              ; Space is allowed
    je valid_char
    jmp invalid_name_char

valid_char:
    inc ecx
    jmp validate_name_loop

invalid_name_char:
    mov edx, OFFSET invalidNameMsg
    call WriteString
    jmp name_input

name_valid:

    ; SALARY
salary_input:
    mov edx, OFFSET salaryPrompt
    call WriteString
    call ReadInt
    cmp eax, 1              ; Salary must be >= 1
    jl invalid_salary
    mov employees[esi].salary, eax
    jmp salary_valid

invalid_salary:
    mov edx, OFFSET invalidSalaryMsg
    call WriteString
    jmp salary_input

salary_valid:

    inc employeeCount
    mov edx, OFFSET addedMsg
    call WriteString

    ret
AddEmployee ENDP

; =======================================================
;  TYPE MENU
; =======================================================
DisplayTypeMenu PROC
    push esi
    mov edx, OFFSET typeMenuHeader
    call WriteString

    mov ecx, 1
    mov esi, OFFSET typeStrings

next_type:
    mov eax, ecx
    call WriteDec

    mov edx, OFFSET typeDot
    call WriteString

    mov edx, [esi]
    call WriteString
    call Crlf

    add esi,4
    inc ecx
    cmp ecx,6
    jl next_type

    mov edx, OFFSET typePrompt
    call WriteString

    pop esi
    ret
DisplayTypeMenu ENDP

GetTypeString PROC
    push esi
    dec eax
    mov esi, OFFSET typeStrings
    mov edx,[esi + eax*4]
    pop esi
    ret
GetTypeString ENDP

; =======================================================
; DISPLAY ALL EMPLOYEES
; =======================================================
DisplayAllEmployees PROC
    call Clrscr

    mov ecx, employeeCount
    cmp ecx,0
    jne show

    mov edx,OFFSET noEmployeesMsg
    call WriteString
    call WaitMsg
    ret

show:
    mov edx, OFFSET employeesHeader
    call WriteString

    mov esi,0

print_loop:
    push ecx
    push esi

    mov eax, esi
    imul eax, SIZEOF EMPLOYEE
    mov ebx, eax              ; save byte offset in ebx

    ; ID (6 chars width)
    mov eax, employees[ebx].id
    push eax                  ; Save ID value
    call WriteDec
    pop eax                   ; Restore ID value
    push eax
    call GetDigitCount        ; Get number of digits in EAX
    mov ecx, 6
    sub ecx, eax              ; Calculate padding
    call WriteSpaces
    pop eax

    ; TYPE (18 chars width)
    mov eax, employees[ebx].types
    call GetTypeString        ; EDX now has string pointer
    push edx
    call WriteString
    pop edx
    push edx
    call GetStringLength      ; Get string length in EAX
    mov ecx, 18
    sub ecx, eax              ; Calculate padding
    call WriteSpaces
    pop edx

    ; NAME (20 chars width)
    lea edx, employees[ebx].name1
    push edx
    call WriteString
    pop edx
    push edx
    call GetStringLength      ; Get string length in EAX
    mov ecx, 20
    sub ecx, eax              ; Calculate padding
    call WriteSpaces
    pop edx

    ; SALARY (10 chars width, right-aligned)
    mov eax, employees[ebx].salary
    push eax
    call GetDigitCount        ; Get number of digits
    mov ecx, 9                ; 9 = 10 - 1 (for $ sign)
    sub ecx, eax              ; Calculate padding
    call WriteSpaces
    mov al,'$'
    call WriteChar
    pop eax
    call WriteDec

    call Crlf

    pop esi
    pop ecx
    inc esi
    dec ecx
    cmp ecx, 0
    jne print_loop

    call Crlf
    call WaitMsg
    ret
DisplayAllEmployees ENDP

; =======================================================
; SEARCH BY ID
; =======================================================
SearchEmployeeByID PROC
    call Clrscr

    mov ecx, employeeCount
    cmp ecx,0
    jne ok

    mov edx, OFFSET noEmployeesMsg
    call WriteString
    call WaitMsg
    ret

ok:
    mov edx, OFFSET searchPrompt
    call WriteString
    call ReadInt
    mov ebx, eax

    mov esi,0

loop_search:
    push esi

    mov eax, esi
    imul eax, SIZEOF EMPLOYEE

    mov edx, employees[eax].id
    cmp edx, ebx
    jne notmatch

    push eax        ; push byte offset for DisplaySingleEmployee
    call DisplaySingleEmployee
    add esp, 4      ; clean up stack
    pop esi
    call WaitMsg
    ret

notmatch:
    pop esi
    inc esi
    dec ecx
    cmp ecx, 0
    jne loop_search

    mov edx, OFFSET notFoundMsg
    call WriteString
    call WaitMsg
    ret
SearchEmployeeByID ENDP

; =======================================================
; SEARCH BY TYPE
; =======================================================
SearchEmployeesByType PROC
    call Clrscr

    mov ecx, employeeCount
    cmp ecx,0
    jne begin

    mov edx, OFFSET noEmployeesMsg
    call WriteString
    call WaitMsg
    ret

begin:
    call DisplayTypeMenu
    call ReadInt
    mov ebx, eax

    cmp ebx,1
    jl bad
    cmp ebx,5
    jg bad

    mov edx, OFFSET typeEmployeesHeader
    call WriteString

    mov eax, ebx
    call GetTypeString
    call WriteString
    call Crlf
    call Crlf

    mov esi,0
    mov edi,0

search_type_loop:
    push esi
    mov eax, esi
    imul eax, SIZEOF EMPLOYEE

    mov edx, employees[eax].types
    cmp edx, ebx
    jne skip

    push eax         ; push byte offset for DisplaySingleEmployee
    call DisplaySingleEmployee
    add esp, 4       ; clean up stack
    inc edi

skip:
    pop esi
    inc esi
    dec ecx
    cmp ecx, 0
    jne search_type_loop

    cmp edi,0
    jne done

    mov edx,OFFSET noTypeMatchMsg
    call WriteString

done:
    call WaitMsg
    ret

bad:
    mov edx, OFFSET invalidChoice
    call WriteString
    call WaitMsg
    ret
SearchEmployeesByType ENDP

; =======================================================
; DISPLAY ONE EMPLOYEE
; =======================================================
DisplaySingleEmployee PROC
    ; expects byte offset in eax (pushed by caller)
    push ebx
    push ecx
    push edx

    mov ebx, eax              ; ebx = byte offset

    mov edx, OFFSET foundHeader
    call WriteString

    ; ID
    mov edx, OFFSET idPrompt
    call WriteString
    mov eax, employees[ebx].id
    call WriteDec
    call Crlf

    ; TYPE
    mov edx, OFFSET typePrompt
    call WriteString
    mov eax, employees[ebx].types
    call GetTypeString
    call WriteString
    call Crlf

    ; NAME
    mov edx, OFFSET namePrompt
    call WriteString
    lea edx, employees[ebx].name1
    call WriteString
    call Crlf

    ; SALARY
    mov edx, OFFSET salaryPrompt
    call WriteString
    mov eax, employees[ebx].salary
    call WriteDec
    call Crlf
    call Crlf

    pop edx
    pop ecx
    pop ebx
    ret
DisplaySingleEmployee ENDP

; =======================================================
; WriteSpaces - writes ECX number of spaces
WriteSpaces PROC
    push eax
    cmp ecx, 0
    jle spaces_done
spaces_loop:
    mov al, ' '
    call WriteChar
    loop spaces_loop
spaces_done:
    pop eax
    ret
WriteSpaces ENDP

; GetDigitCount - returns in EAX the number of digits in EAX (preserves EAX value)
GetDigitCount PROC
    push ebx
    push ecx
    push edx
    mov ebx, eax              ; Save original value
    mov eax, 0               ; Counter
    cmp ebx, 0
    je count_zero
    mov ecx, 10
count_loop:
    cmp ebx, 0
    je count_done
    inc eax
    mov edx, 0
    push eax                 ; Save counter
    mov eax, ebx             ; Number to divide
    div ecx                  ; EAX = quotient, EDX = remainder
    mov ebx, eax             ; Update number
    pop eax                  ; Restore counter
    jmp count_loop
count_zero:
    mov eax, 1
count_done:
    pop edx
    pop ecx
    pop ebx
    ret
GetDigitCount ENDP

; GetStringLength - returns in EAX the length of string pointed to by EDX
GetStringLength PROC
    push edi
    push ecx
    mov edi, edx
    mov ecx, 0FFFFFFFFh      ; Max length
    mov al, 0                ; Search for null terminator
    repne scasb               ; Scan until null found
    mov eax, 0FFFFFFFFh
    sub eax, ecx              ; Calculate length
    dec eax                   ; Adjust for null terminator
    pop ecx
    pop edi
    ret
GetStringLength ENDP

; =======================================================
; LOADING SCREEN PROCEDURES
; =======================================================

; ========== LOADING SCREEN PROCEDURE ==========
show_loading_screen PROC
    push esi
    push ebx
    push ecx
    push edx
    push eax

    ; Display loading message
    mov edx, OFFSET loading_msg
    call WriteString
    call Crlf

    ; Initialize progress bar position
    mov esi, OFFSET progress_bar
    add esi, 1  ; Point to first space inside brackets

    ; Set up for 20 steps (5 seconds with 250ms delay each)
    mov ecx, 20
    mov ebx, 0  ; Current step counter

loading_loop:
    push ecx
    push ebx

    ; Update progress bar
    mov BYTE PTR [esi], 0DBh  ; Fill with block character
    inc esi                   ; Move to next position

    ; Display progress bar
    mov edx, OFFSET progress_bar
    call WriteString

    ; Calculate and display percentage
    mov eax, ebx  ; Current step (0-19)
    inc eax       ; Make it 1-20
    mov edx, 5    ; 100 / 20 = 5% per step
    mul edx       ; EAX = percentage (5, 10, 15, ..., 100)
    call display_percentage

    ; Delay for approximately 250ms
    mov eax, 250
    call Delay

    ; Move cursor back to beginning of line
    mov al, 0Dh
    call WriteChar

    pop ebx
    pop ecx
    inc ebx       ; Increment step counter
    dec ecx
    cmp ecx, 0
    jne loading_loop

    ; Display completion message
    call Crlf
    call Crlf
    mov edx, OFFSET complete_msg
    call WriteString
    call ReadChar  ; Wait for user to press any key

    pop eax
    pop edx
    pop ecx
    pop ebx
    pop esi
    ret
show_loading_screen ENDP

; Display percentage (eax contains percentage value: 5, 10, 15, ..., 100)
display_percentage PROC
    push eax
    push edx
    push ebx

    ; Display percentage
    mov edx, OFFSET percent_msg
    call WriteString

    ; Move cursor back 3 positions to overwrite percentage
    mov al, 8  ; Backspace
    call WriteChar
    call WriteChar
    call WriteChar

    ; Convert percentage to string and display
    pop ebx
    pop edx
    pop eax
    push eax

    ; Check if 100%
    cmp eax, 100
    je show_100

    ; For values less than 100, display two digits
    mov bl, 10
    div bl
    add al, '0'
    call WriteChar

    ; Display ones digit
    mov al, ah
    add al, '0'
    call WriteChar
    jmp show_percent

show_100:
    mov al, '1'
    call WriteChar
    mov al, '0'
    call WriteChar
    mov al, '0'
    call WriteChar

show_percent:
    ; Display percent symbol
    mov al, '%'
    call WriteChar

    pop eax
    ret
display_percentage ENDP
END main