# settings.json Permission Lists

Always include the **universal** block. Add type-specific blocks for each detected project type.

---

## universal

```json
"Bash(git *)",
"Bash(git status)",
"Bash(git log *)",
"Bash(git diff *)",
"Bash(git add *)",
"Bash(git commit *)",
"Bash(ls *)",
"Bash(ls -la *)",
"Bash(cat *)",
"Bash(head *)",
"Bash(tail *)",
"Bash(find . *)",
"Bash(echo *)"
```

---

## cpp

```json
"Bash(cmake *)",
"Bash(cmake --build *)",
"Bash(make *)",
"Bash(make clean)",
"Bash(gcc *)",
"Bash(g++ *)",
"Bash(./compile.sh)",
"Bash(./clean.sh)",
"Bash(./build.sh)"
```

---

## qt

```json
"Bash(qmake *)",
"Bash(make *)",
"Bash(make clean)"
```

---

## python

```json
"Bash(python *)",
"Bash(python3 *)",
"Bash(pip *)",
"Bash(pip3 *)",
"Bash(uv *)",
"Bash(pytest *)",
"Bash(ruff *)"
```

---

## node

```json
"Bash(npm *)",
"Bash(npx *)",
"Bash(node *)",
"Bash(yarn *)",
"Bash(pnpm *)"
```

---

## embedded

```json
"Bash(arm-linux-gnueabihf-gcc *)",
"Bash(arm-linux-gnueabihf-g++ *)",
"Bash(make *)",
"Bash(make clean)",
"Bash(objcopy *)",
"Bash(objdump *)"
```

---

## rust

```json
"Bash(cargo *)",
"Bash(rustc *)",
"Bash(rustfmt *)"
```

---

## go

```json
"Bash(go *)",
"Bash(gofmt *)"
```

---

## makefile

```json
"Bash(make *)",
"Bash(make clean)",
"Bash(make run)"
```

---

## Full settings.json example (cpp + qt project)

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(find . *)",
      "Bash(cmake *)",
      "Bash(cmake --build *)",
      "Bash(make *)",
      "Bash(make clean)",
      "Bash(gcc *)",
      "Bash(g++ *)",
      "Bash(./compile.sh)",
      "Bash(./clean.sh)",
      "Bash(qmake *)"
    ]
  }
}
```
