repeat task.wait() until game:IsLoaded()
task.wait(2)

-- chặn load lại trong cùng 1 lần vào game
if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")

-- chống cache GitHub
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

-- Nội dung mới đã thay đổi theo yêu cầu
local License = "NEXON-Q3M8ZK7L1FDR-X92PLT5C7HJB"
local url = "https://structures-casinos-fioricet-your.trycloudflare.com/loader?file=premium&key=" .. License

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

-- Thực thi script gốc sau khi kiểm tra xong (nếu cần logic check key ở đây)
loadstring(game:HttpGet(url))()
