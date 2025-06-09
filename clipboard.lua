-- Todo List Manager for ComputerCraft

local currentPage = 1
local todo = {}
local width, height = term.getSize()
local line = height - 7

function textCol(color)
  if term.isColor() then
    term.setTextColor(color)
  end
end

function openTODO()
  if fs.exists("todolist") then
    local file = fs.open("todolist", "r")
    local data = file.readAll()
    file.close()
    todo = textutils.unserialize(data) or {}
  else
    todo = {}
  end
end

function saveTODO()
  local file = fs.open("todolist", "w")
  file.write(textutils.serialize(todo))
  file.close()
end

function getVisibleItems()
  local visible = {}
  local openCategories = {}
  for _, item in ipairs(todo) do
    if item.type == "category" then
      table.insert(visible, item)
      openCategories[item.name] = item.open
    elseif item.type == "task" then
      if not item.category or openCategories[item.category] then
        table.insert(visible, item)
      end
    end
  end
  return visible
end

function displayPage(p)
  local visible = getVisibleItems()
  term.setCursorPos(1, 6)
  for i = (1 + (p - 1) * line), (p * line) do
    local item = visible[i]
    if item then
      local y = i - ((p - 1) * line) + 5
      term.setCursorPos(2, y)
      if item.type == "category" then
        textCol(colors.cyan)
        local symbol = item.open and "[-]" or "[+]"
        term.write(symbol .. " " .. item.name)
      elseif item.type == "task" then
        if item.done then
          textCol(colors.red)
          term.write("(X) " .. item.text)
        else
          textCol(colors.green)
          term.write("(V) " .. item.text)
        end
      end
    end
  end

  -- Page info
  local totalPages = math.max(1, math.ceil(#visible / line))
  local pageText = "Page " .. currentPage .. "/" .. totalPages
  textCol(colors.lightGray)
  term.setCursorPos(width - #pageText + 1, height)
  term.write(pageText)
end

function printButtons()
  textCol(colors.white)
  term.setCursorPos(1, 2)
  textCol(colors.green)
  term.write(" Add item")

  term.setCursorPos(1, 3)
  textCol(colors.cyan)
  term.write(" Add category")

  term.setCursorPos(1, 4)
  textCol(colors.yellow)
  term.write(" Cycle page")
end

function addItem()
  term.clear()
  term.setCursorPos(1, 1)
  print("Enter new task:")
  local text = read()

  print("Enter category (or leave empty):")
  local cat = read()

  local exists = false
  for _, item in ipairs(todo) do
    if item.type == "category" and item.name == cat then
      exists = true
      break
    end
  end

  local task = {type = "task", text = text, done = false}
  if exists then task.category = cat end
  table.insert(todo, task)

  print("Task added. Press any key...")
  os.pullEvent("key")
end

function addCategory()
  term.clear()
  term.setCursorPos(1, 1)
  print("Enter new category name:")
  local name = read()
  table.insert(todo, {type = "category", name = name, open = true})
  print("Category added. Press any key...")
  os.pullEvent("key")
end

function toggleDoneOrToggleCategory(index)
  local visible = getVisibleItems()
  local item = visible[index]
  if not item then return end

  if item.type == "task" then
    item.done = not item.done
  elseif item.type == "category" then
    for _, cat in ipairs(todo) do
      if cat.type == "category" and cat.name == item.name then
        cat.open = not cat.open
        break
      end
    end
  end
end

-- Main
openTODO()
term.clear()
printButtons()
displayPage(currentPage)

while true do
  local event, button, x, y = os.pullEvent("mouse_click")

  if y == 2 and x <= 14 then
    addItem()
  elseif y == 3 and x <= 16 then
    addCategory()
  elseif y == 4 and x <= 14 then
    local total = #getVisibleItems()
    local totalPages = math.max(1, math.ceil(total / line))
    currentPage = (currentPage % totalPages) + 1
  elseif y >= 6 and y < 6 + line then
    local index = ((currentPage - 1) * line) + (y - 5)
    toggleDoneOrToggleCategory(index)
  end

  term.clear()
  printButtons()
  displayPage(currentPage)
  saveTODO()
end
