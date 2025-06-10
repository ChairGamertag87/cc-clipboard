# 📋 TODO List Manager for ComputerCraft (CraftOS 1.8)

This is a simple but powerful **Todo List Manager** designed for **ComputerCraft** computers under **CraftOS 1.8**.  
It allows you to easily add and mark tasks and categories using a clean graphical interface, **without needing a monitor** — just your computer screen!

---

## ✨ Features

- ✅ Add and manage tasks via a user interface  
- 📂 Supports **categories** with collapsible/expandable sections  
- 📌 Tasks can be marked as **done** (✔) or **not done** (✘)  
- 💾 Tasks and categories are stored in a file (`todolist`) using `textutils.serialize`  
- 🔁 Pagination support with page indicators at the bottom-right corner  
- 🖱️ Click to toggle task completion  
- 🗂️ Add tasks to specific categories or to a general "Uncategorized" section  
- 🧽 Auto-save on every interaction

---

## 📜 Requirements

- A working **ComputerCraft** installation.
- **No external monitor needed** — everything happens directly on the computer screen.

---

## 🧠 How It Works

1. **Startup**: Loads all tasks and categories from the `todolist` file  
2. **UI**: Displays a clean, categorized view of all tasks  
3. **Mouse Input**:  
   - Click “Add item” to input a new task via the terminal  
   - Click “Cycle page” to go to the next page  
   - Click a task to toggle its completion (✔ ↔ ✘)  
   - Click a category to collapse/expand it  
4. **Saving**: Automatically updates the file after every change

---

## ➕ Adding Tasks

When adding a task:
- You'll be asked for the **task description**
- Then asked for a **category name**
- If the category exists, the task is added inside it  
- Otherwise, it's added uncategorized

---

## 🗑 Removing Tasks

Tasks are not deleted directly — instead:
- Mark a task as done or undone by clicking on it  
- (You can manually remove tasks from the file if needed)

---

## 📂 File Storage

All data is stored in a file named `todolist` in serialized Lua table format.

Each entry can be:

### Task:
```lua
{
  type = "task",
  text = "Example task",
  done = false,
  category = "MyCategory", -- optional
}
```

### Category:
```lua
{
  type = "category",
  name = "MyCategory",
  open = true, -- or false if collapsed
}
```

- If the computer crashes or reboots, your tasks will be restored when you reopen the program.

---


## 🎨 Screenshot
![img](img.png)


Inspired by [somebody](https://pastebin.com/krRrrwBb)
