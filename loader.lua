repeat task.wait() until game:IsLoaded()
task.wait(6)

local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local KEY_URL = "https://raw.githubusercontent.com/USERNAME/REPONAME/main/keys.json"
local PROTECTED_CODE = "https://api.junkie-development.de/api/v1/luascripts/public/263a72050e733e52da77bcc7f8a7542cb082be906feaf87557be0442b36e797b/download"

local USER_KEY = getgenv().USER_KEY
if not USER_KEY then return warn("❌ Chưa nhập key") end

local HWID = RbxAnalytics:GetClientId()
local TODAY = os.date("%Y-%m-%d")

local data = HttpService:JSONDecode(game:HttpGet(KEY_URL))

for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then

        if TODAY > v.expire then
            return warn("❌ Key hết hạn")
        end

        -- CHƯA BIND → IN HWID & KHÓA LUÔN
        if v.hwid == "" then
            warn("🔒 KEY CHƯA KÍCH HOẠT")
            warn("HWID THIẾT BỊ:")
            warn(HWID)
            warn("👉 Key này sẽ CHỈ dùng cho thiết bị này")
            return
        end

        -- ĐÃ BIND → SO SÁNH
        if v.hwid ~= HWID then
            return warn("❌ Key đã bị khóa trên thiết bị khác")
        end

        -- OK
        loadstring(game:HttpGet(PROTECTED_CODE))()
        return
    end
end

warn("❌ Key không tồn tại")
