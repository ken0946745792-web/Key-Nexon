repeat task.wait() until game:IsLoaded()
task.wait(1)

-- Chặn load lại trong cùng 1 lần vào game
if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")

-- Chống cache GitHub
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

-- Code gốc cần bảo vệ
local PROTECTED_CODE = "https://api.jnkie.com/api/v1/luascripts/public/8cc67c8fd7387e665c0fb86634ed197a0e983114e09b98e780d36f6a17080ece/download"

local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    return warn("❌ Chưa nhập key (Gán getgenv().USER_KEY trước khi chạy)")
end

local function toTime(dateStr)
    local y, m, d = dateStr:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 23, min = 59, sec = 59
    })
end

local success, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not success then
    return warn("❌ Không thể kết nối tới server Key")
end

local data = HttpService:JSONDecode(response)
if not data or not data.keys then
    return warn("❌ Dữ liệu key lỗi hoặc không đúng định dạng JSON")
end

for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then
        if os.time() > toTime(v.expire) then
            return warn("❌ Key của bạn đã hết hạn!")
        end

        getgenv().__SCRIPT_LOADED = true
        
        -- Thực thi script chính
        local mainScript, err = loadstring(game:HttpGet(PROTECTED_CODE))
        if mainScript then
            mainScript()
        else
            warn("❌ Lỗi khi tải script chính: " .. tostring(err))
        end
        return
    end
end

warn("❌ Key không tồn tại trong hệ thống")
