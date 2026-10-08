# Sổ Giao Ca – bản Supabase + Vercel

## 1. Tạo Supabase
1. Vào supabase.com, tạo project mới (gói Free), đặt mật khẩu database, chọn vùng gần Việt Nam (Singapore).
2. Vào **SQL Editor → New query**, dán toàn bộ `schema.sql`, bấm **Run**.
3. Vào **Authentication → Providers → Email**, tắt **Confirm email** (để nhân viên đăng ký xong đăng nhập được ngay).
4. Vào **Project Settings → API**, copy **Project URL** và **anon public key**.

## 2. Điền cấu hình
Mở `index.html`, tìm dòng đầu phần `<script>` và thay:
`SUPABASE_URL` = Project URL, `SUPABASE_ANON_KEY` = anon public key.
(anon key là khóa công khai, an toàn khi để trong file vì dữ liệu đã được khóa bằng RLS trong schema.sql.)

## 3. Đưa lên Vercel
1. Tạo repo GitHub mới, tải `index.html` lên thư mục gốc.
2. Vercel → **Add New → Project** → chọn repo → Framework: **Other** → **Deploy**.
3. Nhận link `ten-du-an.vercel.app`; tên miền riêng ở **Settings → Domains**.

## 4. Dùng lần đầu
1. **Anh đăng ký tài khoản đầu tiên trước** → tự thành **Admin**.
2. Nhân viên mở link → Tạo tài khoản → bấm **Gửi yêu cầu truy cập**.
3. Admin vào **👥 Người dùng** → chọn role → **Duyệt**.

## Lưu ý
- Quyền thêm/xóa người dùng và tạo role được khóa ở phía máy chủ.
- Quyền "chỉ xem", "xóa mục người khác" chỉ chặn ở giao diện; mọi thành viên đã duyệt vẫn ghi được dữ liệu sổ.
- Bản này không dùng được trong claude.ai, chỉ chạy khi đã điền Supabase.
