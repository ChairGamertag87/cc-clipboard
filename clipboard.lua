-- Variables principales
local currentPage = 1
local todo = {}
local clipboard = nil

local width, height = term.getSize()
local line = height - 7 -- espace pour liste

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

function displayPage(p)
    term.setCursorPos(1,6)
    for i = (1 + (p-1)*line), (p*line) do
        local item = todo[i]
        if item then
            term.setCursorPos(2, i - ((p-1)*line) + 5)
            if item.done then
                textCol(colors.red)
                term.write("(X) " .. item.text)
            else
                textCol(colors.green)
                term.write("(V) " .. item.text)
            end
        end
    end

    -- Afficher la page actuelle en bas à droite
    local totalPages = math.max(1, math.ceil(#todo / line))
    local pageText = "Page "..currentPage.."/"..totalPages
    textCol(colors.lightGray)
    term.setCursorPos(width - #pageText + 1, height)
    term.write(pageText)
end

function printButtons()
    textCol(colors.white)
    term.setCursorPos(1,2)
    textCol(colors.green)
    term.write(" Add item")

    term.setCursorPos(1,4)
    textCol(colors.yellow)
    term.write(" Cycle page")

    term.setCursorPos(15,2)
    textCol(colors.cyan)
    term.write(" Copy item")

    term.setCursorPos(15,4)
    textCol(colors.magenta)
    term.write(" Paste item")
end

function addItem()
    term.clear()
    term.setCursorPos(1,1)
    textCol(colors.white)
    print("Please enter new item:")
    local input = read()

    table.insert(todo, 1, {text = input, done = false})

    print("Item added! Press any key to continue...")
    os.pullEvent("key")
end

function copyItem(itm)
    if todo[itm] then
        clipboard = {text = todo[itm].text, done = todo[itm].done}
    end
end

function pasteItem()
    if clipboard then
        table.insert(todo, 1, {text = clipboard.text, done = clipboard.done})
    end
end

function toggleDone(itm)
    if todo[itm] then
        todo[itm].done = not todo[itm].done
    end
end

-- Programme principal
openTODO()
term.clear()
printButtons()
displayPage(currentPage)

while true do
    local event, button, x, y = os.pullEvent("mouse_click")

    if y == 2 and x <= 14 then
        addItem()
    elseif y == 4 and x <= 14 then
        if currentPage >= math.ceil(#todo / line) then
            currentPage = 1
        else
            currentPage = currentPage + 1
        end
    elseif y == 2 and x >= 15 then
        local itm = ((currentPage-1)*line)+1
        copyItem(itm)
    elseif y == 4 and x >= 15 then
        pasteItem()
    elseif y >= 6 and y < 6+line then
        local itm = ((currentPage-1)*line) + (y-5)
        if todo[itm] then
            toggleDone(itm)
        end
    end

    term.clear()
    printButtons()
    displayPage(currentPage)
    saveTODO()
end
