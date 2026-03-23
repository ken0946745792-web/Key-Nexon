repeat task.wait() until game:IsLoaded()
task.wait(1)

-- chặn load lại trong cùng 1 lần vào game
if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")

-- chống cache GitHub
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

-- code gốc cần bảo vệ
local PROTECTED_CODE = "https://api.jnkie.com/api/v1/luascripts/public/8cc67c8fd7387e665c0fb86634ed197a0e983114e09b98e780d36f6a17080ece/download"

local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    return warn("❌ Chưa nhập key")
end

local function toTime(date)
    local y,m,d = date:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 23, min = 59, sec = 59
    })
end

local data = HttpService:JSONDecode(game:HttpGet(KEY_URL))
if not data or not data.keys then
    return warn("❌ Dữ liệu key lỗi")
end

for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then
        if os.time() > toTime(v.expire) then
            return warn("❌ Key hết hạn")
        end

        getgenv().__SCRIPT_LOADED = true
        loadstring(game:HttpGet(PROTECTED_CODE))()
        return
    end
end

warn("❌ Key không tồn tại")
