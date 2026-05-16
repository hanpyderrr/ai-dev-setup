# .gitignore Templates

Use the **universal** block for every project. Add type-specific blocks based on detected project types.

---

## universal

```gitignore
# Universal
.DS_Store
Thumbs.db
*.log
*.bak
*.tmp
*.swp
*~
.env
.env.local
secrets.*
credentials.*
```

---

## cpp

```gitignore
# C / C++
*.o
*.obj
*.a
*.lib
*.d
build/
CMakeFiles/
CMakeCache.txt
cmake_install.cmake
compile_commands.json
*.make
Makefile
```

---

## qt

```gitignore
# Qt
*.pro.user
*.pro.user.*
*.qmake.stash
build*/
moc_*.cpp
moc_*.h
qrc_*.cpp
ui_*.h
.qmake.cache
```

---

## python

```gitignore
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.venv/
venv/
env/
*.egg-info/
dist/
.pytest_cache/
.mypy_cache/
.ruff_cache/
```

---

## node

```gitignore
# Node.js
node_modules/
dist/
.next/
out/
*.tsbuildinfo
```

---

## embedded

```gitignore
# Embedded / Keil / IAR
*.hex
*.bin
*.axf
*.elf
OBJ/
DebugConfig/
*.uvguix*
*.scvd
*.orig
Listings/
Objects/
*.map
*.lst
```

---

## rust

```gitignore
# Rust
target/
Cargo.lock
```

---

## go

```gitignore
# Go
vendor/
*.test
*.out
```

---

## makefile

```gitignore
# Makefile project
bin/
obj/
*.out
```
