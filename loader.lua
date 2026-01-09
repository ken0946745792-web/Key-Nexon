repeat task.wait() until game:IsLoaded()
task.wait(4)

local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()
local PROTECTED_CODE = "https://api.junkie-development.de/api/v1/luascripts/public/263a72050e733e52da77bcc7f8a7542cb082be906feaf87557be0442b36e797b/download"

print("🔹 Loader start")

local USER_KEY = getgenv().USER_KEY
print("🔹 USER_KEY:", USER_KEY)

if not USER_KEY then
    warn("❌ Chưa nhập USER_KEY")
    return
end

local HWID = RbxAnalytics:GetClientId()
print("🔹 HWID:", HWID)

local function toTime(date)
    local y,m,d = date:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = tonumber(y),
        month = tonumber(m),
        day = tonumber(d),
        hour = 23,
        min = 59,
        sec = 59
    })
end

local ok, raw = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not ok then
    warn("❌ Không tải được keys.json")
    return
end

print("🔹 keys.json loaded")
print(raw)

local data = HttpService:JSONDecode(raw)
if not data or not data.keys then
    warn("❌ keys.json sai cấu trúc")
    return
end

for _, v in ipairs(data.keys) do
    print("🔸 Check key:", v.key)

    if v.key == USER_KEY then
        print("✅ Key trùng")

        if os.time() > toTime(v.expire) then
            warn("❌ Key hết hạn:", v.expire)
            return
        end

        if v.hwid ~= HWID then
            warn("❌ Sai HWID")
            print("Server HWID:", v.hwid)
            print("Client HWID:", HWID)
            return
        end

        print("✅ OK → chạy code")
        loadstring(game:HttpGet(PROTECTED_CODE))()
        return
    end
end

warn("❌ Không tìm thấy key")
