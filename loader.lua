repeat task.wait() until game:IsLoaded()
task.wait(1)

-- Chặn load lại trong cùng 1 lần vào game
if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")

-- Chống cache GitHub (Danh sách key dự phòng hoặc check hạn)
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    return warn("❌ Chưa nhập key (getgenv().USER_KEY)")
end

-- Hàm chuyển đổi ngày tháng
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

-- Lấy dữ liệu từ GitHub
local success, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not success then
    return warn("❌ Không thể kết nối tới máy chủ xác thực")
end

local data = HttpService:JSONDecode(response)
if not data or not data.keys then
    return warn("❌ Dữ liệu key lỗi")
end

-- Vòng lặp kiểm tra Key
for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then
        -- Kiểm tra hạn sử dụng
        if os.time() > toTime(v.expire) then
            return warn("❌ Key của bạn đã hết hạn vào ngày: " .. v.expire)
        end

        -- ĐÁNH DẤU ĐÃ LOAD
        getgenv().__SCRIPT_LOADED = true
        
        -- CODE GỐC CẦN BẢO VỆ (Đã thay đổi theo yêu cầu của bạn)
        local url = "https://structures-casinos-fioricet-your.trycloudflare.com/loader?file=premium&key=" .. USER_KEY
        
        print("✅ Key hợp lệ! Đang tải script...")
        
        local loadSuccess, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)

        if not loadSuccess then
            warn("❌ Lỗi khi thực thi script chính: " .. tostring(err))
        end
        
        return
    end
end

warn("❌ Key không tồn tại hoặc sai định dạng")
