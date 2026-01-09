repeat task.wait() until game:IsLoaded()
task.wait(2)

if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load trước đó")
end

local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()
local PROTECTED_CODE = "https://api.junkie-development.de/api/v1/luascripts/public/263a72050e733e52da77bcc7f8a7542cb082be906feaf87557be0442b36e797b/download"

local USER_KEY = getgenv().USER_KEY
if not USER_KEY then return warn("❌ Chưa nhập key") end

local HWID = RbxAnalytics:GetClientId()

local function toTime(date)
    local y,m,d = date:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = y, month = m, day = d,
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

        if v.hwid ~= HWID then
            return warn("❌ Sai HWID")
        end

        -- KHÓA CHẠY LẠI
        getgenv().__SCRIPT_LOADED = true

        loadstring(game:HttpGet(PROTECTED_CODE))()
        return
    end
end

warn("❌ Key không tồn tại")
