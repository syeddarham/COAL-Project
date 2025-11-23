# 🏢 Employee Management System (EMS)

A comprehensive **Employee Management System** built in **x86 Assembly Language** using **MASM32** and the **Irvine32 library**. This project demonstrates low-level programming concepts with a fully functional CRUD application featuring advanced UI elements and data analytics.

---

## 👥 Authors

- **Syed Arham**
- **Malik Zaryab Awan**
- **Mohammad Huzaifa**

---

## 📋 Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [How to Run](#how-to-run)
- [System Architecture](#system-architecture)
- [Menu Options](#menu-options)
- [Technical Details](#technical-details)
- [Code Structure](#code-structure)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

### 🎯 Core Features
- ✅ **Add Employee** - Add new employees with validation
- ✅ **Display All Employees** - View all employees in formatted table
- ✅ **Search by ID** - Find specific employee by ID
- ✅ **Search by Type** - Filter employees by their role
- ✅ **Delete Employee** - Remove employees from system
- ✅ **Update Employee** - Modify employee information

### 💰 Salary Management
- 💵 **Calculate Total Payroll** - Sum of all employee salaries
- 📈 **Give Raise** - Apply fixed amount or percentage raise
- 👑 **Highest Paid Employee** - Find top earner
- 💼 **Lowest Paid Employee** - Find lowest earner

### 📊 Reports & Analytics
- 📈 **Employee Count by Type** - Visual bar chart representation
- 💹 **Salary Distribution** - Average salary and salary range
- 📄 **Export Reports** - Save reports to text file

### 🎨 UI/UX Features
- 🌈 **Color-Coded Interface** - Different colors for headers, success, errors
- 📦 **Box Borders** - ASCII art borders around menus (╔═╗║╚╝)
- 📊 **Status Bar** - Shows total employees count
- ⏳ **Loading Screen** - Animated progress bar on startup
- ✅ **Exit Confirmation** - Prevents accidental exits
- 🧹 **Screen Clearing** - Clean transitions between menus

### 🔒 Data Validation
- ✓ ID validation (positive integers only)
- ✓ Name validation (letters and spaces only)
- ✓ Type validation (1-5 range with menu display)
- ✓ Salary validation (positive integers only)
- ✓ Duplicate ID checking
- ✓ Single owner constraint

### 👔 Employee Types
1. **Owner** (Only one allowed)
2. **Manager**
3. **Senior Developer**
4. **Developer**
5. **Intern**

---

## 🖼️ Screenshots

### Main Menu
```
╔════════════════════════════════════════╗
║ EMPLOYEE MANAGEMENT SYSTEM (EMS)      ║
╚════════════════════════════════════════╝
1. Add Employee
2. Display All Employees
3. Search Employee by ID
4. Search Employees by Type
5. Salary Management
6. Reports & Analytics
7. Exit

Total Employees: 5

Select option (1-7):
```

### Employee Table
```
===== ALL EMPLOYEES =====
ID    Type              Name                 Salary
----  ----------------  ------------------   ------
2551  Owner             Syed Arham              $120000
1001  Manager           Malik Xaryab            $85000
1002  Senior Developer  Muhammad Huzaifa        $95000
1003  Developer         Saad Naeem              $70000
1004  Intern            Abdullah Imran          $30000
```

---

## 🔧 Prerequisites

Before running this project, ensure you have:

1. **MASM32** - Microsoft Macro Assembler
   - Download from: [masm32.com](http://www.masm32.com/)

2. **Irvine32 Library** - Assembly language library
   - Included with MASM32 or download separately

3. **Windows OS** - Required for MASM32 and Irvine32

4. **Text Editor/IDE** (Optional but recommended)
   - Visual Studio Code
   - Visual Studio
   - Notepad++

---

## 💻 Installation

### Step 1: Install MASM32
```bash
# Download MASM32 installer from official website
# Run install.exe
# Default installation path: C:\masm32
```

### Step 2: Clone the Repository
```bash
git clone https://github.com/yourusername/employee-management-system.git
cd employee-management-system
```

### Step 3: Verify Files
Ensure you have:
- `Project.asm` - Main source code
- `README.md` - This file

---

## 🚀 How to Run

### Method 1: Using Command Line

```batch
# Navigate to MASM32 bin directory
cd C:\masm32\bin

# Assemble the code
ml /c /coff /Cp "C:\path\to\Project.asm"

# Link the object file
Link /SUBSYSTEM:CONSOLE "C:\path\to\Project.obj"

# Run the executable
Project.exe
```

### Method 2: Using Batch File

Create `build.bat`:
```batch
@echo off
ml /c /coff /Cp Project.asm
Link /SUBSYSTEM:CONSOLE Project.obj
Project.exe
pause
```

Run:
```batch
build.bat
```

### Method 3: Using Visual Studio

1. Create new project → Empty Project
2. Add `Project.asm` to project
3. Build Solution (Ctrl+Shift+B)
4. Run (F5)

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────┐
│         Main Program Loop           │
│  (User Input & Menu Navigation)     │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │                │
┌──────▼────────┐  ┌───▼───────────┐
│  Core CRUD    │  │  Advanced     │
│  Operations   │  │  Features     │
├───────────────┤  ├───────────────┤
│ • Add         │  │ • Salary Mgmt │
│ • Display     │  │ • Analytics   │
│ • Search      │  │ • Reports     │
│ • Update      │  │ • Export      │
│ • Delete      │  └───────────────┘
└───────┬───────┘
        │
┌───────▼────────────────────────────┐
│      Data Structure (Array)        │
│  MAX_EMPLOYEES = 50                │
│  EMPLOYEE STRUCT:                  │
│    - id      (DWORD)               │
│    - types   (DWORD)               │
│    - salary  (DWORD)               │
│    - name1   (BYTE[24])            │
└────────────────────────────────────┘
```

---

## 📖 Menu Options

### 1️⃣ Add Employee
- Enter Employee ID (validated)
- Select Employee Type from menu
- Enter Employee Name (letters & spaces only)
- Enter Salary (positive integer)
- **Note:** Only one owner allowed

### 2️⃣ Display All Employees
- Shows formatted table with all employees
- Columns: ID, Type, Name, Salary
- Proper alignment and spacing

### 3️⃣ Search Employee by ID
- Enter ID to search
- Displays complete employee details if found

### 4️⃣ Search Employees by Type
- Select type from menu (1-5)
- Shows all employees of selected type

### 5️⃣ Salary Management
- **Calculate Total Payroll** - Shows sum of all salaries
- **Give Raise** - Apply fixed or percentage raise to employee
- **Highest Paid** - Display top earner
- **Lowest Paid** - Display lowest earner

### 6️⃣ Reports & Analytics
- **Employee Count by Type** - Visual bar chart
- **Salary Distribution** - Average and range statistics
- **Export Report** - Save to `ems_report.txt`

### 7️⃣ Exit
- Confirmation prompt (Y/N)
- Clean exit from program

---

## 🔬 Technical Details

### Data Structures

```assembly
EMPLOYEE STRUCT
    id      DWORD ?          ; 4 bytes - Employee ID
    types   DWORD ?          ; 4 bytes - Employee Type (1-5)
    salary  DWORD ?          ; 4 bytes - Salary amount
    name1   BYTE 24 DUP(0)   ; 24 bytes - Employee name
EMPLOYEE ENDS                 ; Total: 36 bytes per employee
```

### Memory Layout
- **Total Array Size:** 50 employees × 36 bytes = 1,800 bytes
- **Current Count:** Tracked by `employeeCount` variable

### Color Codes
```assembly
COLOR_HEADER  = 11  ; Cyan - Headers
COLOR_SUCCESS = 10  ; Green - Success messages
COLOR_ERROR   = 12  ; Red - Error messages
COLOR_NORMAL  = 7   ; White - Normal text
COLOR_MENU    = 14  ; Yellow - Menu borders
```

### Input Validation

| Field   | Validation Rule                           |
|---------|-------------------------------------------|
| ID      | Positive integer (≥ 1)                    |
| Name    | Letters and spaces only (no numbers)      |
| Type    | Integer between 1-5                       |
| Salary  | Positive integer (≥ 1)                    |

---

## 📁 Code Structure

```
Project.asm
├── Data Section (.data)
│   ├── Employee Array
│   ├── String Constants
│   ├── Menu Strings
│   └── Color Definitions
│
├── Code Section (.code)
│   ├── Main Procedure
│   │   └── Main Menu Loop
│   │
│   ├── Core Operations
│   │   ├── AddEmployee
│   │   ├── DisplayAllEmployees
│   │   ├── SearchEmployeeByID
│   │   └── SearchEmployeesByType
│   │
│   ├── Salary Management
│   │   ├── SalaryManagementMenu
│   │   ├── CalculateTotalPayroll
│   │   ├── GiveRaise
│   │   ├── ShowHighestPaid
│   │   └── ShowLowestPaid
│   │
│   ├── Reports & Analytics
│   │   ├── ReportsMenu
│   │   ├── EmployeeCountByType
│   │   ├── SalaryDistribution
│   │   └── ExportReport
│   │
│   ├── Utility Functions
│   │   ├── DisplayTypeMenu
│   │   ├── GetTypeString
│   │   ├── WriteSpaces
│   │   ├── GetDigitCount
│   │   └── GetStringLength
│   │
│   └── UI Features
│       ├── show_loading_screen
│       └── display_percentage
```

---

## 🎓 Learning Outcomes

This project demonstrates:

1. **Low-Level Programming**
   - Direct memory manipulation
   - Register management (EAX, EBX, ECX, EDX, ESI, EDI)
   - Stack operations (PUSH/POP)

2. **Data Structures**
   - Structure definition (STRUCT)
   - Array manipulation
   - Pointer arithmetic

3. **Control Flow**
   - Conditional jumps (JE, JNE, JL, JG)
   - Loops (loop instruction, manual loops)
   - Procedure calls and returns

4. **I/O Operations**
   - Console input/output
   - String manipulation
   - File operations (Export feature)

5. **Algorithm Implementation**
   - Searching algorithms
   - Data validation
   - Mathematical calculations

---

## 🔮 Future Enhancements

### Planned Features
- [ ] File persistence (Save/Load employee data)
- [ ] Sort employees (by ID, Name, Salary)
- [ ] Delete employee functionality
- [ ] Update/Edit employee details
- [ ] Department management
- [ ] Attendance tracking
- [ ] Performance reviews
- [ ] Graphical charts (ASCII art)
- [ ] Database integration
- [ ] Multi-user support
- [ ] Backup and restore
- [ ] Advanced reporting (PDF export)

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/employee-management-system.git
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Commit Changes**
   ```bash
   git commit -m "Add some AmazingFeature"
   ```

4. **Push to Branch**
   ```bash
   git push origin feature/AmazingFeature
   ```

5. **Open Pull Request**

### Contribution Guidelines
- Follow existing code style
- Comment your code thoroughly
- Test all features before submitting
- Update README if adding new features

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Irvine32 Library** - For providing assembly language utilities
- **MASM32** - Microsoft Macro Assembler
- **Computer Organization and Assembly Language (COAL)** - Course instructors and resources
- **Stack Overflow Community** - For assembly language insights

---

## 📞 Contact

- **GitHub:** [@yourusername](https://github.com/yourusername)
- **Email:** your.email@example.com

---

## 📊 Project Statistics

- **Lines of Code:** ~1,500+
- **Functions/Procedures:** 25+
- **Features:** 15+
- **Development Time:** X weeks
- **Language:** x86 Assembly (MASM)

---

## 🐛 Known Issues

Currently no known issues. If you find any bugs, please [create an issue](https://github.com/yourusername/employee-management-system/issues).

---

## 📚 Additional Resources

- [MASM32 Documentation](http://www.masm32.com/)
- [Irvine32 Library Reference](http://kipirvine.com/asm/)
- [x86 Assembly Guide](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html)
- [Intel Architecture Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)

---

<div align="center">

### ⭐ If you found this project helpful, please give it a star! ⭐

Made with ❤️ by ** Syed Arham, Malik Zaryab Awan & Mohammad Huzaifa**

**Computer Organization and Assembly Language (COAL) Project**
**3rd Semester - 2025**

</div>
